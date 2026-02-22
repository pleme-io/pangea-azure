# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_container_registry/resource'

RSpec.describe 'azurerm_container_registry synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic container registry' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_container_registry(:test, {
          name: "acrtest",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      result = synthesizer.synthesis
      acr = result[:resource][:azurerm_container_registry][:test]

      expect(acr).to include(
        name: "acrtest",
        sku: "Standard"
      )
    end

    it 'synthesizes container registry with admin enabled' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_container_registry(:admin, {
          name: "acradmin",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Premium",
          admin_enabled: true
        })
      end

      result = synthesizer.synthesis
      acr = result[:resource][:azurerm_container_registry][:admin]

      expect(acr[:admin_enabled]).to be true
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_container_registry(:test, {
          name: "acrtest",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      expect(ref.id).to eq("${azurerm_container_registry.test.id}")
      expect(ref.outputs[:login_server]).to eq("${azurerm_container_registry.test.login_server}")
    end
  end
end
