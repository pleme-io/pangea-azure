# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_dns_cname_record/resource'

RSpec.describe 'azurerm_dns_cname_record synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic dns cname record' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_cname_record(:test, {
          name: "blog",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          record: "blog.azurewebsites.net"
        })
      end

      result = synthesizer.synthesis
      record = result[:resource][:azurerm_dns_cname_record][:test]

      expect(record).to include(
        name: "blog",
        zone_name: "example.com",
        ttl: 300,
        record: "blog.azurewebsites.net"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_cname_record(:test, {
          name: "blog",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          record: "blog.azurewebsites.net"
        })
      end

      expect(ref.id).to eq("${azurerm_dns_cname_record.test.id}")
      expect(ref.outputs[:fqdn]).to eq("${azurerm_dns_cname_record.test.fqdn}")
    end
  end
end
