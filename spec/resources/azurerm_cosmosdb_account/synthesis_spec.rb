# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_cosmosdb_account/resource'

RSpec.describe 'azurerm_cosmosdb_account synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic cosmosdb account' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_cosmosdb_account(:test, {
          name: "cosmos-test",
          resource_group_name: "rg-test",
          location: "eastus",
          offer_type: "Standard",
          kind: "GlobalDocumentDB",
          consistency_policy: {
            consistency_level: "Session"
          },
          geo_location: [
            {
              location: "eastus",
              failover_priority: 0
            }
          ]
        })
      end

      result = synthesizer.synthesis
      cosmos = result[:resource][:azurerm_cosmosdb_account][:test]

      expect(cosmos).to include(
        name: "cosmos-test",
        offer_type: "Standard",
        kind: "GlobalDocumentDB"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_cosmosdb_account(:test, {
          name: "cosmos-test",
          resource_group_name: "rg-test",
          location: "eastus",
          offer_type: "Standard",
          consistency_policy: {
            consistency_level: "Session"
          },
          geo_location: [
            {
              location: "eastus",
              failover_priority: 0
            }
          ]
        })
      end

      expect(ref.id).to eq("${azurerm_cosmosdb_account.test.id}")
      expect(ref.outputs[:endpoint]).to eq("${azurerm_cosmosdb_account.test.endpoint}")
    end
  end
end
