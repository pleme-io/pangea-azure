# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_log_analytics_workspace/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermLogAnalyticsWorkspace
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_log_analytics_workspace,
      attributes_class: Azure::Types::LogAnalyticsWorkspaceAttributes,
      outputs: { id: :id, workspace_id: :workspace_id, primary_shared_key: :primary_shared_key, secondary_shared_key: :secondary_shared_key },
      map: [:name, :resource_group_name, :location],
      map_present: [:sku, :retention_in_days, :daily_quota_gb],
      map_bool: [:internet_ingestion_enabled, :internet_query_enabled],
      tags: :tags
  end
  module Azure
    include AzurermLogAnalyticsWorkspace
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
