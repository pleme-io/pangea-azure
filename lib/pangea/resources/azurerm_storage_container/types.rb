# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class StorageContainerAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :storage_account_name, Dry::Types['strict.string']
          attribute :container_access_type, ::Pangea::Resources::Types::AzureContainerAccessType.optional.default('private')
        end
      end
    end
  end
end
