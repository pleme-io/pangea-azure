# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Cross-resource synthesis' do
  include Pangea::Testing::SynthesisTestHelpers

  describe 'multiple resource types on one synthesizer' do
    it 'synthesizes different resource types in a single output' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      synth.azurerm_lb('lb', location: 'eastus', name: 'my-lb', resource_group_name: 'my-rg')

      result = normalize_synthesis(synth.synthesis)

      expect(result['resource']).to have_key('azurerm_resource_group')
      expect(result['resource']).to have_key('azurerm_lb')
      expect(result['resource']['azurerm_resource_group']).to have_key('rg')
      expect(result['resource']['azurerm_lb']).to have_key('lb')
    end

    it 'maintains independent resource configurations' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg1', location: 'eastus', name: 'rg-one')
      synth.azurerm_resource_group('rg2', location: 'westus', name: 'rg-two')
      synth.azurerm_lb('lb1', location: 'eastus', name: 'lb-one', resource_group_name: 'rg-one')

      result = normalize_synthesis(synth.synthesis)

      rg1_config = result.dig('resource', 'azurerm_resource_group', 'rg1')
      rg2_config = result.dig('resource', 'azurerm_resource_group', 'rg2')

      expect(rg1_config['location']).to eq('eastus')
      expect(rg2_config['location']).to eq('westus')
      expect(rg1_config['name']).to eq('rg-one')
      expect(rg2_config['name']).to eq('rg-two')
    end

    it 'allows using resource references as attribute values' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      rg_ref = synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      lb_ref = synth.azurerm_lb('lb',
        location: 'eastus',
        name: 'my-lb',
        resource_group_name: rg_ref.name.to_s
      )

      result = normalize_synthesis(synth.synthesis)
      lb_config = result.dig('resource', 'azurerm_lb', 'lb')

      expect(lb_config['resource_group_name']).to be_a(String)
      expect(lb_ref).to be_a(Pangea::Resources::ResourceReference)
    end

    it 'produces valid Terraform structure with multiple resource types' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      synth.azurerm_resource_group('rg', location: 'eastus', name: 'my-rg')
      synth.azurerm_lb('lb', location: 'eastus', name: 'my-lb', resource_group_name: 'my-rg')

      result = normalize_synthesis(synth.synthesis)
      validate_terraform_structure(result, :resource)
    end
  end

  describe 'resource reference chains' do
    it 'generates proper interpolation strings from id output' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      rg_ref = synth.azurerm_resource_group('main', location: 'eastus', name: 'main-rg')

      expect(rg_ref.id).to eq('${azurerm_resource_group.main.id}')
    end

    it 'generates interpolation for non-output attributes via method_missing' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      rg_ref = synth.azurerm_resource_group('main', location: 'eastus', name: 'main-rg')

      expect(rg_ref.managed_by).to eq('${azurerm_resource_group.main.managed_by}')
    end
  end
end
