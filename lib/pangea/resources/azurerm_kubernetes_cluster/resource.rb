# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_kubernetes_cluster/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermKubernetesCluster
      def azurerm_kubernetes_cluster(name, attributes = {})
        attrs = Azure::Types::KubernetesClusterAttributes.new(attributes)

        resource(:azurerm_kubernetes_cluster, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          dns_prefix attrs.dns_prefix

          default_node_pool do
            self.name attrs.default_node_pool.name
            vm_size attrs.default_node_pool.vm_size
            node_count attrs.default_node_pool.node_count
            min_count attrs.default_node_pool.min_count if attrs.default_node_pool.min_count
            max_count attrs.default_node_pool.max_count if attrs.default_node_pool.max_count
            enable_auto_scaling attrs.default_node_pool.enable_auto_scaling unless attrs.default_node_pool.enable_auto_scaling.nil?
            os_disk_size_gb attrs.default_node_pool.os_disk_size_gb if attrs.default_node_pool.os_disk_size_gb
          end

          if attrs.identity
            identity do
              type attrs.identity.type
            end
          end

          kubernetes_version attrs.kubernetes_version if attrs.kubernetes_version
          sku_tier attrs.sku_tier if attrs.sku_tier
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_kubernetes_cluster',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_kubernetes_cluster.#{name}.id}",
            fqdn: "${azurerm_kubernetes_cluster.#{name}.fqdn}",
            kube_config_raw: "${azurerm_kubernetes_cluster.#{name}.kube_config_raw}",
            node_resource_group: "${azurerm_kubernetes_cluster.#{name}.node_resource_group}"
          }
        )
      end
    end

    module Azure
      include AzurermKubernetesCluster
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
