# frozen_string_literal: true

module BulkImports
  module Groups
    class Stage < ::BulkImports::Stage
      private

      def config
        @config ||= {
          group: {
            pipeline: BulkImports::Groups::Pipelines::GroupPipeline,
            stage: 0
          },
          avatar: {
            pipeline: BulkImports::Groups::Pipelines::GroupAvatarPipeline,
            stage: 1
          },
          subgroups: {
            pipeline: BulkImports::Groups::Pipelines::SubgroupEntitiesPipeline,
            stage: 1
          },
          members: {
            pipeline: BulkImports::Groups::Pipelines::MembersPipeline,
            stage: 1
          },
          labels: {
            pipeline: BulkImports::Groups::Pipelines::LabelsPipeline,
            stage: 1
          },
          milestones: {
            pipeline: BulkImports::Groups::Pipelines::MilestonesPipeline,
            stage: 1
          },
          badges: {
            pipeline: BulkImports::Groups::Pipelines::BadgesPipeline,
            stage: 1
          },
          boards: {
            pipeline: BulkImports::Groups::Pipelines::BoardsPipeline,
            stage: 2
          },
          finisher: {
            pipeline: BulkImports::Common::Pipelines::EntityFinisher,
            stage: 3
          }
        }.merge(project_entities_pipeline)
      end

      def project_entities_pipeline
        if ::Feature.enabled?(:bulk_import_projects, default_enabled: :yaml)
          {
            project_entities: {
              pipeline: BulkImports::Groups::Pipelines::ProjectEntitiesPipeline,
              stage: 1
            }
          }
        else
          {}
        end
      end
    end
  end
end

::BulkImports::Groups::Stage.prepend_mod_with('BulkImports::Groups::Stage')
