# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_monitor_diagnostic_setting/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermMonitorDiagnosticSetting
      def azurerm_monitor_diagnostic_setting(name, attributes = {})
        attrs = Azure::Types::MonitorDiagnosticSettingAttributes.new(attributes)

        resource(:azurerm_monitor_diagnostic_setting, name) do
          self.name attrs.name
          target_resource_id attrs.target_resource_id
          log_analytics_workspace_id attrs.log_analytics_workspace_id if attrs.log_analytics_workspace_id
          storage_account_id attrs.storage_account_id if attrs.storage_account_id
          eventhub_authorization_rule_id attrs.eventhub_authorization_rule_id if attrs.eventhub_authorization_rule_id
          eventhub_name attrs.eventhub_name if attrs.eventhub_name
        end

        ResourceReference.new(
          type: 'azurerm_monitor_diagnostic_setting',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_monitor_diagnostic_setting.#{name}.id}"
          }
        )
      end
    end

    module Azure
      include AzurermMonitorDiagnosticSetting
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
