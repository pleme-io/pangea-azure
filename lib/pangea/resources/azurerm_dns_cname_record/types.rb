# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class DnsCnameRecordAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :zone_name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :ttl, Dry::Types['coercible.integer']
          attribute :record, Dry::Types['strict.string']
          attribute :target_resource_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
