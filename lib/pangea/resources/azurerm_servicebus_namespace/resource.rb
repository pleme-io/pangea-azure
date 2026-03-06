# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_servicebus_namespace/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermServicebusNamespace
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_servicebus_namespace,
      attributes_class: Azure::Types::ServicebusNamespaceAttributes,
      outputs: { id: :id, default_primary_connection_string: :default_primary_connection_string, default_primary_key: :default_primary_key },
      map: [:name, :resource_group_name, :location, :sku],
      map_present: [:capacity],
      map_bool: [:zone_redundant],
      tags: :tags
  end
  module Azure
    include AzurermServicebusNamespace
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
