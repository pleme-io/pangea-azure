# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_security_group/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermNetworkSecurityGroup
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_network_security_group,
      attributes_class: Azure::Types::NetworkSecurityGroupAttributes,
      outputs: { id: :id, name: :name },
      map: [:name, :resource_group_name, :location],
      tags: :tags
  end
  module Azure
    include AzurermNetworkSecurityGroup
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
