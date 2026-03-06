# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_cosmosdb_account/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermCosmosdbAccount
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_cosmosdb_account,
      attributes_class: Azure::Types::CosmosdbAccountAttributes,
      outputs: { id: :id, endpoint: :endpoint, primary_key: :primary_key, connection_strings: :connection_strings },
      map: [:name, :resource_group_name, :location, :offer_type],
      map_present: [:kind],
      map_bool: [:enable_automatic_failover, :enable_free_tier],
      tags: :tags do |r, attrs|
        r.consistency_policy do
          r.consistency_level attrs.consistency_policy.consistency_level
          r.max_interval_in_seconds attrs.consistency_policy.max_interval_in_seconds if attrs.consistency_policy.max_interval_in_seconds
          r.max_staleness_prefix attrs.consistency_policy.max_staleness_prefix if attrs.consistency_policy.max_staleness_prefix
        end

        attrs.geo_location.each do |geo|
          r.geo_location do
            r.location geo.location
            r.failover_priority geo.failover_priority
            r.zone_redundant geo.zone_redundant unless geo.zone_redundant.nil?
          end
        end
      end
  end
  module Azure
    include AzurermCosmosdbAccount
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
