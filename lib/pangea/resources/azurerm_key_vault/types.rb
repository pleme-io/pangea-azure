# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class KeyVaultAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :sku_name, ::Pangea::Resources::Types::AzureKeyVaultSku
          attribute :tenant_id, Dry::Types['strict.string']
          attribute :soft_delete_retention_days, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :purge_protection_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :enabled_for_deployment, Dry::Types['strict.bool'].optional.default(nil)
          attribute :enabled_for_disk_encryption, Dry::Types['strict.bool'].optional.default(nil)
          attribute :enabled_for_template_deployment, Dry::Types['strict.bool'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
