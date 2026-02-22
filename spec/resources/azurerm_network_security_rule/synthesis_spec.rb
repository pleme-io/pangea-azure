# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_network_security_rule/resource'

RSpec.describe 'azurerm_network_security_rule synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic network security rule' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_rule(:test, {
          name: "allow-ssh",
          resource_group_name: "rg-test",
          network_security_group_name: "nsg-test",
          priority: 100,
          direction: "Inbound",
          access: "Allow",
          protocol: "Tcp",
          source_port_range: "*",
          destination_port_range: "22",
          source_address_prefix: "*",
          destination_address_prefix: "*"
        })
      end

      result = synthesizer.synthesis
      rule = result[:resource][:azurerm_network_security_rule][:test]

      expect(rule).to include(
        name: "allow-ssh",
        priority: 100,
        direction: "Inbound",
        access: "Allow",
        protocol: "Tcp"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_rule(:test, {
          name: "allow-ssh",
          resource_group_name: "rg-test",
          network_security_group_name: "nsg-test",
          priority: 100,
          direction: "Inbound",
          access: "Allow",
          protocol: "Tcp",
          source_port_range: "*",
          destination_port_range: "22",
          source_address_prefix: "*",
          destination_address_prefix: "*"
        })
      end

      expect(ref.id).to eq("${azurerm_network_security_rule.test.id}")
    end
  end
end
