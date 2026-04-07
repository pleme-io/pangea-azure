# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Terraform meta-arguments' do
  include Pangea::Testing::SynthesisTestHelpers

  describe 'depends_on' do
    it 'does not treat depends_on as an unknown attribute' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          depends_on: ['azurerm_lb.main']
        )
      }.not_to raise_error
    end

    it 'still returns a valid ResourceReference' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      ref = synth.azurerm_resource_group('test',
        location: 'eastus',
        name: 'rg',
        depends_on: ['azurerm_lb.main']
      )

      expect(ref).to be_a(Pangea::Resources::ResourceReference)
      expect(ref.resource_type).to eq(:azurerm_resource_group)
    end
  end

  describe 'lifecycle' do
    it 'does not treat lifecycle as an unknown attribute' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          lifecycle: { prevent_destroy: true }
        )
      }.not_to raise_error
    end
  end

  describe 'count' do
    it 'does not treat count as an unknown attribute' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          count: 3
        )
      }.not_to raise_error
    end
  end

  describe 'for_each' do
    it 'does not treat for_each as an unknown attribute' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          for_each: { 'a' => '1', 'b' => '2' }
        )
      }.not_to raise_error
    end
  end

  describe 'provider' do
    it 'does not treat provider as an unknown attribute' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          provider: 'azurerm.secondary'
        )
      }.not_to raise_error
    end
  end

  describe 'combined meta-arguments and resource attributes' do
    it 'separates meta-args from resource attrs correctly' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      ref = synth.azurerm_resource_group('test',
        location: 'eastus',
        name: 'rg',
        managed_by: 'someone',
        depends_on: ['azurerm_lb.main'],
        lifecycle: { prevent_destroy: true }
      )

      result = normalize_synthesis(synth.synthesis)
      config = result.dig('resource', 'azurerm_resource_group', 'test')

      expect(config).to have_key('location')
      expect(config).to have_key('name')
      expect(config).to have_key('managed_by')
      expect(ref).to be_a(Pangea::Resources::ResourceReference)
    end
  end
end
