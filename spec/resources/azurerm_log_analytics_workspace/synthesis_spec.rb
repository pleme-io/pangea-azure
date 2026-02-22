# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_log_analytics_workspace/resource'

RSpec.describe 'azurerm_log_analytics_workspace synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic log analytics workspace' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_log_analytics_workspace(:test, {
          name: "law-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "PerGB2018",
          retention_in_days: 30
        })
      end

      result = synthesizer.synthesis
      law = result[:resource][:azurerm_log_analytics_workspace][:test]

      expect(law).to include(
        name: "law-test",
        sku: "PerGB2018",
        retention_in_days: 30
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_log_analytics_workspace(:test, {
          name: "law-test",
          resource_group_name: "rg-test",
          location: "eastus"
        })
      end

      expect(ref.id).to eq("${azurerm_log_analytics_workspace.test.id}")
      expect(ref.outputs[:workspace_id]).to eq("${azurerm_log_analytics_workspace.test.workspace_id}")
    end
  end
end
