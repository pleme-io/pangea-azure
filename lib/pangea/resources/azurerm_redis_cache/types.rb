# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class RedisCacheAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :capacity, Dry::Types['coercible.integer']
          attribute :family, ::Pangea::Resources::Types::AzureRedisFamily
          attribute :sku_name, ::Pangea::Resources::Types::AzureRedisSku
          attribute :enable_non_ssl_port, Dry::Types['strict.bool'].optional.default(nil)
          attribute :minimum_tls_version, Dry::Types['strict.string'].optional.default(nil)
          attribute :shard_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
