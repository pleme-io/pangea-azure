# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_subnet/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermSubnet
      def azurerm_subnet(name, attributes = {})
        attrs = Azure::Types::SubnetAttributes.new(attributes)

        resource(:azurerm_subnet, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          virtual_network_name attrs.virtual_network_name
          address_prefixes attrs.address_prefixes
          service_endpoints attrs.service_endpoints if attrs.service_endpoints
        end

        ResourceReference.new(
          type: 'azurerm_subnet',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_subnet.#{name}.id}",
            name: "${azurerm_subnet.#{name}.name}"
          }
        )
      end
    end

    module Azure
      include AzurermSubnet
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
