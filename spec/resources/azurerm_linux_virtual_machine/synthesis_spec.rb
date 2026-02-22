# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_linux_virtual_machine/resource'

RSpec.describe 'azurerm_linux_virtual_machine synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic linux virtual machine' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_linux_virtual_machine(:test, {
          name: "vm-test",
          resource_group_name: "rg-test",
          location: "eastus",
          size: "Standard_B2s",
          admin_username: "adminuser",
          network_interface_ids: ["${azurerm_network_interface.test.id}"],
          os_disk: {
            caching: "ReadWrite",
            storage_account_type: "Standard_LRS"
          },
          source_image_reference: {
            publisher: "Canonical",
            offer: "0001-com-ubuntu-server-jammy",
            sku: "22_04-lts",
            version: "latest"
          }
        })
      end

      result = synthesizer.synthesis
      vm = result[:resource][:azurerm_linux_virtual_machine][:test]

      expect(vm).to include(
        name: "vm-test",
        size: "Standard_B2s",
        admin_username: "adminuser"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_linux_virtual_machine(:test, {
          name: "vm-test",
          resource_group_name: "rg-test",
          location: "eastus",
          size: "Standard_B2s",
          admin_username: "adminuser",
          network_interface_ids: ["${azurerm_network_interface.test.id}"],
          os_disk: {
            caching: "ReadWrite",
            storage_account_type: "Standard_LRS"
          }
        })
      end

      expect(ref.id).to eq("${azurerm_linux_virtual_machine.test.id}")
    end
  end
end
