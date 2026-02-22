# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_virtual_network/resource'

RSpec.describe 'azurerm_virtual_network synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic virtual network' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_virtual_network(:test, {
          name: "vnet-test",
          resource_group_name: "rg-test",
          location: "eastus",
          address_space: ["10.0.0.0/16"]
        })
      end

      result = synthesizer.synthesis
      vnet = result[:resource][:azurerm_virtual_network][:test]

      expect(vnet).to include(
        name: "vnet-test",
        resource_group_name: "rg-test",
        location: "eastus",
        address_space: ["10.0.0.0/16"]
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_virtual_network(:test, {
          name: "vnet-test",
          resource_group_name: "rg-test",
          location: "eastus",
          address_space: ["10.0.0.0/16"]
        })
      end

      expect(ref.id).to eq("${azurerm_virtual_network.test.id}")
    end
  end
end
