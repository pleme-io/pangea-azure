# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_monitor_diagnostic_setting/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermMonitorDiagnosticSetting
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_monitor_diagnostic_setting,
      attributes_class: Azure::Types::MonitorDiagnosticSettingAttributes,
      outputs: { id: :id },
      map: [:name, :target_resource_id],
      map_present: [:log_analytics_workspace_id, :storage_account_id, :eventhub_authorization_rule_id, :eventhub_name]
  end
  module Azure
    include AzurermMonitorDiagnosticSetting
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
