# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_container_registry/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermContainerRegistry
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_container_registry,
      attributes_class: Azure::Types::ContainerRegistryAttributes,
      outputs: { id: :id, login_server: :login_server, admin_username: :admin_username, admin_password: :admin_password },
      map: [:name, :resource_group_name, :location, :sku],
      map_bool: [:admin_enabled],
      tags: :tags
  end
  module Azure
    include AzurermContainerRegistry
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
