# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_redis_cache/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermRedisCache
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_redis_cache,
      attributes_class: Azure::Types::RedisCacheAttributes,
      outputs: { id: :id, hostname: :hostname, ssl_port: :ssl_port, port: :port, primary_access_key: :primary_access_key, primary_connection_string: :primary_connection_string },
      map: [:name, :resource_group_name, :location, :capacity, :family, :sku_name],
      map_present: [:minimum_tls_version, :shard_count],
      map_bool: [:enable_non_ssl_port],
      tags: :tags
  end
  module Azure
    include AzurermRedisCache
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
