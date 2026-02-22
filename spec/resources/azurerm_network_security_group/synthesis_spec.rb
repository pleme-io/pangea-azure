# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_network_security_group/resource'

RSpec.describe 'azurerm_network_security_group synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic network security group' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_group(:test, {
          name: "nsg-test",
          resource_group_name: "rg-test",
          location: "eastus"
        })
      end

      result = synthesizer.synthesis
      nsg = result[:resource][:azurerm_network_security_group][:test]

      expect(nsg).to include(
        name: "nsg-test",
        resource_group_name: "rg-test",
        location: "eastus"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_group(:test, {
          name: "nsg-test",
          resource_group_name: "rg-test",
          location: "eastus"
        })
      end

      expect(ref.id).to eq("${azurerm_network_security_group.test.id}")
    end
  end
end
