# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_dns_zone/resource'

RSpec.describe 'azurerm_dns_zone synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic dns zone' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_zone(:test, {
          name: "example.com",
          resource_group_name: "rg-test"
        })
      end

      result = synthesizer.synthesis
      zone = result[:resource][:azurerm_dns_zone][:test]

      expect(zone).to include(
        name: "example.com",
        resource_group_name: "rg-test"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_zone(:test, {
          name: "example.com",
          resource_group_name: "rg-test"
        })
      end

      expect(ref.id).to eq("${azurerm_dns_zone.test.id}")
      expect(ref.outputs[:name_servers]).to eq("${azurerm_dns_zone.test.name_servers}")
    end
  end
end
