# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_resource_group/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermResourceGroup
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_resource_group,
      attributes_class: Azure::Types::ResourceGroupAttributes,
      outputs: { id: :id, name: :name, location: :location },
      map: [:name, :location],
      tags: :tags
  end
  module Azure
    include AzurermResourceGroup
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
