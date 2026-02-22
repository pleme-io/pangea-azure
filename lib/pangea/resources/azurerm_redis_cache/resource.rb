# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_redis_cache/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermRedisCache
      def azurerm_redis_cache(name, attributes = {})
        attrs = Azure::Types::RedisCacheAttributes.new(attributes)

        resource(:azurerm_redis_cache, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          capacity attrs.capacity
          family attrs.family
          sku_name attrs.sku_name
          enable_non_ssl_port attrs.enable_non_ssl_port unless attrs.enable_non_ssl_port.nil?
          minimum_tls_version attrs.minimum_tls_version if attrs.minimum_tls_version
          shard_count attrs.shard_count if attrs.shard_count
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_redis_cache',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_redis_cache.#{name}.id}",
            hostname: "${azurerm_redis_cache.#{name}.hostname}",
            ssl_port: "${azurerm_redis_cache.#{name}.ssl_port}",
            port: "${azurerm_redis_cache.#{name}.port}",
            primary_access_key: "${azurerm_redis_cache.#{name}.primary_access_key}",
            primary_connection_string: "${azurerm_redis_cache.#{name}.primary_connection_string}"
          }
        )
      end
    end

    module Azure
      include AzurermRedisCache
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
