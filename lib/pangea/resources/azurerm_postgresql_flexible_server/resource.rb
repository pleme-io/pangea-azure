# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_postgresql_flexible_server/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermPostgresqlFlexibleServer
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_postgresql_flexible_server,
      attributes_class: Azure::Types::PostgresqlFlexibleServerAttributes,
      outputs: { id: :id, fqdn: :fqdn },
      map: [:name, :resource_group_name, :location, :sku_name],
      map_present: [:version, :administrator_login, :administrator_password, :storage_mb, :backup_retention_days,
                    :zone, :delegated_subnet_id, :private_dns_zone_id],
      map_bool: [:geo_redundant_backup_enabled],
      tags: :tags
  end
  module Azure
    include AzurermPostgresqlFlexibleServer
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
