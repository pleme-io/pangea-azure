# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_dns_cname_record/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermDnsCnameRecord
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_dns_cname_record,
      attributes_class: Azure::Types::DnsCnameRecordAttributes,
      outputs: { id: :id, fqdn: :fqdn },
      map: [:name, :zone_name, :resource_group_name, :ttl, :record],
      map_present: [:target_resource_id],
      tags: :tags
  end
  module Azure
    include AzurermDnsCnameRecord
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
