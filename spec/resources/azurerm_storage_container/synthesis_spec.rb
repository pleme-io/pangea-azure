# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_storage_container/resource'

RSpec.describe 'azurerm_storage_container synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic storage container' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_container(:test, {
          name: "content",
          storage_account_name: "sttest",
          container_access_type: "private"
        })
      end

      result = synthesizer.synthesis
      container = result[:resource][:azurerm_storage_container][:test]

      expect(container).to include(
        name: "content",
        storage_account_name: "sttest",
        container_access_type: "private"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_container(:test, {
          name: "content",
          storage_account_name: "sttest"
        })
      end

      expect(ref.id).to eq("${azurerm_storage_container.test.id}")
    end
  end
end
