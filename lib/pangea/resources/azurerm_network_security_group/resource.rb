# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_security_group/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermNetworkSecurityGroup
      def azurerm_network_security_group(name, attributes = {})
        attrs = Azure::Types::NetworkSecurityGroupAttributes.new(attributes)

        resource(:azurerm_network_security_group, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_network_security_group',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_network_security_group.#{name}.id}",
            name: "${azurerm_network_security_group.#{name}.name}"
          }
        )
      end
    end

    module Azure
      include AzurermNetworkSecurityGroup
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
