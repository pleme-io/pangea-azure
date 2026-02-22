# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_storage_account/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermStorageAccount
      def azurerm_storage_account(name, attributes = {})
        attrs = Azure::Types::StorageAccountAttributes.new(attributes)

        resource(:azurerm_storage_account, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          account_tier attrs.account_tier
          account_replication_type attrs.account_replication_type
          account_kind attrs.account_kind if attrs.account_kind
          access_tier attrs.access_tier if attrs.access_tier
          enable_https_traffic_only attrs.enable_https_traffic_only unless attrs.enable_https_traffic_only.nil?
          min_tls_version attrs.min_tls_version if attrs.min_tls_version
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_storage_account',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_storage_account.#{name}.id}",
            name: "${azurerm_storage_account.#{name}.name}",
            primary_access_key: "${azurerm_storage_account.#{name}.primary_access_key}",
            primary_blob_endpoint: "${azurerm_storage_account.#{name}.primary_blob_endpoint}",
            primary_connection_string: "${azurerm_storage_account.#{name}.primary_connection_string}"
          }
        )
      end
    end

    module Azure
      include AzurermStorageAccount
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
