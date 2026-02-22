# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_redis_cache/resource'

RSpec.describe 'azurerm_redis_cache synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic redis cache' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_redis_cache(:test, {
          name: "redis-test",
          resource_group_name: "rg-test",
          location: "eastus",
          capacity: 1,
          family: "C",
          sku_name: "Standard"
        })
      end

      result = synthesizer.synthesis
      redis = result[:resource][:azurerm_redis_cache][:test]

      expect(redis).to include(
        name: "redis-test",
        capacity: 1,
        family: "C",
        sku_name: "Standard"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_redis_cache(:test, {
          name: "redis-test",
          resource_group_name: "rg-test",
          location: "eastus",
          capacity: 1,
          family: "C",
          sku_name: "Standard"
        })
      end

      expect(ref.id).to eq("${azurerm_redis_cache.test.id}")
      expect(ref.outputs[:hostname]).to eq("${azurerm_redis_cache.test.hostname}")
    end
  end
end
