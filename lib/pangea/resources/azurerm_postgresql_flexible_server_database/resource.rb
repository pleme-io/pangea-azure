# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_postgresql_flexible_server_database/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermPostgresqlFlexibleServerDatabase
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_postgresql_flexible_server_database,
      attributes_class: Azure::Types::PostgresqlFlexibleServerDatabaseAttributes,
      outputs: { id: :id },
      map: [:name, :server_id],
      map_present: [:charset, :collation]
  end
  module Azure
    include AzurermPostgresqlFlexibleServerDatabase
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
