# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_storage_account/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermStorageAccount
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_storage_account,
      attributes_class: Azure::Types::StorageAccountAttributes,
      outputs: { id: :id, name: :name, primary_access_key: :primary_access_key, primary_blob_endpoint: :primary_blob_endpoint, primary_connection_string: :primary_connection_string },
      map: [:name, :resource_group_name, :location, :account_tier, :account_replication_type],
      map_present: [:account_kind, :access_tier, :min_tls_version],
      map_bool: [:enable_https_traffic_only],
      tags: :tags
  end
  module Azure
    include AzurermStorageAccount
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
