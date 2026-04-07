# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Azure core types' do
  before(:all) do
    require 'pangea/resources/types/azure/core'
  end

  describe 'AzureSubscriptionId' do
    let(:type) { Pangea::Resources::Types::AzureSubscriptionId }

    it 'accepts a valid UUID' do
      expect(type.call('12345678-1234-1234-1234-123456789abc')).to eq('12345678-1234-1234-1234-123456789abc')
    end

    it 'accepts uppercase UUID' do
      expect(type.call('12345678-1234-1234-1234-123456789ABC')).to eq('12345678-1234-1234-1234-123456789ABC')
    end

    it 'accepts Terraform interpolation strings' do
      expect(type.call('${var.subscription_id}')).to eq('${var.subscription_id}')
    end

    it 'rejects invalid UUID format' do
      expect { type.call('not-a-uuid') }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects empty string' do
      expect { type.call('') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureTenantId' do
    let(:type) { Pangea::Resources::Types::AzureTenantId }

    it 'accepts a valid UUID' do
      expect(type.call('abcdef01-2345-6789-abcd-ef0123456789')).to eq('abcdef01-2345-6789-abcd-ef0123456789')
    end

    it 'accepts Terraform interpolation' do
      expect(type.call('${data.azurerm_client_config.current.tenant_id}')).to eq('${data.azurerm_client_config.current.tenant_id}')
    end

    it 'rejects invalid UUID' do
      expect { type.call('invalid-tenant') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureResourceGroupName' do
    let(:type) { Pangea::Resources::Types::AzureResourceGroupName }

    it 'accepts valid resource group names' do
      expect(type.call('my-resource-group')).to eq('my-resource-group')
    end

    it 'accepts names with dots and underscores' do
      expect(type.call('rg.test_name')).to eq('rg.test_name')
    end

    it 'accepts names with parentheses' do
      expect(type.call('rg(test)')).to eq('rg(test)')
    end

    it 'rejects names with spaces' do
      expect { type.call('my resource group') }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects names longer than 90 characters' do
      expect { type.call('a' * 91) }.to raise_error(Dry::Types::ConstraintError)
    end

    it 'rejects empty string' do
      expect { type.call('') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureLocation' do
    let(:type) { Pangea::Resources::Types::AzureLocation }

    it 'accepts valid Azure regions' do
      expect(type.call('eastus')).to eq('eastus')
      expect(type.call('westeurope')).to eq('westeurope')
      expect(type.call('southeastasia')).to eq('southeastasia')
    end

    it 'rejects invalid regions' do
      expect { type.call('invalid-region') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureSku' do
    let(:type) { Pangea::Resources::Types::AzureSku }

    it 'accepts valid SKU tiers' do
      %w[Free Basic Standard Premium].each do |sku|
        expect(type.call(sku)).to eq(sku)
      end
    end

    it 'rejects invalid SKU' do
      expect { type.call('Enterprise') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureAllocationMethod' do
    let(:type) { Pangea::Resources::Types::AzureAllocationMethod }

    it 'accepts Static and Dynamic' do
      expect(type.call('Static')).to eq('Static')
      expect(type.call('Dynamic')).to eq('Dynamic')
    end

    it 'rejects invalid allocation methods' do
      expect { type.call('auto') }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe 'AzureNetworkProtocol' do
    let(:type) { Pangea::Resources::Types::AzureNetworkProtocol }

    it 'accepts Tcp, Udp, Icmp, and wildcard' do
      %w[Tcp Udp Icmp *].each do |proto|
        expect(type.call(proto)).to eq(proto)
      end
    end
  end

  describe 'AzureNetworkAccess' do
    let(:type) { Pangea::Resources::Types::AzureNetworkAccess }

    it 'accepts Allow and Deny' do
      expect(type.call('Allow')).to eq('Allow')
      expect(type.call('Deny')).to eq('Deny')
    end
  end

  describe 'AzureIdentityType' do
    let(:type) { Pangea::Resources::Types::AzureIdentityType }

    it 'accepts SystemAssigned' do
      expect(type.call('SystemAssigned')).to eq('SystemAssigned')
    end

    it 'accepts UserAssigned' do
      expect(type.call('UserAssigned')).to eq('UserAssigned')
    end

    it 'accepts combined SystemAssigned, UserAssigned' do
      expect(type.call('SystemAssigned, UserAssigned')).to eq('SystemAssigned, UserAssigned')
    end
  end

  describe 'AzureSubnetId' do
    let(:type) { Pangea::Resources::Types::AzureSubnetId }

    it 'accepts Terraform interpolation' do
      expect(type.call('${azurerm_subnet.main.id}')).to eq('${azurerm_subnet.main.id}')
    end

    it 'accepts Azure resource paths' do
      id = '/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet'
      expect(type.call(id)).to eq(id)
    end

    it 'passes through other strings' do
      expect(type.call('some-string')).to eq('some-string')
    end
  end

  describe 'AzureTags' do
    let(:type) { Pangea::Resources::Types::AzureTags }

    it 'defaults to empty hash' do
      expect(type.call({})).to eq({})
    end

    it 'accepts string key-value pairs' do
      tags = { 'env' => 'production', 'team' => 'platform' }
      expect(type.call(tags)).to eq(tags)
    end
  end

  describe 'AzureCosmosDbConsistencyLevel' do
    let(:type) { Pangea::Resources::Types::AzureCosmosDbConsistencyLevel }

    it 'accepts all valid consistency levels' do
      %w[BoundedStaleness ConsistentPrefix Eventual Session Strong].each do |level|
        expect(type.call(level)).to eq(level)
      end
    end

    it 'rejects invalid levels' do
      expect { type.call('Relaxed') }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
