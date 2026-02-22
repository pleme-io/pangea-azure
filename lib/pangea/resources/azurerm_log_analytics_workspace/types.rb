# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class LogAnalyticsWorkspaceAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :sku, ::Pangea::Resources::Types::AzureLogAnalyticsSku.optional.default(nil)
          attribute :retention_in_days, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :daily_quota_gb, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :internet_ingestion_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :internet_query_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
