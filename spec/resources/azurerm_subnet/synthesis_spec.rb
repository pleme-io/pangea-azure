# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_subnet/resource'

RSpec.describe 'azurerm_subnet synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic subnet' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_subnet(:test, {
          name: "subnet-test",
          resource_group_name: "rg-test",
          virtual_network_name: "vnet-test",
          address_prefixes: ["10.0.1.0/24"]
        })
      end

      result = synthesizer.synthesis
      subnet = result[:resource][:azurerm_subnet][:test]

      expect(subnet).to include(
        name: "subnet-test",
        resource_group_name: "rg-test",
        virtual_network_name: "vnet-test",
        address_prefixes: ["10.0.1.0/24"]
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_subnet(:test, {
          name: "subnet-test",
          resource_group_name: "rg-test",
          virtual_network_name: "vnet-test",
          address_prefixes: ["10.0.1.0/24"]
        })
      end

      expect(ref.id).to eq("${azurerm_subnet.test.id}")
    end
  end
end
