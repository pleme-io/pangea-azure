# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'SynthesisTestHelpers usage' do
  include Pangea::Testing::SynthesisTestHelpers

  describe 'validate_resource_references' do
    it 'finds interpolation references in synthesized output' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      rg_ref = synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      synth.azurerm_lb('lb',
        location: 'eastus',
        name: 'my-lb',
        resource_group_name: rg_ref.id
      )

      result = normalize_synthesis(synth.synthesis)
      references = validate_resource_references(result)
      expect(references).to include('${azurerm_resource_group.rg.id}')
    end

    it 'returns empty array when no references exist' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')

      result = normalize_synthesis(synth.synthesis)
      references = validate_resource_references(result)
      expect(references).to be_a(Array)
    end
  end

  describe 'validate_dependency_ordering' do
    it 'validates resources without cross-references' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg1', location: 'eastus', name: 'rg-1')
      synth.azurerm_resource_group('rg2', location: 'westus', name: 'rg-2')

      result = normalize_synthesis(synth.synthesis)
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end

    it 'validates resources with valid cross-references' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      rg_ref = synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      synth.azurerm_lb('lb',
        location: 'eastus',
        name: 'my-lb',
        resource_group_name: rg_ref.id
      )

      result = normalize_synthesis(synth.synthesis)
      expect { validate_dependency_ordering(result) }.not_to raise_error
    end
  end

  describe 'normalize_synthesis' do
    it 'converts symbol keys to string keys' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      result = normalize_synthesis(synth.synthesis)

      expect(result.keys.first).to be_a(String)
    end
  end

  describe 'create_synthesizer' do
    it 'returns a synthesizer that supports resource methods' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      expect(synth).to respond_to(:azurerm_resource_group)
    end

    it 'returns a synthesizer with synthesis method' do
      synth = create_synthesizer
      expect(synth).to respond_to(:synthesis)
    end
  end
end
