# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_key_vault/resource'

RSpec.describe 'azurerm_key_vault synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic key vault' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault(:test, {
          name: "kv-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "standard",
          tenant_id: "00000000-0000-0000-0000-000000000000"
        })
      end

      result = synthesizer.synthesis
      kv = result[:resource][:azurerm_key_vault][:test]

      expect(kv).to include(
        name: "kv-test",
        sku_name: "standard",
        tenant_id: "00000000-0000-0000-0000-000000000000"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault(:test, {
          name: "kv-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "standard",
          tenant_id: "00000000-0000-0000-0000-000000000000"
        })
      end

      expect(ref.id).to eq("${azurerm_key_vault.test.id}")
      expect(ref.outputs[:vault_uri]).to eq("${azurerm_key_vault.test.vault_uri}")
    end
  end
end
