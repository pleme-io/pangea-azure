# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_postgresql_flexible_server_database/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermPostgresqlFlexibleServerDatabase
      def azurerm_postgresql_flexible_server_database(name, attributes = {})
        attrs = Azure::Types::PostgresqlFlexibleServerDatabaseAttributes.new(attributes)

        resource(:azurerm_postgresql_flexible_server_database, name) do
          self.name attrs.name
          server_id attrs.server_id
          charset attrs.charset if attrs.charset
          collation attrs.collation if attrs.collation
        end

        ResourceReference.new(
          type: 'azurerm_postgresql_flexible_server_database',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_postgresql_flexible_server_database.#{name}.id}"
          }
        )
      end
    end

    module Azure
      include AzurermPostgresqlFlexibleServerDatabase
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
