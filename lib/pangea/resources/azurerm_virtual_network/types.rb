# frozen_string_literal: true

require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class VirtualNetworkAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :address_space, Dry::Types['strict.array'].of(Dry::Types['strict.string'])
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
