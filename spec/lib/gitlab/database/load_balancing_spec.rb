# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Database::LoadBalancing do
  describe '.proxy' do
    before do
      @previous_proxy = ActiveRecord::Base.load_balancing_proxy

      ActiveRecord::Base.load_balancing_proxy = connection_proxy
    end

    after do
      ActiveRecord::Base.load_balancing_proxy = @previous_proxy
    end

    context 'when configured' do
      let(:connection_proxy) { double(:connection_proxy) }

      it 'returns the connection proxy' do
        expect(subject.proxy).to eq(connection_proxy)
      end
    end

    context 'when not configured' do
      let(:connection_proxy) { nil }

      it 'returns nil' do
        expect(subject.proxy).to be_nil
      end

      it 'tracks an error to sentry' do
        expect(Gitlab::ErrorTracking).to receive(:track_exception).with(
          an_instance_of(subject::ProxyNotConfiguredError)
        )

        subject.proxy
      end
    end
  end

  describe '.configuration' do
    it 'returns the configuration for the load balancer' do
      raw = ActiveRecord::Base.connection_db_config.configuration_hash
      cfg = described_class.configuration

      # There isn't much to test here as the load balancing settings might not
      # (and likely aren't) set when running tests.
      expect(cfg.pool_size).to eq(raw[:pool])
    end
  end

  describe '.enable?' do
    before do
      allow(described_class.configuration)
        .to receive(:hosts)
        .and_return(%w(foo))
    end

    it 'returns false when no hosts are specified' do
      allow(described_class.configuration).to receive(:hosts).and_return([])

      expect(described_class.enable?).to eq(false)
    end

    it 'returns true when Sidekiq is being used' do
      allow(Gitlab::Runtime).to receive(:sidekiq?).and_return(true)

      expect(described_class.enable?).to eq(true)
    end

    it 'returns false when running inside a Rake task' do
      allow(Gitlab::Runtime).to receive(:rake?).and_return(true)

      expect(described_class.enable?).to eq(false)
    end

    it 'returns true when load balancing should be enabled' do
      allow(Gitlab::Runtime).to receive(:sidekiq?).and_return(false)

      expect(described_class.enable?).to eq(true)
    end

    it 'returns true when service discovery is enabled' do
      allow(described_class.configuration).to receive(:hosts).and_return([])
      allow(Gitlab::Runtime).to receive(:sidekiq?).and_return(false)

      allow(described_class.configuration)
        .to receive(:service_discovery_enabled?)
        .and_return(true)

      expect(described_class.enable?).to eq(true)
    end
  end

  describe '.configured?' do
    it 'returns true when hosts are configured' do
      allow(described_class.configuration)
        .to receive(:hosts)
        .and_return(%w[foo])

      expect(described_class.configured?).to eq(true)
    end

    it 'returns true when service discovery is enabled' do
      allow(described_class.configuration).to receive(:hosts).and_return([])
      allow(described_class.configuration)
        .to receive(:service_discovery_enabled?)
        .and_return(true)

      expect(described_class.configured?).to eq(true)
    end

    it 'returns false when neither service discovery nor hosts are configured' do
      allow(described_class.configuration).to receive(:hosts).and_return([])
      allow(described_class.configuration)
        .to receive(:service_discovery_enabled?)
        .and_return(false)

      expect(described_class.configured?).to eq(false)
    end
  end

  describe '.configure_proxy' do
    before do
      allow(ActiveRecord::Base).to receive(:load_balancing_proxy=)
    end

    it 'configures the connection proxy' do
      described_class.configure_proxy

      expect(ActiveRecord::Base).to have_received(:load_balancing_proxy=)
        .with(Gitlab::Database::LoadBalancing::ConnectionProxy)
    end

    context 'when service discovery is enabled' do
      it 'runs initial service discovery when configuring the connection proxy' do
        discover = instance_spy(Gitlab::Database::LoadBalancing::ServiceDiscovery)

        allow(described_class.configuration)
          .to receive(:service_discovery)
          .and_return({ record: 'foo' })

        expect(Gitlab::Database::LoadBalancing::ServiceDiscovery)
          .to receive(:new)
          .with(
            an_instance_of(Gitlab::Database::LoadBalancing::LoadBalancer),
            an_instance_of(Hash)
          )
          .and_return(discover)

        expect(discover).to receive(:perform_service_discovery)

        described_class.configure_proxy
      end
    end
  end

  describe '.start_service_discovery' do
    it 'does not start if service discovery is disabled' do
      expect(Gitlab::Database::LoadBalancing::ServiceDiscovery)
        .not_to receive(:new)

      described_class.start_service_discovery
    end

    it 'starts service discovery if enabled' do
      allow(described_class.configuration)
        .to receive(:service_discovery_enabled?)
        .and_return(true)

      instance = double(:instance)
      config = Gitlab::Database::LoadBalancing::Configuration
        .new(ActiveRecord::Base)
      lb = Gitlab::Database::LoadBalancing::LoadBalancer.new(config)
      proxy = Gitlab::Database::LoadBalancing::ConnectionProxy.new(lb)

      allow(described_class)
        .to receive(:proxy)
        .and_return(proxy)

      expect(Gitlab::Database::LoadBalancing::ServiceDiscovery)
        .to receive(:new)
        .with(lb, an_instance_of(Hash))
        .and_return(instance)

      expect(instance)
        .to receive(:start)

      described_class.start_service_discovery
    end
  end

  describe '.db_role_for_connection' do
    context 'when the load balancing is not configured' do
      let(:connection) { ActiveRecord::Base.connection }

      it 'returns primary' do
        expect(described_class.db_role_for_connection(connection)).to eq(:primary)
      end
    end

    context 'when the NullPool is used for connection' do
      let(:pool) { ActiveRecord::ConnectionAdapters::NullPool.new }
      let(:connection) { double(:connection, pool: pool) }

      it 'returns unknown' do
        expect(described_class.db_role_for_connection(connection)).to eq(:unknown)
      end
    end

    context 'when the load balancing is configured' do
      let(:db_host) { ActiveRecord::Base.connection_pool.db_config.host }
      let(:config) do
        Gitlab::Database::LoadBalancing::Configuration
          .new(ActiveRecord::Base, [db_host])
      end

      let(:load_balancer) { described_class::LoadBalancer.new(config) }
      let(:proxy) { described_class::ConnectionProxy.new(load_balancer) }

      context 'when a proxy connection is used' do
        it 'returns :unknown' do
          expect(described_class.db_role_for_connection(proxy)).to eq(:unknown)
        end
      end

      context 'when a read connection is used' do
        it 'returns :replica' do
          proxy.load_balancer.read do |connection|
            expect(described_class.db_role_for_connection(connection)).to eq(:replica)
          end
        end
      end

      context 'when a read_write connection is used' do
        it 'returns :primary' do
          proxy.load_balancer.read_write do |connection|
            expect(described_class.db_role_for_connection(connection)).to eq(:primary)
          end
        end
      end
    end
  end

  # For such an important module like LoadBalancing, full mocking is not
  # enough. This section implements some integration tests to test a full flow
  # of the load balancer.
  # - A real model with a table backed behind is defined
  # - The load balancing module is set up for this module only, as to prevent
  # breaking other tests. The replica configuration is cloned from the test
  # configuraiton.
  # - In each test, we listen to the SQL queries (via sql.active_record
  # instrumentation) while triggering real queries from the defined model.
  # - We assert the desinations (replica/primary) of the queries in order.
  describe 'LoadBalancing integration tests', :db_load_balancing, :delete do
    before(:all) do
      ActiveRecord::Schema.define do
        create_table :load_balancing_test, force: true do |t|
          t.string :name, null: true
        end
      end
    end

    after(:all) do
      ActiveRecord::Schema.define do
        drop_table :load_balancing_test, force: true
      end
    end

    let(:model) do
      Class.new(ApplicationRecord) do
        self.table_name = "load_balancing_test"
      end
    end

    before do
      model.singleton_class.prepend ::Gitlab::Database::LoadBalancing::ActiveRecordProxy
    end

    where(:queries, :include_transaction, :expected_results) do
      [
        # Read methods
        [-> { model.first }, false, [:replica]],
        [-> { model.find_by(id: 123) }, false, [:replica]],
        [-> { model.where(name: 'hello').to_a }, false, [:replica]],

        # Write methods
        [-> { model.create!(name: 'test1') }, false, [:primary]],
        [
          -> {
            instance = model.create!(name: 'test1')
            instance.update!(name: 'test2')
          },
          false, [:primary, :primary]
        ],
        [-> { model.update_all(name: 'test2') }, false, [:primary]],
        [
          -> {
            instance = model.create!(name: 'test1')
            instance.destroy!
          },
          false, [:primary, :primary]
        ],
        [-> { model.delete_all }, false, [:primary]],

        # Custom query
        [-> { model.connection.exec_query('SELECT 1').to_a }, false, [:primary]],

        # Reads after a write
        [
          -> {
            model.first
            model.create!(name: 'test1')
            model.first
            model.find_by(name: 'test1')
          },
          false, [:replica, :primary, :primary, :primary]
        ],

        # Inside a transaction
        [
          -> {
            model.transaction do
              model.find_by(name: 'test1')
              model.create!(name: 'test1')
              instance = model.find_by(name: 'test1')
              instance.update!(name: 'test2')
            end
            model.find_by(name: 'test1')
          },
          true, [:primary, :primary, :primary, :primary, :primary, :primary, :primary]
        ],

        # Nested transaction
        [
          -> {
            model.transaction do
              model.transaction do
                model.create!(name: 'test1')
              end
              model.update_all(name: 'test2')
            end
            model.find_by(name: 'test1')
          },
          true, [:primary, :primary, :primary, :primary, :primary]
        ],

        # Read-only transaction
        [
          -> {
            model.transaction do
              model.first
              model.where(name: 'test1').to_a
            end
          },
          true, [:primary, :primary, :primary, :primary]
        ],

        # use_primary
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary do
              model.first
              model.where(name: 'test1').to_a
            end
            model.first
          },
          false, [:primary, :primary, :replica]
        ],

        # use_primary!
        [
          -> {
            model.first
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary!
            model.where(name: 'test1').to_a
          },
          false, [:replica, :primary]
        ],

        # use_replicas_for_read_queries does not affect read queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.where(name: 'test1').to_a
            end
          },
          false, [:replica]
        ],

        # use_replicas_for_read_queries does not affect write queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.create!(name: 'test1')
            end
          },
          false, [:primary]
        ],

        # use_replicas_for_read_queries does not affect ambiguous queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.connection.exec_query("SELECT 1")
            end
          },
          false, [:primary]
        ],

        # use_replicas_for_read_queries ignores use_primary! for read queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary!
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.where(name: 'test1').to_a
            end
          },
          false, [:replica]
        ],

        # use_replicas_for_read_queries adheres use_primary! for write queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary!
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.create!(name: 'test1')
            end
          },
          false, [:primary]
        ],

        # use_replicas_for_read_queries adheres use_primary! for ambiguous queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary!
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.connection.exec_query('SELECT 1')
            end
          },
          false, [:primary]
        ],

        # use_replicas_for_read_queries ignores use_primary blocks
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary do
              ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
                model.where(name: 'test1').to_a
              end
            end
          },
          false, [:replica]
        ],

        # use_replicas_for_read_queries ignores a session already performed write
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.write!
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              model.where(name: 'test1').to_a
            end
          },
          false, [:replica]
        ],

        # fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.first
              model.where(name: 'test1').to_a
            end
          },
          false, [:replica, :replica]
        ],

        # fallback_to_replicas_for_ambiguous_queries for read-only transaction
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.transaction do
                model.first
                model.where(name: 'test1').to_a
              end
            end
          },
          false, [:replica, :replica]
        ],

        # A custom read query inside fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.connection.exec_query("SELECT 1")
            end
          },
          false, [:replica]
        ],

        # A custom read query inside a transaction fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.transaction do
                model.connection.exec_query("SET LOCAL statement_timeout = 5000")
                model.count
              end
            end
          },
          true, [:replica, :replica, :replica, :replica]
        ],

        # fallback_to_replicas_for_ambiguous_queries after a write
        [
          -> {
            model.create!(name: 'Test1')
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.connection.exec_query("SELECT 1")
            end
          },
          false, [:primary, :primary]
        ],

        # fallback_to_replicas_for_ambiguous_queries after use_primary!
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary!
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.connection.exec_query("SELECT 1")
            end
          },
          false, [:primary]
        ],

        # fallback_to_replicas_for_ambiguous_queries inside use_primary
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_primary do
              ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
                model.connection.exec_query("SELECT 1")
              end
            end
          },
          false, [:primary]
        ],

        # use_primary inside fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              ::Gitlab::Database::LoadBalancing::Session.current.use_primary do
                model.connection.exec_query("SELECT 1")
              end
            end
          },
          false, [:primary]
        ],

        # A write query inside fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
              model.connection.exec_query("SELECT 1")
              model.delete_all
              model.connection.exec_query("SELECT 1")
            end
          },
          false, [:replica, :primary, :primary]
        ],

        # use_replicas_for_read_queries incorporates with fallback_to_replicas_for_ambiguous_queries
        [
          -> {
            ::Gitlab::Database::LoadBalancing::Session.current.use_replicas_for_read_queries do
              ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
                model.connection.exec_query('SELECT 1')
                model.where(name: 'test1').to_a
              end
            end
          },
          false, [:replica, :replica]
        ]
      ]
    end

    with_them do
      it 'redirects queries to the right roles' do
        roles = []

        subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |event|
          payload = event.payload

          assert =
            if payload[:name] == 'SCHEMA'
              false
            elsif payload[:name] == 'SQL' # Custom query
              true
            else
              keywords = %w[load_balancing_test]
              keywords += %w[begin commit] if include_transaction
              keywords.any? { |keyword| payload[:sql].downcase.include?(keyword) }
            end

          if assert
            db_role = ::Gitlab::Database::LoadBalancing.db_role_for_connection(payload[:connection])
            roles << db_role
          end
        end

        self.instance_exec(&queries)

        expect(roles).to eql(expected_results)
      ensure
        ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
      end
    end

    context 'custom connection handling' do
      where(:queries, :expected_role) do
        [
          # Reload cache. The schema loading queries should be handled by
          # primary.
          [
            -> {
              model.connection.clear_cache!
              model.connection.schema_cache.add('users')
              model.connection.pool.release_connection
            },
            :primary
          ],

          # Call model's connection method
          [
            -> {
              connection = model.connection
              connection.select_one('SELECT 1')
              connection.pool.release_connection
            },
            :replica
          ],

          # Retrieve connection via #retrieve_connection
          [
            -> {
              connection = model.retrieve_connection
              connection.select_one('SELECT 1')
              connection.pool.release_connection
            },
            :primary
          ]
        ]
      end

      with_them do
        it 'redirects queries to the right roles' do
          roles = []

          # If we don't run any queries, the pool may be a NullPool. This can
          # result in some tests reporting a role as `:unknown`, even though the
          # tests themselves are correct.
          #
          # To prevent this from happening we simply run a simple query to
          # ensure the proper pool type is put in place. The exact query doesn't
          # matter, provided it actually runs a query and thus creates a proper
          # connection pool.
          model.count

          subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |event|
            role = ::Gitlab::Database::LoadBalancing.db_role_for_connection(event.payload[:connection])
            roles << role if role.present?
          end

          self.instance_exec(&queries)

          expect(roles).to all(eql(expected_role))
        ensure
          ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
        end
      end
    end

    context 'a write inside a transaction inside fallback_to_replicas_for_ambiguous_queries block' do
      it 'raises an exception' do
        expect do
          ::Gitlab::Database::LoadBalancing::Session.current.fallback_to_replicas_for_ambiguous_queries do
            model.transaction do
              model.first
              model.create!(name: 'hello')
            end
          end
        end.to raise_error(Gitlab::Database::LoadBalancing::ConnectionProxy::WriteInsideReadOnlyTransactionError)
      end
    end
  end
end
