# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ResourceReference behavior' do
  include Pangea::Testing::SynthesisTestHelpers

  describe 'output interpolation' do
    it 'generates ${type.name.attr} format for output attributes' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)
      ref = synth.azurerm_resource_group('main', location: 'eastus', name: 'main-rg')

      expect(ref.id).to match(/\$\{azurerm_resource_group\.main\.id\}/)
    end

    it 'generates interpolation for defined outputs on lb' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLb)
      ref = synth.azurerm_lb('main',
        location: 'eastus',
        name: 'main-lb',
        resource_group_name: 'rg'
      )

      expect(ref.id).to eq('${azurerm_lb.main.id}')
    end
  end

  describe 'resource_type' do
    it 'returns the type as a symbol' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)
      ref = synth.azurerm_resource_group('test', location: 'eastus', name: 'rg')

      expect(ref.resource_type).to eq(:azurerm_resource_group)
    end
  end

  describe 'method_missing fallback for unknown attributes' do
    it 'returns interpolation string for any method call' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)
      ref = synth.azurerm_resource_group('test', location: 'eastus', name: 'rg')

      expect(ref.some_computed_attr).to eq('${azurerm_resource_group.test.some_computed_attr}')
    end

    it 'responds to arbitrary attribute names' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)
      ref = synth.azurerm_resource_group('test', location: 'eastus', name: 'rg')

      expect(ref.respond_to?(:arbitrary_attr)).to be true
    end
  end

  describe 'multiple references from the same synthesizer' do
    it 'tracks each reference independently' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::Azure)

      ref1 = synth.azurerm_resource_group('rg1', location: 'eastus', name: 'rg-1')
      ref2 = synth.azurerm_resource_group('rg2', location: 'westus', name: 'rg-2')

      expect(ref1.id).to eq('${azurerm_resource_group.rg1.id}')
      expect(ref2.id).to eq('${azurerm_resource_group.rg2.id}')
      expect(ref1.id).not_to eq(ref2.id)
    end
  end

  describe 'resource reference with complex outputs' do
    it 'generates interpolation for computed attributes on linux VM' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      ref = synth.azurerm_linux_virtual_machine('vm',
        location: 'eastus',
        name: 'my-vm',
        network_interface_ids: ['nic-1'],
        os_disk: [{ 'caching' => 'ReadWrite' }],
        resource_group_name: 'rg',
        size: 'Standard_B1s'
      )

      expect(ref.private_ip_address).to eq('${azurerm_linux_virtual_machine.vm.private_ip_address}')
      expect(ref.virtual_machine_id).to eq('${azurerm_linux_virtual_machine.vm.virtual_machine_id}')
      expect(ref.public_ip_address).to eq('${azurerm_linux_virtual_machine.vm.public_ip_address}')
    end
  end
end
