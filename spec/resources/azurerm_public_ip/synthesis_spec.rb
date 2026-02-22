# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_public_ip/resource'

RSpec.describe 'azurerm_public_ip synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic public ip' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_public_ip(:test, {
          name: "pip-test",
          resource_group_name: "rg-test",
          location: "eastus",
          allocation_method: "Static"
        })
      end

      result = synthesizer.synthesis
      pip = result[:resource][:azurerm_public_ip][:test]

      expect(pip).to include(
        name: "pip-test",
        resource_group_name: "rg-test",
        location: "eastus",
        allocation_method: "Static"
      )
    end

    it 'synthesizes public ip with sku' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_public_ip(:standard, {
          name: "pip-standard",
          resource_group_name: "rg-test",
          location: "eastus",
          allocation_method: "Static",
          sku: "Standard"
        })
      end

      result = synthesizer.synthesis
      pip = result[:resource][:azurerm_public_ip][:standard]

      expect(pip[:sku]).to eq("Standard")
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_public_ip(:test, {
          name: "pip-test",
          resource_group_name: "rg-test",
          location: "eastus",
          allocation_method: "Static"
        })
      end

      expect(ref.id).to eq("${azurerm_public_ip.test.id}")
      expect(ref.outputs[:ip_address]).to eq("${azurerm_public_ip.test.ip_address}")
    end
  end
end
