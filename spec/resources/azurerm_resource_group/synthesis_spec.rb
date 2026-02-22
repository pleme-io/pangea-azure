# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_resource_group/resource'

RSpec.describe 'azurerm_resource_group synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic resource group' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_resource_group(:test, {
          name: "rg-test",
          location: "eastus"
        })
      end

      result = synthesizer.synthesis
      rg = result[:resource][:azurerm_resource_group][:test]

      expect(rg).to include(
        name: "rg-test",
        location: "eastus"
      )
    end

    it 'synthesizes resource group with tags' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_resource_group(:tagged, {
          name: "rg-production",
          location: "westeurope",
          tags: { "Environment" => "production", "Team" => "platform" }
        })
      end

      result = synthesizer.synthesis
      rg = result[:resource][:azurerm_resource_group][:tagged]

      expect(rg[:name]).to eq("rg-production")
      expect(rg[:location]).to eq("westeurope")
      expect(rg[:tags]).to include("Environment" => "production", "Team" => "platform")
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_resource_group(:test, {
          name: "rg-test",
          location: "eastus"
        })
      end

      expect(ref.id).to eq("${azurerm_resource_group.test.id}")
      expect(ref.outputs[:name]).to eq("${azurerm_resource_group.test.name}")
    end
  end
end
