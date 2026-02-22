# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_container_registry/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermContainerRegistry
      def azurerm_container_registry(name, attributes = {})
        attrs = Azure::Types::ContainerRegistryAttributes.new(attributes)

        resource(:azurerm_container_registry, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          sku attrs.sku
          admin_enabled attrs.admin_enabled unless attrs.admin_enabled.nil?
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_container_registry',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_container_registry.#{name}.id}",
            login_server: "${azurerm_container_registry.#{name}.login_server}",
            admin_username: "${azurerm_container_registry.#{name}.admin_username}",
            admin_password: "${azurerm_container_registry.#{name}.admin_password}"
          }
        )
      end
    end

    module Azure
      include AzurermContainerRegistry
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
