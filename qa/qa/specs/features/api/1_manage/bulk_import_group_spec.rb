# frozen_string_literal: true

module QA
  RSpec.describe 'Manage', :requires_admin do
    describe 'Bulk group import' do
      let!(:staging?) { Runtime::Scenario.gitlab_address.include?('staging.gitlab.com') }

      let(:import_wait_duration) { { max_duration: 300, sleep_interval: 2 } }
      let(:admin_api_client) { Runtime::API::Client.as_admin }
      let(:user) do
        Resource::User.fabricate_via_api! do |usr|
          usr.api_client = admin_api_client
          usr.hard_delete_on_api_removal = true
        end
      end

      let(:api_client) { Runtime::API::Client.new(user: user) }

      let(:sandbox) do
        Resource::Sandbox.fabricate_via_api! do |group|
          group.api_client = admin_api_client
        end
      end

      let(:source_group) do
        Resource::Sandbox.fabricate_via_api! do |group|
          group.api_client = api_client
          group.path = "source-group-for-import-#{SecureRandom.hex(4)}"
        end
      end

      let(:imported_group) do
        Resource::BulkImportGroup.fabricate_via_api! do |group|
          group.api_client = api_client
          group.sandbox = sandbox
          group.source_group_path = source_group.path
        end
      end

      before do
        Runtime::Feature.enable(:top_level_group_creation_enabled) if staging?

        sandbox.add_member(user, Resource::Members::AccessLevel::MAINTAINER)
      end

      context 'with subgroups and labels' do
        let(:subgroup) do
          Resource::Group.fabricate_via_api! do |group|
            group.api_client = api_client
            group.sandbox = source_group
            group.path = "subgroup-for-import-#{SecureRandom.hex(4)}"
          end
        end

        let(:imported_subgroup) do
          Resource::Group.init do |group|
            group.api_client = api_client
            group.sandbox = imported_group
            group.path = subgroup.path
          end
        end

        before do
          Resource::GroupLabel.fabricate_via_api! do |label|
            label.api_client = api_client
            label.group = source_group
            label.title = "source-group-#{SecureRandom.hex(4)}"
          end
          Resource::GroupLabel.fabricate_via_api! do |label|
            label.api_client = api_client
            label.group = subgroup
            label.title = "subgroup-#{SecureRandom.hex(4)}"
          end
        end

        it(
          'successfully imports groups and labels',
          testcase: 'https://gitlab.com/gitlab-org/quality/testcases/-/quality/test_cases/1873'
        ) do
          expect { imported_group.import_status }.to eventually_eq('finished').within(import_wait_duration)

          aggregate_failures do
            expect(imported_group.reload!).to eq(source_group)
            expect(imported_group.labels).to include(*source_group.labels)

            expect(imported_subgroup.reload!).to eq(subgroup)
            expect(imported_subgroup.labels).to include(*subgroup.labels)
          end
        end
      end

      context 'with milestones' do
        let(:source_milestone) do
          Resource::GroupMilestone.fabricate_via_api! do |milestone|
            milestone.api_client = api_client
            milestone.group = source_group
          end
        end

        before do
          source_milestone
        end

        it(
          'successfully imports group milestones',
          testcase: 'https://gitlab.com/gitlab-org/quality/testcases/-/quality/test_cases/2245'
        ) do
          expect { imported_group.import_status }.to eventually_eq('finished').within(import_wait_duration)

          imported_milestone = imported_group.reload!.milestones.find { |ml| ml.title == source_milestone.title }
          aggregate_failures do
            expect(imported_milestone).to eq(source_milestone)
            expect(imported_milestone.iid).to eq(source_milestone.iid)
            expect(imported_milestone.created_at).to eq(source_milestone.created_at)
            expect(imported_milestone.updated_at).to eq(source_milestone.updated_at)
          end
        end
      end

      after do
        user.remove_via_api!
      ensure
        Runtime::Feature.disable(:top_level_group_creation_enabled) if staging?
      end
    end
  end
end
