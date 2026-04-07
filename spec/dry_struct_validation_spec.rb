# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Dry::Struct attribute validation' do
  describe 'ResourceGroupAttributes' do
    let(:klass) { Pangea::Resources::Azure::Types::ResourceGroupAttributes }

    it 'constructs with valid required attributes' do
      attrs = klass.new(location: 'eastus', name: 'my-rg')
      expect(attrs.location).to eq('eastus')
      expect(attrs.name).to eq('my-rg')
    end

    it 'accepts string keys via transform_keys' do
      attrs = klass.new('location' => 'eastus', 'name' => 'my-rg')
      expect(attrs.location).to eq('eastus')
    end

    it 'raises on missing required attributes' do
      expect { klass.new(location: 'eastus') }.to raise_error(
        Dry::Struct::Error, /name/
      )
    end

    it 'raises when name is missing' do
      expect { klass.new({}) }.to raise_error(Dry::Struct::Error)
    end

    it 'allows nil for optional managed_by' do
      attrs = klass.new(location: 'eastus', name: 'rg', managed_by: nil)
      expect(attrs.managed_by).to be_nil
    end

    it 'allows nil for optional tags' do
      attrs = klass.new(location: 'eastus', name: 'rg', tags: nil)
      expect(attrs.tags).to be_nil
    end

    it 'accepts a hash for tags' do
      attrs = klass.new(location: 'eastus', name: 'rg', tags: { 'env' => 'test' })
      expect(attrs.tags).to eq({ 'env' => 'test' })
    end
  end

  describe 'LbAttributes' do
    let(:klass) { Pangea::Resources::Azure::Types::LbAttributes }

    it 'requires location, name, and resource_group_name' do
      expect {
        klass.new(location: 'eastus', name: 'lb')
      }.to raise_error(Dry::Struct::Error, /resource_group_name/)
    end

    it 'constructs with all required attributes' do
      attrs = klass.new(location: 'eastus', name: 'lb', resource_group_name: 'rg')
      expect(attrs.resource_group_name).to eq('rg')
    end

    it 'accepts optional frontend_ip_configuration as array of hashes' do
      attrs = klass.new(
        location: 'eastus',
        name: 'lb',
        resource_group_name: 'rg',
        frontend_ip_configuration: [{ 'name' => 'frontend' }]
      )
      expect(attrs.frontend_ip_configuration).to be_a(Array)
    end

    it 'allows nil for optional sku' do
      attrs = klass.new(location: 'eastus', name: 'lb', resource_group_name: 'rg', sku: nil)
      expect(attrs.sku).to be_nil
    end
  end

  describe 'LinuxVirtualMachineAttributes' do
    let(:klass) { Pangea::Resources::Azure::Types::LinuxVirtualMachineAttributes }

    it 'requires all mandatory fields' do
      expect {
        klass.new(location: 'eastus', name: 'vm')
      }.to raise_error(Dry::Struct::Error)
    end

    it 'constructs with all required attributes' do
      attrs = klass.new(
        location: 'eastus',
        name: 'vm',
        network_interface_ids: ['nic-1'],
        os_disk: [{ 'caching' => 'ReadWrite' }],
        resource_group_name: 'rg',
        size: 'Standard_B1s'
      )
      expect(attrs.location).to eq('eastus')
      expect(attrs.network_interface_ids).to eq(['nic-1'])
    end

    it 'accepts boolean optional fields' do
      attrs = klass.new(
        location: 'eastus',
        name: 'vm',
        network_interface_ids: ['nic-1'],
        os_disk: [{ 'caching' => 'ReadWrite' }],
        resource_group_name: 'rg',
        size: 'Standard_B1s',
        vtpm_enabled: false,
        secure_boot_enabled: true
      )
      expect(attrs.vtpm_enabled).to eq(false)
      expect(attrs.secure_boot_enabled).to eq(true)
    end

    it 'accepts numeric optional fields' do
      attrs = klass.new(
        location: 'eastus',
        name: 'vm',
        network_interface_ids: ['nic-1'],
        os_disk: [{ 'caching' => 'ReadWrite' }],
        resource_group_name: 'rg',
        size: 'Standard_B1s',
        max_bid_price: 0.05
      )
      expect(attrs.max_bid_price).to eq(0.05)
    end
  end
end
