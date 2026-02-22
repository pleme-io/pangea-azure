# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_interface/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermNetworkInterface
      def azurerm_network_interface(name, attributes = {})
        attrs = Azure::Types::NetworkInterfaceAttributes.new(attributes)

        resource(:azurerm_network_interface, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location

          ip_configuration do
            self.name attrs.ip_configuration.name
            subnet_id attrs.ip_configuration.subnet_id
            private_ip_address_allocation attrs.ip_configuration.private_ip_address_allocation
            private_ip_address attrs.ip_configuration.private_ip_address if attrs.ip_configuration.private_ip_address
            public_ip_address_id attrs.ip_configuration.public_ip_address_id if attrs.ip_configuration.public_ip_address_id
          end

          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_network_interface',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_network_interface.#{name}.id}",
            private_ip_address: "${azurerm_network_interface.#{name}.private_ip_address}",
            mac_address: "${azurerm_network_interface.#{name}.mac_address}"
          }
        )
      end
    end

    module Azure
      include AzurermNetworkInterface
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
