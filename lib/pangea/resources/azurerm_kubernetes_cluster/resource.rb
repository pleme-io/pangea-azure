# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_kubernetes_cluster/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermKubernetesCluster
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_kubernetes_cluster,
      attributes_class: Azure::Types::KubernetesClusterAttributes,
      outputs: { id: :id, fqdn: :fqdn, kube_config_raw: :kube_config_raw, node_resource_group: :node_resource_group },
      map: [:name, :resource_group_name, :location, :dns_prefix],
      map_present: [:kubernetes_version, :sku_tier],
      tags: :tags do |r, attrs|
        r.default_node_pool do
          r.__send__(:name, attrs.default_node_pool.name)
          r.vm_size attrs.default_node_pool.vm_size
          r.node_count attrs.default_node_pool.node_count
          r.min_count attrs.default_node_pool.min_count if attrs.default_node_pool.min_count
          r.max_count attrs.default_node_pool.max_count if attrs.default_node_pool.max_count
          r.enable_auto_scaling attrs.default_node_pool.enable_auto_scaling unless attrs.default_node_pool.enable_auto_scaling.nil?
          r.os_disk_size_gb attrs.default_node_pool.os_disk_size_gb if attrs.default_node_pool.os_disk_size_gb
        end

        if attrs.identity
          r.identity do
            r.type attrs.identity.type
          end
        end
      end
  end
  module Azure
    include AzurermKubernetesCluster
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
