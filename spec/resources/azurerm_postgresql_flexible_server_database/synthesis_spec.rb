# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_postgresql_flexible_server_database/resource'

RSpec.describe 'azurerm_postgresql_flexible_server_database synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic postgresql database' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server_database(:test, {
          name: "appdb",
          server_id: "${azurerm_postgresql_flexible_server.test.id}",
          charset: "UTF8",
          collation: "en_US.utf8"
        })
      end

      result = synthesizer.synthesis
      db = result[:resource][:azurerm_postgresql_flexible_server_database][:test]

      expect(db).to include(
        name: "appdb",
        server_id: "${azurerm_postgresql_flexible_server.test.id}",
        charset: "UTF8",
        collation: "en_US.utf8"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server_database(:test, {
          name: "appdb",
          server_id: "${azurerm_postgresql_flexible_server.test.id}"
        })
      end

      expect(ref.id).to eq("${azurerm_postgresql_flexible_server_database.test.id}")
    end
  end
end
