# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_public_ip/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermPublicIp
      def azurerm_public_ip(name, attributes = {})
        attrs = Azure::Types::PublicIpAttributes.new(attributes)

        resource(:azurerm_public_ip, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          allocation_method attrs.allocation_method
          sku attrs.sku if attrs.sku
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_public_ip',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_public_ip.#{name}.id}",
            ip_address: "${azurerm_public_ip.#{name}.ip_address}",
            fqdn: "${azurerm_public_ip.#{name}.fqdn}"
          }
        )
      end
    end

    module Azure
      include AzurermPublicIp
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
