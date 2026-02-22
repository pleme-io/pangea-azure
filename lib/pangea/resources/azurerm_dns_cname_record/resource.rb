# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_dns_cname_record/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermDnsCnameRecord
      def azurerm_dns_cname_record(name, attributes = {})
        attrs = Azure::Types::DnsCnameRecordAttributes.new(attributes)

        resource(:azurerm_dns_cname_record, name) do
          self.name attrs.name
          zone_name attrs.zone_name
          resource_group_name attrs.resource_group_name
          ttl attrs.ttl
          record attrs.record
          target_resource_id attrs.target_resource_id if attrs.target_resource_id
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_dns_cname_record',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_dns_cname_record.#{name}.id}",
            fqdn: "${azurerm_dns_cname_record.#{name}.fqdn}"
          }
        )
      end
    end

    module Azure
      include AzurermDnsCnameRecord
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
