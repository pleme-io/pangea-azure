# frozen_string_literal: true

require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class PublicIpAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :allocation_method, ::Pangea::Resources::Types::AzureAllocationMethod
          attribute :sku, ::Pangea::Resources::Types::AzureIpSku.optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
