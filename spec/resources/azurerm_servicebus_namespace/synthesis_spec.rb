# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_servicebus_namespace/resource'

RSpec.describe 'azurerm_servicebus_namespace synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic servicebus namespace' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_servicebus_namespace(:test, {
          name: "sb-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      result = synthesizer.synthesis
      sb = result[:resource][:azurerm_servicebus_namespace][:test]

      expect(sb).to include(
        name: "sb-test",
        sku: "Standard"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_servicebus_namespace(:test, {
          name: "sb-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      expect(ref.id).to eq("${azurerm_servicebus_namespace.test.id}")
    end
  end
end
