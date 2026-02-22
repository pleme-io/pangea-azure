# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class NetworkSecurityRuleAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :network_security_group_name, Dry::Types['strict.string']
          attribute :priority, Dry::Types['coercible.integer']
          attribute :direction, ::Pangea::Resources::Types::AzureNetworkDirection
          attribute :access, ::Pangea::Resources::Types::AzureNetworkAccess
          attribute :protocol, ::Pangea::Resources::Types::AzureNetworkProtocol
          attribute :source_port_range, Dry::Types['strict.string'].optional.default(nil)
          attribute :destination_port_range, Dry::Types['strict.string'].optional.default(nil)
          attribute :source_address_prefix, Dry::Types['strict.string'].optional.default(nil)
          attribute :destination_address_prefix, Dry::Types['strict.string'].optional.default(nil)
          attribute :source_port_ranges, Dry::Types['strict.array'].of(Dry::Types['strict.string']).optional.default(nil)
          attribute :destination_port_ranges, Dry::Types['strict.array'].of(Dry::Types['strict.string']).optional.default(nil)
          attribute :source_address_prefixes, Dry::Types['strict.array'].of(Dry::Types['strict.string']).optional.default(nil)
          attribute :destination_address_prefixes, Dry::Types['strict.array'].of(Dry::Types['strict.string']).optional.default(nil)
          attribute :description, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
