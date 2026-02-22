# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class PostgresqlFlexibleServerAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :sku_name, Dry::Types['strict.string']
          attribute :version, Dry::Types['strict.string'].optional.default(nil)
          attribute :administrator_login, Dry::Types['strict.string'].optional.default(nil)
          attribute :administrator_password, Dry::Types['strict.string'].optional.default(nil)
          attribute :storage_mb, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :backup_retention_days, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :geo_redundant_backup_enabled, Dry::Types['strict.bool'].optional.default(nil)
          attribute :zone, Dry::Types['strict.string'].optional.default(nil)
          attribute :delegated_subnet_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :private_dns_zone_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
