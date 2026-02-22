# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_network_interface/resource'

RSpec.describe 'azurerm_network_interface synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic network interface' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_interface(:test, {
          name: "nic-test",
          resource_group_name: "rg-test",
          location: "eastus",
          ip_configuration: {
            name: "internal",
            subnet_id: "${azurerm_subnet.test.id}",
            private_ip_address_allocation: "Dynamic"
          }
        })
      end

      result = synthesizer.synthesis
      nic = result[:resource][:azurerm_network_interface][:test]

      expect(nic).to include(
        name: "nic-test",
        resource_group_name: "rg-test",
        location: "eastus"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_interface(:test, {
          name: "nic-test",
          resource_group_name: "rg-test",
          location: "eastus",
          ip_configuration: {
            name: "internal",
            subnet_id: "${azurerm_subnet.test.id}",
            private_ip_address_allocation: "Dynamic"
          }
        })
      end

      expect(ref.id).to eq("${azurerm_network_interface.test.id}")
    end
  end
end
