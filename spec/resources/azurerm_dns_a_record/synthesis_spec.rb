# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_dns_a_record/resource'

RSpec.describe 'azurerm_dns_a_record synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic dns a record' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_a_record(:test, {
          name: "www",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          records: ["10.0.0.1"]
        })
      end

      result = synthesizer.synthesis
      record = result[:resource][:azurerm_dns_a_record][:test]

      expect(record).to include(
        name: "www",
        zone_name: "example.com",
        ttl: 300,
        records: ["10.0.0.1"]
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_a_record(:test, {
          name: "www",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          records: ["10.0.0.1"]
        })
      end

      expect(ref.id).to eq("${azurerm_dns_a_record.test.id}")
      expect(ref.outputs[:fqdn]).to eq("${azurerm_dns_a_record.test.fqdn}")
    end
  end
end
