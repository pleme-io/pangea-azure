# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_cosmosdb_account/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermCosmosdbAccount
      def azurerm_cosmosdb_account(name, attributes = {})
        attrs = Azure::Types::CosmosdbAccountAttributes.new(attributes)

        resource(:azurerm_cosmosdb_account, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          offer_type attrs.offer_type
          kind attrs.kind if attrs.kind

          consistency_policy do
            consistency_level attrs.consistency_policy.consistency_level
            max_interval_in_seconds attrs.consistency_policy.max_interval_in_seconds if attrs.consistency_policy.max_interval_in_seconds
            max_staleness_prefix attrs.consistency_policy.max_staleness_prefix if attrs.consistency_policy.max_staleness_prefix
          end

          attrs.geo_location.each do |geo|
            geo_location do
              location geo.location
              failover_priority geo.failover_priority
              zone_redundant geo.zone_redundant unless geo.zone_redundant.nil?
            end
          end

          enable_automatic_failover attrs.enable_automatic_failover unless attrs.enable_automatic_failover.nil?
          enable_free_tier attrs.enable_free_tier unless attrs.enable_free_tier.nil?
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_cosmosdb_account',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_cosmosdb_account.#{name}.id}",
            endpoint: "${azurerm_cosmosdb_account.#{name}.endpoint}",
            primary_key: "${azurerm_cosmosdb_account.#{name}.primary_key}",
            connection_strings: "${azurerm_cosmosdb_account.#{name}.connection_strings}"
          }
        )
      end
    end

    module Azure
      include AzurermCosmosdbAccount
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
