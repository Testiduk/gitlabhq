# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Database::PreventCrossJoins do
  context 'when running in a default scope' do
    context 'when only non-CI tables are used' do
      it 'does not raise exception' do
        expect { main_only_query }.not_to raise_error
      end
    end

    context 'when only CI tables are used' do
      it 'does not raise exception' do
        expect { ci_only_query }.not_to raise_error
      end
    end

    context 'when CI and non-CI tables are used' do
      it 'raises exception' do
        expect { main_and_ci_query }.to raise_error(
          described_class::CrossJoinAcrossUnsupportedTablesError)
      end

      context 'when allow_cross_joins_across_databases is used' do
        it 'does not raise exception' do
          expect { main_and_ci_query_allowlisted }.not_to raise_error
        end
      end

      context 'when allow_cross_joins_across_databases is used' do
        it 'does not raise exception' do
          expect { main_and_ci_query_allowlist_nested }.not_to raise_error
        end
      end
    end
  end

  private

  def main_and_ci_query_allowlisted
    Gitlab::Database.allow_cross_joins_across_databases(url: 'http://issue-url') do
      main_and_ci_query
    end
  end

  def main_and_ci_query_allowlist_nested
    Gitlab::Database.allow_cross_joins_across_databases(url: 'http://issue-url') do
      main_and_ci_query_allowlisted

      main_and_ci_query
    end
  end

  def main_only_query
    Issue.joins(:project).last
  end

  def ci_only_query
    Ci::Build.joins(:pipeline).last
  end

  def main_and_ci_query
    Ci::Build.joins(:project).last
  end
end
