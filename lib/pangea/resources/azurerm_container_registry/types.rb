# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class ContainerRegistryAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :sku, ::Pangea::Resources::Types::AzureContainerRegistrySku
          attribute :admin_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :georeplications, Dry::Types['strict.array'].of(Dry::Types['nominal.hash']).optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
