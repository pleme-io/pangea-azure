# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_storage_container/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermStorageContainer
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_storage_container,
      attributes_class: Azure::Types::StorageContainerAttributes,
      outputs: { id: :id, has_immutability_policy: :has_immutability_policy, has_legal_hold: :has_legal_hold },
      map: [:name, :storage_account_name, :container_access_type]
  end
  module Azure
    include AzurermStorageContainer
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
