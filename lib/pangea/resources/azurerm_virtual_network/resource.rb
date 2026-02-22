# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_virtual_network/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermVirtualNetwork
      def azurerm_virtual_network(name, attributes = {})
        attrs = Azure::Types::VirtualNetworkAttributes.new(attributes)

        resource(:azurerm_virtual_network, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          address_space attrs.address_space
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_virtual_network',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_virtual_network.#{name}.id}",
            name: "${azurerm_virtual_network.#{name}.name}",
            guid: "${azurerm_virtual_network.#{name}.guid}"
          }
        )
      end
    end

    module Azure
      include AzurermVirtualNetwork
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
