# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_resource_group/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermResourceGroup
      def azurerm_resource_group(name, attributes = {})
        attrs = Azure::Types::ResourceGroupAttributes.new(attributes)

        resource(:azurerm_resource_group, name) do
          self.name attrs.name
          location attrs.location
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_resource_group',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_resource_group.#{name}.id}",
            name: "${azurerm_resource_group.#{name}.name}",
            location: "${azurerm_resource_group.#{name}.location}"
          }
        )
      end
    end

    module Azure
      include AzurermResourceGroup
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
