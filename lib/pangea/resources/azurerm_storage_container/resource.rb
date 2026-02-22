# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_storage_container/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermStorageContainer
      def azurerm_storage_container(name, attributes = {})
        attrs = Azure::Types::StorageContainerAttributes.new(attributes)

        resource(:azurerm_storage_container, name) do
          self.name attrs.name
          storage_account_name attrs.storage_account_name
          container_access_type attrs.container_access_type
        end

        ResourceReference.new(
          type: 'azurerm_storage_container',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_storage_container.#{name}.id}",
            has_immutability_policy: "${azurerm_storage_container.#{name}.has_immutability_policy}",
            has_legal_hold: "${azurerm_storage_container.#{name}.has_legal_hold}"
          }
        )
      end
    end

    module Azure
      include AzurermStorageContainer
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
