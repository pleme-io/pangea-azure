# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_storage_account/resource'

RSpec.describe 'azurerm_storage_account synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic storage account' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_account(:test, {
          name: "sttest",
          resource_group_name: "rg-test",
          location: "eastus",
          account_tier: "Standard",
          account_replication_type: "LRS"
        })
      end

      result = synthesizer.synthesis
      sa = result[:resource][:azurerm_storage_account][:test]

      expect(sa).to include(
        name: "sttest",
        account_tier: "Standard",
        account_replication_type: "LRS"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_account(:test, {
          name: "sttest",
          resource_group_name: "rg-test",
          location: "eastus",
          account_tier: "Standard",
          account_replication_type: "LRS"
        })
      end

      expect(ref.id).to eq("${azurerm_storage_account.test.id}")
      expect(ref.outputs[:primary_blob_endpoint]).to eq("${azurerm_storage_account.test.primary_blob_endpoint}")
    end
  end
end
