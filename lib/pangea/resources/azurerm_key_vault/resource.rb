# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_key_vault/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermKeyVault
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_key_vault,
      attributes_class: Azure::Types::KeyVaultAttributes,
      outputs: { id: :id, vault_uri: :vault_uri, name: :name },
      map: [:name, :resource_group_name, :location, :sku_name, :tenant_id],
      map_present: [:soft_delete_retention_days],
      map_bool: [:purge_protection_enabled, :enabled_for_deployment, :enabled_for_disk_encryption, :enabled_for_template_deployment],
      tags: :tags
  end
  module Azure
    include AzurermKeyVault
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
