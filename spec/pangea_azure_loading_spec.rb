# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Pangea Azure gem loading' do
  describe 'module hierarchy' do
    it 'defines Pangea::Resources::Azure module' do
      expect(defined?(Pangea::Resources::Azure)).to eq('constant')
    end

    it 'defines Pangea::Resources::Azure::Types namespace' do
      expect(defined?(Pangea::Resources::Azure::Types)).to eq('constant')
    end

    it 'defines individual resource modules' do
      expect(defined?(Pangea::Resources::AzureResourceGroup)).to eq('constant')
      expect(defined?(Pangea::Resources::AzureLb)).to eq('constant')
      expect(defined?(Pangea::Resources::AzureLinuxVirtualMachine)).to eq('constant')
    end
  end

  describe 'Azure aggregate module' do
    it 'includes resource group methods' do
      expect(Pangea::Resources::Azure.instance_methods).to include(:azurerm_resource_group)
    end

    it 'includes lb methods' do
      expect(Pangea::Resources::Azure.instance_methods).to include(:azurerm_lb)
    end

    it 'includes linux virtual machine methods' do
      expect(Pangea::Resources::Azure.instance_methods).to include(:azurerm_linux_virtual_machine)
    end

    it 'provides a large number of resource methods' do
      azurerm_methods = Pangea::Resources::Azure.instance_methods.select { |m| m.to_s.start_with?('azurerm_') }
      expect(azurerm_methods.length).to be > 100
    end
  end

  describe 'type classes' do
    it 'defines ResourceGroupAttributes as a Dry::Struct' do
      expect(Pangea::Resources::Azure::Types::ResourceGroupAttributes).to be < Dry::Struct
    end

    it 'defines LbAttributes as a Dry::Struct' do
      expect(Pangea::Resources::Azure::Types::LbAttributes).to be < Dry::Struct
    end
  end
end
