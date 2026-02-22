# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_key_vault_secret/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermKeyVaultSecret
      def azurerm_key_vault_secret(name, attributes = {})
        attrs = Azure::Types::KeyVaultSecretAttributes.new(attributes)

        resource(:azurerm_key_vault_secret, name) do
          self.name attrs.name
          value attrs.value
          key_vault_id attrs.key_vault_id
          content_type attrs.content_type if attrs.content_type
          not_before_date attrs.not_before_date if attrs.not_before_date
          expiration_date attrs.expiration_date if attrs.expiration_date
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_key_vault_secret',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_key_vault_secret.#{name}.id}",
            version: "${azurerm_key_vault_secret.#{name}.version}",
            versionless_id: "${azurerm_key_vault_secret.#{name}.versionless_id}"
          }
        )
      end
    end

    module Azure
      include AzurermKeyVaultSecret
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
