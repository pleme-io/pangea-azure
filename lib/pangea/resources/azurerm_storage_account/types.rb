# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class StorageAccountAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :account_tier, ::Pangea::Resources::Types::AzureAccountTier
          attribute :account_replication_type, ::Pangea::Resources::Types::AzureAccountReplicationType
          attribute :account_kind, Dry::Types['strict.string'].optional.default(nil)
          attribute :access_tier, Dry::Types['strict.string'].optional.default(nil)
          attribute :enable_https_traffic_only, Dry::Types['strict.bool'].optional.default(nil)
          attribute :min_tls_version, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
