# frozen_string_literal: true

require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class NetworkInterfaceIpConfiguration < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :subnet_id, Dry::Types['strict.string']
          attribute :private_ip_address_allocation, ::Pangea::Resources::Types::AzureAllocationMethod
          attribute :private_ip_address, Dry::Types['strict.string'].optional.default(nil)
          attribute :public_ip_address_id, Dry::Types['strict.string'].optional.default(nil)
        end

        class NetworkInterfaceAttributes < Pangea::Resources::BaseAttributes
          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :ip_configuration, NetworkInterfaceIpConfiguration
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
