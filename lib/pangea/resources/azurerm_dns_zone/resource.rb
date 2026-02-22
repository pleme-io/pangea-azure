# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_dns_zone/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermDnsZone
      def azurerm_dns_zone(name, attributes = {})
        attrs = Azure::Types::DnsZoneAttributes.new(attributes)

        resource(:azurerm_dns_zone, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_dns_zone',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_dns_zone.#{name}.id}",
            name_servers: "${azurerm_dns_zone.#{name}.name_servers}",
            max_number_of_record_sets: "${azurerm_dns_zone.#{name}.max_number_of_record_sets}"
          }
        )
      end
    end

    module Azure
      include AzurermDnsZone
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
