# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_key_vault_secret/resource'

RSpec.describe 'azurerm_key_vault_secret synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic key vault secret' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault_secret(:test, {
          name: "db-password",
          value: "supersecret",
          key_vault_id: "${azurerm_key_vault.test.id}"
        })
      end

      result = synthesizer.synthesis
      secret = result[:resource][:azurerm_key_vault_secret][:test]

      expect(secret).to include(
        name: "db-password",
        value: "supersecret",
        key_vault_id: "${azurerm_key_vault.test.id}"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault_secret(:test, {
          name: "db-password",
          value: "supersecret",
          key_vault_id: "${azurerm_key_vault.test.id}"
        })
      end

      expect(ref.id).to eq("${azurerm_key_vault_secret.test.id}")
    end
  end
end
