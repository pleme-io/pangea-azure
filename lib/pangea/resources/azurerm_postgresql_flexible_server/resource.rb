# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_postgresql_flexible_server/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermPostgresqlFlexibleServer
      def azurerm_postgresql_flexible_server(name, attributes = {})
        attrs = Azure::Types::PostgresqlFlexibleServerAttributes.new(attributes)

        resource(:azurerm_postgresql_flexible_server, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          sku_name attrs.sku_name
          version attrs.version if attrs.version
          administrator_login attrs.administrator_login if attrs.administrator_login
          administrator_password attrs.administrator_password if attrs.administrator_password
          storage_mb attrs.storage_mb if attrs.storage_mb
          backup_retention_days attrs.backup_retention_days if attrs.backup_retention_days
          geo_redundant_backup_enabled attrs.geo_redundant_backup_enabled unless attrs.geo_redundant_backup_enabled.nil?
          zone attrs.zone if attrs.zone
          delegated_subnet_id attrs.delegated_subnet_id if attrs.delegated_subnet_id
          private_dns_zone_id attrs.private_dns_zone_id if attrs.private_dns_zone_id
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_postgresql_flexible_server',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_postgresql_flexible_server.#{name}.id}",
            fqdn: "${azurerm_postgresql_flexible_server.#{name}.fqdn}"
          }
        )
      end
    end

    module Azure
      include AzurermPostgresqlFlexibleServer
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
