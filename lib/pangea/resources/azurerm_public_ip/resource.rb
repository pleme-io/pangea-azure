# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_public_ip/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermPublicIp
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_public_ip,
      attributes_class: Azure::Types::PublicIpAttributes,
      outputs: { id: :id, ip_address: :ip_address, fqdn: :fqdn },
      map: [:name, :resource_group_name, :location, :allocation_method],
      map_present: [:sku],
      tags: :tags
  end
  module Azure
    include AzurermPublicIp
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
