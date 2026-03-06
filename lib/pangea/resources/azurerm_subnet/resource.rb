# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_subnet/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermSubnet
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_subnet,
      attributes_class: Azure::Types::SubnetAttributes,
      outputs: { id: :id, name: :name },
      map: [:name, :resource_group_name, :virtual_network_name, :address_prefixes],
      map_present: [:service_endpoints]
  end
  module Azure
    include AzurermSubnet
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
