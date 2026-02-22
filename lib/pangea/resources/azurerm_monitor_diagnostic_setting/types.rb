# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class MonitorDiagnosticSettingAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :target_resource_id, Dry::Types['strict.string']
          attribute :log_analytics_workspace_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :storage_account_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :eventhub_authorization_rule_id, Dry::Types['strict.string'].optional.default(nil)
          attribute :eventhub_name, Dry::Types['strict.string'].optional.default(nil)
          attribute :enabled_log, Dry::Types['strict.array'].of(Dry::Types['nominal.hash']).optional.default(nil)
          attribute :metric, Dry::Types['strict.array'].of(Dry::Types['nominal.hash']).optional.default(nil)
        end
      end
    end
  end
end
