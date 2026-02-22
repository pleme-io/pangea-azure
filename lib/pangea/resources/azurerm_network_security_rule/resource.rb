# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_security_rule/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermNetworkSecurityRule
      def azurerm_network_security_rule(name, attributes = {})
        attrs = Azure::Types::NetworkSecurityRuleAttributes.new(attributes)

        resource(:azurerm_network_security_rule, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          network_security_group_name attrs.network_security_group_name
          priority attrs.priority
          direction attrs.direction
          access attrs.access
          protocol attrs.protocol
          source_port_range attrs.source_port_range if attrs.source_port_range
          destination_port_range attrs.destination_port_range if attrs.destination_port_range
          source_address_prefix attrs.source_address_prefix if attrs.source_address_prefix
          destination_address_prefix attrs.destination_address_prefix if attrs.destination_address_prefix
          source_port_ranges attrs.source_port_ranges if attrs.source_port_ranges
          destination_port_ranges attrs.destination_port_ranges if attrs.destination_port_ranges
          source_address_prefixes attrs.source_address_prefixes if attrs.source_address_prefixes
          destination_address_prefixes attrs.destination_address_prefixes if attrs.destination_address_prefixes
          description attrs.description if attrs.description
        end

        ResourceReference.new(
          type: 'azurerm_network_security_rule',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_network_security_rule.#{name}.id}"
          }
        )
      end
    end

    module Azure
      include AzurermNetworkSecurityRule
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
