# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_key_vault_secret/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermKeyVaultSecret
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_key_vault_secret,
      attributes_class: Azure::Types::KeyVaultSecretAttributes,
      outputs: { id: :id, version: :version, versionless_id: :versionless_id },
      map: [:name, :value, :key_vault_id],
      map_present: [:content_type, :not_before_date, :expiration_date],
      tags: :tags
  end
  module Azure
    include AzurermKeyVaultSecret
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
