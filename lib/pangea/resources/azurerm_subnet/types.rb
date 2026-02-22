# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class SubnetAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :virtual_network_name, Dry::Types['strict.string']
          attribute :address_prefixes, Dry::Types['strict.array'].of(Dry::Types['strict.string'])
          attribute :service_endpoints, Dry::Types['strict.array'].of(Dry::Types['strict.string']).optional.default(nil)
          attribute :delegation, Dry::Types['nominal.hash'].optional.default(nil)
        end
      end
    end
  end
end
