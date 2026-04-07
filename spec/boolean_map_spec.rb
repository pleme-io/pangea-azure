# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Boolean field handling (map_bool)' do
  include Pangea::Testing::SynthesisTestHelpers

  let(:vm_required_attrs) do
    {
      location: 'eastus',
      name: 'my-vm',
      network_interface_ids: ['nic-1'],
      os_disk: [{ 'caching' => 'ReadWrite', 'storage_account_type' => 'Standard_LRS' }],
      resource_group_name: 'my-rg',
      size: 'Standard_B1s'
    }
  end

  describe 'false values are emitted' do
    it 'includes bypass_platform_safety_checks_on_user_schedule_enabled=false in config' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm',
        vm_required_attrs.merge(bypass_platform_safety_checks_on_user_schedule_enabled: false)
      )
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config).to have_key('bypass_platform_safety_checks_on_user_schedule_enabled')
      expect(config['bypass_platform_safety_checks_on_user_schedule_enabled']).to eq(false)
    end

    it 'includes encryption_at_host_enabled=false in config' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm',
        vm_required_attrs.merge(encryption_at_host_enabled: false)
      )
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config).to have_key('encryption_at_host_enabled')
      expect(config['encryption_at_host_enabled']).to eq(false)
    end

    it 'includes secure_boot_enabled=false in config' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm',
        vm_required_attrs.merge(secure_boot_enabled: false)
      )
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config).to have_key('secure_boot_enabled')
      expect(config['secure_boot_enabled']).to eq(false)
    end

    it 'includes vtpm_enabled=false in config' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm',
        vm_required_attrs.merge(vtpm_enabled: false)
      )
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config).to have_key('vtpm_enabled')
      expect(config['vtpm_enabled']).to eq(false)
    end
  end

  describe 'nil boolean values are omitted' do
    it 'omits boolean fields when nil (default)' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm', vm_required_attrs)
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config).not_to have_key('bypass_platform_safety_checks_on_user_schedule_enabled')
      expect(config).not_to have_key('encryption_at_host_enabled')
      expect(config).not_to have_key('secure_boot_enabled')
      expect(config).not_to have_key('vtpm_enabled')
    end
  end

  describe 'true boolean values are emitted' do
    it 'includes all boolean fields set to true' do
      synth = create_synthesizer
      synth.extend(Pangea::Resources::AzureLinuxVirtualMachine)

      synth.azurerm_linux_virtual_machine('vm',
        vm_required_attrs.merge(
          bypass_platform_safety_checks_on_user_schedule_enabled: true,
          encryption_at_host_enabled: true,
          secure_boot_enabled: true,
          vtpm_enabled: true
        )
      )
      result = normalize_synthesis(synth.synthesis)
      config = validate_resource_structure(result, 'azurerm_linux_virtual_machine', 'vm')

      expect(config['bypass_platform_safety_checks_on_user_schedule_enabled']).to eq(true)
      expect(config['encryption_at_host_enabled']).to eq(true)
      expect(config['secure_boot_enabled']).to eq(true)
      expect(config['vtpm_enabled']).to eq(true)
    end
  end
end
