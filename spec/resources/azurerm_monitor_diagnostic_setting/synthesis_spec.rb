# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_monitor_diagnostic_setting/resource'

RSpec.describe 'azurerm_monitor_diagnostic_setting synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic monitor diagnostic setting' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_monitor_diagnostic_setting(:test, {
          name: "diag-test",
          target_resource_id: "${azurerm_key_vault.test.id}",
          log_analytics_workspace_id: "${azurerm_log_analytics_workspace.test.id}"
        })
      end

      result = synthesizer.synthesis
      diag = result[:resource][:azurerm_monitor_diagnostic_setting][:test]

      expect(diag).to include(
        name: "diag-test",
        target_resource_id: "${azurerm_key_vault.test.id}",
        log_analytics_workspace_id: "${azurerm_log_analytics_workspace.test.id}"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_monitor_diagnostic_setting(:test, {
          name: "diag-test",
          target_resource_id: "${azurerm_key_vault.test.id}",
          log_analytics_workspace_id: "${azurerm_log_analytics_workspace.test.id}"
        })
      end

      expect(ref.id).to eq("${azurerm_monitor_diagnostic_setting.test.id}")
    end
  end
end
