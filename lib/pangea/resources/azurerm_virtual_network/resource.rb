# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_virtual_network/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermVirtualNetwork
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_virtual_network,
      attributes_class: Azure::Types::VirtualNetworkAttributes,
      outputs: { id: :id, name: :name, guid: :guid },
      map: [:name, :resource_group_name, :location, :address_space],
      tags: :tags
  end
  module Azure
    include AzurermVirtualNetwork
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
