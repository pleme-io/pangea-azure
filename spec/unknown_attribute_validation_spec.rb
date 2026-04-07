# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Unknown attribute validation' do
  include Pangea::Testing::SynthesisTestHelpers

  describe 'azurerm_resource_group with unknown attributes' do
    it 'raises ArgumentError for typos in attribute names' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test', location: 'eastus', name: 'rg', locaton_typo: 'bad')
      }.to raise_error(ArgumentError, /unknown attributes/)
    end

    it 'includes the unknown key name in the error message' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test', location: 'eastus', name: 'rg', foo_bar: 'x')
      }.to raise_error(ArgumentError, /foo_bar/)
    end

    it 'includes valid attribute names in the error message' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test', location: 'eastus', name: 'rg', oops: 'x')
      }.to raise_error(ArgumentError, /Valid attributes/)
    end
  end

  describe 'azurerm_lb with unknown attributes' do
    it 'raises ArgumentError for unknown attribute keys' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLb)

      expect {
        synth.azurerm_lb('test',
          location: 'eastus',
          name: 'lb',
          resource_group_name: 'rg',
          nonexistent_attr: 'bad'
        )
      }.to raise_error(ArgumentError, /unknown attributes.*nonexistent_attr/)
    end
  end

  describe 'azurerm_linux_virtual_machine with unknown attributes' do
    it 'raises ArgumentError for typos' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      expect {
        synth.azurerm_linux_virtual_machine('test',
          location: 'eastus',
          name: 'vm',
          network_interface_ids: ['nic-1'],
          os_disk: [{ 'key1' => 'val1' }],
          resource_group_name: 'rg',
          size: 'Standard_B1s',
          admin_passwrd: 'typo-key'
        )
      }.to raise_error(ArgumentError, /unknown attributes.*admin_passwrd/)
    end
  end

  describe 'multiple unknown attributes' do
    it 'reports all unknown keys' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureResourceGroup)

      expect {
        synth.azurerm_resource_group('test',
          location: 'eastus',
          name: 'rg',
          bad_one: 'x',
          bad_two: 'y'
        )
      }.to raise_error(ArgumentError, /bad_one.*bad_two|bad_two.*bad_one/)
    end
  end
end
