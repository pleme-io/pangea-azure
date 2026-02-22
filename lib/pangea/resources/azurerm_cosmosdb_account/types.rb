# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class CosmosDbConsistencyPolicy < Dry::Struct
          transform_keys(&:to_sym)

          attribute :consistency_level, ::Pangea::Resources::Types::AzureCosmosDbConsistencyLevel
          attribute :max_interval_in_seconds, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :max_staleness_prefix, Dry::Types['coercible.integer'].optional.default(nil)
        end

        class CosmosDbGeoLocation < Dry::Struct
          transform_keys(&:to_sym)

          attribute :location, Dry::Types['strict.string']
          attribute :failover_priority, Dry::Types['coercible.integer']
          attribute :zone_redundant, Dry::Types['strict.bool'].optional.default(nil)
        end

        class CosmosdbAccountAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :offer_type, ::Pangea::Resources::Types::AzureCosmosDbOfferType
          attribute :kind, ::Pangea::Resources::Types::AzureCosmosDbKind.optional.default(nil)
          attribute :consistency_policy, CosmosDbConsistencyPolicy
          attribute :geo_location, Dry::Types['strict.array'].of(CosmosDbGeoLocation)
          attribute :enable_automatic_failover, Dry::Types['strict.bool'].optional.default(nil)
          attribute :enable_free_tier, Dry::Types['strict.bool'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
