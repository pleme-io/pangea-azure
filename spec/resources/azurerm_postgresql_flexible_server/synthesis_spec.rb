# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_postgresql_flexible_server/resource'

RSpec.describe 'azurerm_postgresql_flexible_server synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic postgresql flexible server' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server(:test, {
          name: "psql-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "GP_Standard_D2s_v3",
          version: "15",
          administrator_login: "psqladmin",
          administrator_password: "H@Sh1CoR3!",
          storage_mb: 32768
        })
      end

      result = synthesizer.synthesis
      pg = result[:resource][:azurerm_postgresql_flexible_server][:test]

      expect(pg).to include(
        name: "psql-test",
        sku_name: "GP_Standard_D2s_v3",
        version: "15"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server(:test, {
          name: "psql-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "GP_Standard_D2s_v3"
        })
      end

      expect(ref.id).to eq("${azurerm_postgresql_flexible_server.test.id}")
      expect(ref.outputs[:fqdn]).to eq("${azurerm_postgresql_flexible_server.test.fqdn}")
    end
  end
end
