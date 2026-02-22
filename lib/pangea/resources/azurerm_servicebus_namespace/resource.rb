# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_servicebus_namespace/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermServicebusNamespace
      def azurerm_servicebus_namespace(name, attributes = {})
        attrs = Azure::Types::ServicebusNamespaceAttributes.new(attributes)

        resource(:azurerm_servicebus_namespace, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          sku attrs.sku
          capacity attrs.capacity if attrs.capacity
          zone_redundant attrs.zone_redundant unless attrs.zone_redundant.nil?
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_servicebus_namespace',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_servicebus_namespace.#{name}.id}",
            default_primary_connection_string: "${azurerm_servicebus_namespace.#{name}.default_primary_connection_string}",
            default_primary_key: "${azurerm_servicebus_namespace.#{name}.default_primary_key}"
          }
        )
      end
    end

    module Azure
      include AzurermServicebusNamespace
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
