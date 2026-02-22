# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class PostgresqlFlexibleServerDatabaseAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :server_id, Dry::Types['strict.string']
          attribute :charset, Dry::Types['strict.string'].optional.default(nil)
          attribute :collation, Dry::Types['strict.string'].optional.default(nil)
        end
      end
    end
  end
end
