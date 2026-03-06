# frozen_string_literal: true

require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class KeyVaultSecretAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :value, Dry::Types['strict.string']
          attribute :key_vault_id, Dry::Types['strict.string']
          attribute :content_type, Dry::Types['strict.string'].optional.default(nil)
          attribute :not_before_date, Dry::Types['strict.string'].optional.default(nil)
          attribute :expiration_date, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
