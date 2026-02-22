# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_key_vault/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermKeyVault
      def azurerm_key_vault(name, attributes = {})
        attrs = Azure::Types::KeyVaultAttributes.new(attributes)

        resource(:azurerm_key_vault, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          sku_name attrs.sku_name
          tenant_id attrs.tenant_id
          soft_delete_retention_days attrs.soft_delete_retention_days if attrs.soft_delete_retention_days
          purge_protection_enabled attrs.purge_protection_enabled unless attrs.purge_protection_enabled.nil?
          enabled_for_deployment attrs.enabled_for_deployment unless attrs.enabled_for_deployment.nil?
          enabled_for_disk_encryption attrs.enabled_for_disk_encryption unless attrs.enabled_for_disk_encryption.nil?
          enabled_for_template_deployment attrs.enabled_for_template_deployment unless attrs.enabled_for_template_deployment.nil?
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_key_vault',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_key_vault.#{name}.id}",
            vault_uri: "${azurerm_key_vault.#{name}.vault_uri}",
            name: "${azurerm_key_vault.#{name}.name}"
          }
        )
      end
    end

    module Azure
      include AzurermKeyVault
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
