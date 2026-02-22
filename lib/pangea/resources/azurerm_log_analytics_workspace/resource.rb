# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_log_analytics_workspace/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermLogAnalyticsWorkspace
      def azurerm_log_analytics_workspace(name, attributes = {})
        attrs = Azure::Types::LogAnalyticsWorkspaceAttributes.new(attributes)

        resource(:azurerm_log_analytics_workspace, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          sku attrs.sku if attrs.sku
          retention_in_days attrs.retention_in_days if attrs.retention_in_days
          daily_quota_gb attrs.daily_quota_gb if attrs.daily_quota_gb
          internet_ingestion_enabled attrs.internet_ingestion_enabled unless attrs.internet_ingestion_enabled.nil?
          internet_query_enabled attrs.internet_query_enabled unless attrs.internet_query_enabled.nil?
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_log_analytics_workspace',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_log_analytics_workspace.#{name}.id}",
            workspace_id: "${azurerm_log_analytics_workspace.#{name}.workspace_id}",
            primary_shared_key: "${azurerm_log_analytics_workspace.#{name}.primary_shared_key}",
            secondary_shared_key: "${azurerm_log_analytics_workspace.#{name}.secondary_shared_key}"
          }
        )
      end
    end

    module Azure
      include AzurermLogAnalyticsWorkspace
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
