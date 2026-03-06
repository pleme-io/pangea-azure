# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_dns_zone/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermDnsZone
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_dns_zone,
      attributes_class: Azure::Types::DnsZoneAttributes,
      outputs: { id: :id, name_servers: :name_servers, max_number_of_record_sets: :max_number_of_record_sets },
      map: [:name, :resource_group_name],
      tags: :tags
  end
  module Azure
    include AzurermDnsZone
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
