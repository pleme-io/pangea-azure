# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea-azure'

RSpec.describe 'Azure resource edge cases' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  # ---------------------------------------------------------------------------
  # Core type validation
  # ---------------------------------------------------------------------------
  describe 'Azure core types' do
    describe 'AzureSubscriptionId' do
      it 'accepts valid UUID' do
        type = Pangea::Resources::Types::AzureSubscriptionId
        expect(type['12345678-abcd-1234-abcd-123456789abc']).to eq('12345678-abcd-1234-abcd-123456789abc')
      end

      it 'accepts Terraform interpolation string' do
        type = Pangea::Resources::Types::AzureSubscriptionId
        expect(type['${var.subscription_id}']).to eq('${var.subscription_id}')
      end

      it 'rejects invalid UUID format' do
        type = Pangea::Resources::Types::AzureSubscriptionId
        expect { type['not-a-uuid'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects empty string' do
        type = Pangea::Resources::Types::AzureSubscriptionId
        expect { type[''] }.to raise_error(Dry::Types::ConstraintError)
      end
    end

    describe 'AzureTenantId' do
      it 'accepts valid UUID' do
        type = Pangea::Resources::Types::AzureTenantId
        expect(type['abcdef01-2345-6789-abcd-ef0123456789']).to eq('abcdef01-2345-6789-abcd-ef0123456789')
      end

      it 'accepts Terraform interpolation' do
        type = Pangea::Resources::Types::AzureTenantId
        expect(type['${data.azurerm_client_config.current.tenant_id}']).to eq('${data.azurerm_client_config.current.tenant_id}')
      end

      it 'rejects invalid format' do
        type = Pangea::Resources::Types::AzureTenantId
        expect { type['bad-tenant'] }.to raise_error(Dry::Types::ConstraintError)
      end
    end

    describe 'AzureLocation' do
      it 'accepts valid locations' do
        type = Pangea::Resources::Types::AzureLocation
        %w[eastus westeurope brazilsouth japaneast australiaeast].each do |loc|
          expect(type[loc]).to eq(loc)
        end
      end

      it 'rejects invalid location' do
        type = Pangea::Resources::Types::AzureLocation
        expect { type['invalidregion'] }.to raise_error(Dry::Types::ConstraintError)
      end
    end

    describe 'AzureResourceGroupName' do
      it 'accepts valid names with special characters' do
        type = Pangea::Resources::Types::AzureResourceGroupName
        expect(type['rg-test_01.(dev)']).to eq('rg-test_01.(dev)')
      end

      it 'rejects names with invalid characters' do
        type = Pangea::Resources::Types::AzureResourceGroupName
        expect { type['rg test!'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects empty string' do
        type = Pangea::Resources::Types::AzureResourceGroupName
        expect { type[''] }.to raise_error(Dry::Types::ConstraintError)
      end
    end

    describe 'AzureTags' do
      it 'defaults to empty hash' do
        type = Pangea::Resources::Types::AzureTags
        expect(type[]).to eq({})
      end
    end

    describe 'AzureResourceId' do
      it 'accepts Terraform interpolation' do
        type = Pangea::Resources::Types::AzureResourceId
        expect(type['${azurerm_resource_group.test.id}']).to eq('${azurerm_resource_group.test.id}')
      end

      it 'accepts Azure resource paths' do
        type = Pangea::Resources::Types::AzureResourceId
        expect(type['/subscriptions/sub-id/resourceGroups/rg']).to eq('/subscriptions/sub-id/resourceGroups/rg')
      end
    end

    describe 'enum types' do
      it 'rejects invalid allocation method' do
        expect { Pangea::Resources::Types::AzureAllocationMethod['Invalid'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid IP SKU' do
        expect { Pangea::Resources::Types::AzureIpSku['Invalid'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid network protocol' do
        expect { Pangea::Resources::Types::AzureNetworkProtocol['Http'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'accepts wildcard protocol' do
        expect(Pangea::Resources::Types::AzureNetworkProtocol['*']).to eq('*')
      end

      it 'rejects invalid network direction' do
        expect { Pangea::Resources::Types::AzureNetworkDirection['Both'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid OS disk caching' do
        expect { Pangea::Resources::Types::AzureOsDiskCaching['WriteOnly'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid managed disk type' do
        expect { Pangea::Resources::Types::AzureManagedDiskType['SSD_LRS'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid identity type' do
        expect { Pangea::Resources::Types::AzureIdentityType['ManagedIdentity'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'accepts compound identity type' do
        expect(Pangea::Resources::Types::AzureIdentityType['SystemAssigned, UserAssigned']).to eq('SystemAssigned, UserAssigned')
      end

      it 'rejects invalid container registry SKU' do
        expect { Pangea::Resources::Types::AzureContainerRegistrySku['Enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid key vault SKU' do
        expect { Pangea::Resources::Types::AzureKeyVaultSku['enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid storage replication type' do
        expect { Pangea::Resources::Types::AzureAccountReplicationType['XRS'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid container access type' do
        expect { Pangea::Resources::Types::AzureContainerAccessType['public'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid Redis family' do
        expect { Pangea::Resources::Types::AzureRedisFamily['D'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid CosmosDB kind' do
        expect { Pangea::Resources::Types::AzureCosmosDbKind['Cassandra'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid CosmosDB consistency level' do
        expect { Pangea::Resources::Types::AzureCosmosDbConsistencyLevel['Weak'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid App Gateway SKU name' do
        expect { Pangea::Resources::Types::AzureAppGatewaySkuName['Invalid_v3'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid App Gateway SKU tier' do
        expect { Pangea::Resources::Types::AzureAppGatewaySkuTier['Enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid Log Analytics SKU' do
        expect { Pangea::Resources::Types::AzureLogAnalyticsSku['Enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid Service Bus SKU' do
        expect { Pangea::Resources::Types::AzureServiceBusSku['Enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end

      it 'rejects invalid Redis SKU' do
        expect { Pangea::Resources::Types::AzureRedisSku['Enterprise'] }.to raise_error(Dry::Types::ConstraintError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Resource Group edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_resource_group' do
    it 'rejects missing name' do
      expect {
        Pangea::Resources::Azure::Types::ResourceGroupAttributes.new(
          location: 'eastus'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects missing location' do
      expect {
        Pangea::Resources::Azure::Types::ResourceGroupAttributes.new(
          name: 'rg-test'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects invalid location enum' do
      expect {
        Pangea::Resources::Azure::Types::ResourceGroupAttributes.new(
          name: 'rg-test', location: 'moon-base-1'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'defaults tags to empty hash' do
      attrs = Pangea::Resources::Azure::Types::ResourceGroupAttributes.new(
        name: 'rg-test', location: 'eastus'
      )
      expect(attrs.tags).to eq({})
    end

    it 'synthesizes without tags when empty' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_resource_group(:no_tags, {
          name: "rg-empty-tags",
          location: "westus2"
        })
      end

      result = synthesizer.synthesis
      rg = result[:resource][:azurerm_resource_group][:no_tags]

      expect(rg[:name]).to eq("rg-empty-tags")
      expect(rg).not_to have_key(:tags)
    end
  end

  # ---------------------------------------------------------------------------
  # Virtual Network edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_virtual_network' do
    it 'rejects missing address_space' do
      expect {
        Pangea::Resources::Azure::Types::VirtualNetworkAttributes.new(
          name: 'vnet-test',
          resource_group_name: 'rg-test',
          location: 'eastus'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects non-array address_space' do
      expect {
        Pangea::Resources::Azure::Types::VirtualNetworkAttributes.new(
          name: 'vnet-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          address_space: '10.0.0.0/16'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with multiple address spaces' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_virtual_network(:multi_cidr, {
          name: "vnet-multi",
          resource_group_name: "rg-test",
          location: "eastus",
          address_space: ["10.0.0.0/16", "172.16.0.0/16"]
        })
      end

      result = synthesizer.synthesis
      vnet = result[:resource][:azurerm_virtual_network][:multi_cidr]

      expect(vnet[:address_space]).to eq(["10.0.0.0/16", "172.16.0.0/16"])
    end

    it 'provides guid in resource reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_virtual_network(:test_ref, {
          name: "vnet-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          address_space: ["10.0.0.0/16"]
        })
      end

      expect(ref.outputs[:guid]).to eq("${azurerm_virtual_network.test_ref.guid}")
    end
  end

  # ---------------------------------------------------------------------------
  # Subnet edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_subnet' do
    it 'defaults service_endpoints to nil' do
      attrs = Pangea::Resources::Azure::Types::SubnetAttributes.new(
        name: 'subnet-test',
        resource_group_name: 'rg-test',
        virtual_network_name: 'vnet-test',
        address_prefixes: ['10.0.1.0/24']
      )
      expect(attrs.service_endpoints).to be_nil
    end

    it 'defaults delegation to nil' do
      attrs = Pangea::Resources::Azure::Types::SubnetAttributes.new(
        name: 'subnet-test',
        resource_group_name: 'rg-test',
        virtual_network_name: 'vnet-test',
        address_prefixes: ['10.0.1.0/24']
      )
      expect(attrs.delegation).to be_nil
    end

    it 'synthesizes with service endpoints' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_subnet(:with_endpoints, {
          name: "subnet-endpoints",
          resource_group_name: "rg-test",
          virtual_network_name: "vnet-test",
          address_prefixes: ["10.0.1.0/24"],
          service_endpoints: ["Microsoft.Storage", "Microsoft.Sql"]
        })
      end

      result = synthesizer.synthesis
      subnet = result[:resource][:azurerm_subnet][:with_endpoints]

      expect(subnet[:service_endpoints]).to eq(["Microsoft.Storage", "Microsoft.Sql"])
    end

    it 'omits service_endpoints when nil' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_subnet(:no_endpoints, {
          name: "subnet-basic",
          resource_group_name: "rg-test",
          virtual_network_name: "vnet-test",
          address_prefixes: ["10.0.2.0/24"]
        })
      end

      result = synthesizer.synthesis
      subnet = result[:resource][:azurerm_subnet][:no_endpoints]

      expect(subnet).not_to have_key(:service_endpoints)
    end
  end

  # ---------------------------------------------------------------------------
  # Network Security Rule edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_network_security_rule' do
    it 'rejects missing required fields' do
      expect {
        Pangea::Resources::Azure::Types::NetworkSecurityRuleAttributes.new(
          name: 'rule-test',
          resource_group_name: 'rg-test',
          network_security_group_name: 'nsg-test'
          # missing priority, direction, access, protocol
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects invalid direction' do
      expect {
        Pangea::Resources::Azure::Types::NetworkSecurityRuleAttributes.new(
          name: 'rule-test',
          resource_group_name: 'rg-test',
          network_security_group_name: 'nsg-test',
          priority: 100,
          direction: 'Bidirectional',
          access: 'Allow',
          protocol: 'Tcp'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects invalid access' do
      expect {
        Pangea::Resources::Azure::Types::NetworkSecurityRuleAttributes.new(
          name: 'rule-test',
          resource_group_name: 'rg-test',
          network_security_group_name: 'nsg-test',
          priority: 100,
          direction: 'Inbound',
          access: 'Block',
          protocol: 'Tcp'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'coerces priority from string to integer' do
      attrs = Pangea::Resources::Azure::Types::NetworkSecurityRuleAttributes.new(
        name: 'rule-test',
        resource_group_name: 'rg-test',
        network_security_group_name: 'nsg-test',
        priority: '200',
        direction: 'Outbound',
        access: 'Deny',
        protocol: 'Udp'
      )
      expect(attrs.priority).to eq(200)
    end

    it 'synthesizes with port ranges arrays' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_rule(:multi_ports, {
          name: "allow-web",
          resource_group_name: "rg-test",
          network_security_group_name: "nsg-test",
          priority: 110,
          direction: "Inbound",
          access: "Allow",
          protocol: "Tcp",
          source_port_ranges: ["80", "443"],
          destination_port_ranges: ["8080", "8443"],
          source_address_prefixes: ["10.0.0.0/8", "172.16.0.0/12"],
          destination_address_prefixes: ["192.168.0.0/16"]
        })
      end

      result = synthesizer.synthesis
      rule = result[:resource][:azurerm_network_security_rule][:multi_ports]

      expect(rule[:source_port_ranges]).to eq(["80", "443"])
      expect(rule[:destination_port_ranges]).to eq(["8080", "8443"])
      expect(rule[:source_address_prefixes]).to eq(["10.0.0.0/8", "172.16.0.0/12"])
      expect(rule[:destination_address_prefixes]).to eq(["192.168.0.0/16"])
    end

    it 'synthesizes with description' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_rule(:described, {
          name: "deny-all",
          resource_group_name: "rg-test",
          network_security_group_name: "nsg-test",
          priority: 4096,
          direction: "Inbound",
          access: "Deny",
          protocol: "*",
          source_port_range: "*",
          destination_port_range: "*",
          source_address_prefix: "*",
          destination_address_prefix: "*",
          description: "Deny all inbound traffic"
        })
      end

      result = synthesizer.synthesis
      rule = result[:resource][:azurerm_network_security_rule][:described]

      expect(rule[:description]).to eq("Deny all inbound traffic")
      expect(rule[:protocol]).to eq("*")
    end

    it 'omits nil optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_security_rule(:minimal, {
          name: "minimal-rule",
          resource_group_name: "rg-test",
          network_security_group_name: "nsg-test",
          priority: 100,
          direction: "Inbound",
          access: "Allow",
          protocol: "Tcp"
        })
      end

      result = synthesizer.synthesis
      rule = result[:resource][:azurerm_network_security_rule][:minimal]

      expect(rule).not_to have_key(:source_port_range)
      expect(rule).not_to have_key(:destination_port_range)
      expect(rule).not_to have_key(:description)
      expect(rule).not_to have_key(:source_port_ranges)
    end
  end

  # ---------------------------------------------------------------------------
  # Public IP edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_public_ip' do
    it 'defaults sku to nil' do
      attrs = Pangea::Resources::Azure::Types::PublicIpAttributes.new(
        name: 'pip-test',
        resource_group_name: 'rg-test',
        location: 'eastus',
        allocation_method: 'Static'
      )
      expect(attrs.sku).to be_nil
    end

    it 'synthesizes with SKU' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_public_ip(:with_sku, {
          name: "pip-standard",
          resource_group_name: "rg-test",
          location: "eastus",
          allocation_method: "Static",
          sku: "Standard"
        })
      end

      result = synthesizer.synthesis
      pip = result[:resource][:azurerm_public_ip][:with_sku]

      expect(pip[:sku]).to eq("Standard")
      expect(pip[:allocation_method]).to eq("Static")
    end

    it 'provides fqdn in resource reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_public_ip(:ref_test, {
          name: "pip-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          allocation_method: "Dynamic"
        })
      end

      expect(ref.outputs[:ip_address]).to eq("${azurerm_public_ip.ref_test.ip_address}")
      expect(ref.outputs[:fqdn]).to eq("${azurerm_public_ip.ref_test.fqdn}")
    end
  end

  # ---------------------------------------------------------------------------
  # Network Interface nested structures
  # ---------------------------------------------------------------------------
  describe 'azurerm_network_interface' do
    it 'rejects missing ip_configuration' do
      expect {
        Pangea::Resources::Azure::Types::NetworkInterfaceAttributes.new(
          name: 'nic-test',
          resource_group_name: 'rg-test',
          location: 'eastus'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with static private IP and public IP' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_interface(:static_ip, {
          name: "nic-static",
          resource_group_name: "rg-test",
          location: "eastus",
          ip_configuration: {
            name: "primary",
            subnet_id: "${azurerm_subnet.test.id}",
            private_ip_address_allocation: "Static",
            private_ip_address: "10.0.1.10",
            public_ip_address_id: "${azurerm_public_ip.test.id}"
          }
        })
      end

      result = synthesizer.synthesis
      nic = result[:resource][:azurerm_network_interface][:static_ip]

      expect(nic).to include(name: "nic-static")
    end

    it 'provides mac_address in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_network_interface(:ref_mac, {
          name: "nic-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          ip_configuration: {
            name: "internal",
            subnet_id: "${azurerm_subnet.test.id}",
            private_ip_address_allocation: "Dynamic"
          }
        })
      end

      expect(ref.outputs[:mac_address]).to eq("${azurerm_network_interface.ref_mac.mac_address}")
      expect(ref.outputs[:private_ip_address]).to eq("${azurerm_network_interface.ref_mac.private_ip_address}")
    end
  end

  # ---------------------------------------------------------------------------
  # Linux Virtual Machine nested structures
  # ---------------------------------------------------------------------------
  describe 'azurerm_linux_virtual_machine' do
    it 'rejects missing os_disk' do
      expect {
        Pangea::Resources::Azure::Types::LinuxVirtualMachineAttributes.new(
          name: 'vm-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          size: 'Standard_B2s',
          admin_username: 'admin',
          network_interface_ids: ['nic-id']
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects invalid os_disk caching enum' do
      expect {
        Pangea::Resources::Azure::Types::LinuxVmOsDisk.new(
          caching: 'WriteThrough',
          storage_account_type: 'Standard_LRS'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with custom_data and disable_password_authentication' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_linux_virtual_machine(:with_custom_data, {
          name: "vm-custom",
          resource_group_name: "rg-test",
          location: "westeurope",
          size: "Standard_D4s_v3",
          admin_username: "azureuser",
          disable_password_authentication: true,
          network_interface_ids: ["${azurerm_network_interface.test.id}"],
          os_disk: {
            caching: "ReadOnly",
            storage_account_type: "Premium_LRS",
            disk_size_gb: 128
          },
          custom_data: "IyEvYmluL2Jhc2g=",
          tags: { "Role" => "web-server" }
        })
      end

      result = synthesizer.synthesis
      vm = result[:resource][:azurerm_linux_virtual_machine][:with_custom_data]

      expect(vm[:custom_data]).to eq("IyEvYmluL2Jhc2g=")
      expect(vm[:disable_password_authentication]).to eq(true)
      expect(vm[:tags]).to include("Role" => "web-server")
    end

    it 'synthesizes without source_image_reference' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_linux_virtual_machine(:no_image, {
          name: "vm-no-image",
          resource_group_name: "rg-test",
          location: "eastus",
          size: "Standard_B1s",
          admin_username: "admin",
          network_interface_ids: ["nic-1"],
          os_disk: {
            caching: "None",
            storage_account_type: "StandardSSD_LRS"
          }
        })
      end

      result = synthesizer.synthesis
      vm = result[:resource][:azurerm_linux_virtual_machine][:no_image]

      expect(vm[:name]).to eq("vm-no-image")
    end

    it 'synthesizes os_disk with disk_size_gb' do
      attrs = Pangea::Resources::Azure::Types::LinuxVmOsDisk.new(
        caching: 'ReadWrite',
        storage_account_type: 'Standard_LRS',
        disk_size_gb: 256
      )
      expect(attrs.disk_size_gb).to eq(256)
    end

    it 'provides public_ip_address in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_linux_virtual_machine(:ref_test, {
          name: "vm-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          size: "Standard_B1s",
          admin_username: "admin",
          network_interface_ids: ["nic-1"],
          os_disk: {
            caching: "ReadWrite",
            storage_account_type: "Standard_LRS"
          }
        })
      end

      expect(ref.outputs[:public_ip_address]).to eq("${azurerm_linux_virtual_machine.ref_test.public_ip_address}")
      expect(ref.outputs[:private_ip_address]).to eq("${azurerm_linux_virtual_machine.ref_test.private_ip_address}")
    end
  end

  # ---------------------------------------------------------------------------
  # Storage Account edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_storage_account' do
    it 'rejects invalid account tier' do
      expect {
        Pangea::Resources::Azure::Types::StorageAccountAttributes.new(
          name: 'sa-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          account_tier: 'Enterprise',
          account_replication_type: 'LRS'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects invalid replication type' do
      expect {
        Pangea::Resources::Azure::Types::StorageAccountAttributes.new(
          name: 'sa-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          account_tier: 'Standard',
          account_replication_type: 'INVALID'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with all optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_account(:full, {
          name: "safull",
          resource_group_name: "rg-test",
          location: "eastus",
          account_tier: "Standard",
          account_replication_type: "GRS",
          account_kind: "StorageV2",
          access_tier: "Hot",
          enable_https_traffic_only: true,
          min_tls_version: "TLS1_2",
          tags: { "Purpose" => "backup" }
        })
      end

      result = synthesizer.synthesis
      sa = result[:resource][:azurerm_storage_account][:full]

      expect(sa[:account_kind]).to eq("StorageV2")
      expect(sa[:access_tier]).to eq("Hot")
      expect(sa[:enable_https_traffic_only]).to eq(true)
      expect(sa[:min_tls_version]).to eq("TLS1_2")
    end

    it 'provides connection string in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_account(:ref_test, {
          name: "saref",
          resource_group_name: "rg-test",
          location: "eastus",
          account_tier: "Standard",
          account_replication_type: "LRS"
        })
      end

      expect(ref.outputs[:primary_access_key]).to eq("${azurerm_storage_account.ref_test.primary_access_key}")
      expect(ref.outputs[:primary_blob_endpoint]).to eq("${azurerm_storage_account.ref_test.primary_blob_endpoint}")
      expect(ref.outputs[:primary_connection_string]).to eq("${azurerm_storage_account.ref_test.primary_connection_string}")
    end
  end

  # ---------------------------------------------------------------------------
  # Storage Container edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_storage_container' do
    it 'defaults container_access_type to private' do
      attrs = Pangea::Resources::Azure::Types::StorageContainerAttributes.new(
        name: 'container-test',
        storage_account_name: 'sa-test'
      )
      expect(attrs.container_access_type).to eq('private')
    end

    it 'rejects invalid container_access_type' do
      expect {
        Pangea::Resources::Azure::Types::StorageContainerAttributes.new(
          name: 'container-test',
          storage_account_name: 'sa-test',
          container_access_type: 'public'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with blob access type' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_storage_container(:blob_access, {
          name: "assets",
          storage_account_name: "satest",
          container_access_type: "blob"
        })
      end

      result = synthesizer.synthesis
      container = result[:resource][:azurerm_storage_container][:blob_access]

      expect(container[:container_access_type]).to eq("blob")
    end
  end

  # ---------------------------------------------------------------------------
  # Key Vault edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_key_vault' do
    it 'synthesizes with all boolean options' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault(:full_opts, {
          name: "kv-full",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "premium",
          tenant_id: "12345678-abcd-1234-abcd-123456789abc",
          soft_delete_retention_days: 90,
          purge_protection_enabled: true,
          enabled_for_deployment: true,
          enabled_for_disk_encryption: false,
          enabled_for_template_deployment: true,
          tags: { "Env" => "prod" }
        })
      end

      result = synthesizer.synthesis
      kv = result[:resource][:azurerm_key_vault][:full_opts]

      expect(kv[:sku_name]).to eq("premium")
      expect(kv[:soft_delete_retention_days]).to eq(90)
      expect(kv[:purge_protection_enabled]).to eq(true)
      expect(kv[:enabled_for_deployment]).to eq(true)
      expect(kv[:enabled_for_disk_encryption]).to eq(false)
      expect(kv[:enabled_for_template_deployment]).to eq(true)
    end

    it 'provides vault_uri in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault(:ref_test, {
          name: "kv-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "standard",
          tenant_id: "12345678-abcd-1234-abcd-123456789abc"
        })
      end

      expect(ref.outputs[:vault_uri]).to eq("${azurerm_key_vault.ref_test.vault_uri}")
    end
  end

  # ---------------------------------------------------------------------------
  # Key Vault Secret edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_key_vault_secret' do
    it 'synthesizes with content_type and dates' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault_secret(:with_dates, {
          name: "db-password",
          value: "supersecret123",
          key_vault_id: "${azurerm_key_vault.test.id}",
          content_type: "password",
          not_before_date: "2025-01-01T00:00:00Z",
          expiration_date: "2026-01-01T00:00:00Z",
          tags: { "Rotation" => "quarterly" }
        })
      end

      result = synthesizer.synthesis
      secret = result[:resource][:azurerm_key_vault_secret][:with_dates]

      expect(secret[:content_type]).to eq("password")
      expect(secret[:not_before_date]).to eq("2025-01-01T00:00:00Z")
      expect(secret[:expiration_date]).to eq("2026-01-01T00:00:00Z")
    end

    it 'provides version in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_key_vault_secret(:ref_test, {
          name: "secret-ref",
          value: "val",
          key_vault_id: "${azurerm_key_vault.test.id}"
        })
      end

      expect(ref.outputs[:version]).to eq("${azurerm_key_vault_secret.ref_test.version}")
      expect(ref.outputs[:versionless_id]).to eq("${azurerm_key_vault_secret.ref_test.versionless_id}")
    end
  end

  # ---------------------------------------------------------------------------
  # Kubernetes Cluster nested structures
  # ---------------------------------------------------------------------------
  describe 'azurerm_kubernetes_cluster' do
    it 'rejects missing default_node_pool' do
      expect {
        Pangea::Resources::Azure::Types::KubernetesClusterAttributes.new(
          name: 'aks-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          dns_prefix: 'akstest'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with auto-scaling node pool' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_kubernetes_cluster(:autoscale, {
          name: "aks-autoscale",
          resource_group_name: "rg-test",
          location: "eastus",
          dns_prefix: "aksauto",
          kubernetes_version: "1.28.3",
          sku_tier: "Standard",
          default_node_pool: {
            name: "system",
            vm_size: "Standard_D4s_v3",
            node_count: 3,
            min_count: 1,
            max_count: 10,
            enable_auto_scaling: true,
            os_disk_size_gb: 128
          },
          identity: {
            type: "SystemAssigned"
          },
          tags: { "Cluster" => "production" }
        })
      end

      result = synthesizer.synthesis
      aks = result[:resource][:azurerm_kubernetes_cluster][:autoscale]

      expect(aks[:kubernetes_version]).to eq("1.28.3")
      expect(aks[:sku_tier]).to eq("Standard")
      expect(aks[:tags]).to include("Cluster" => "production")
    end

    it 'synthesizes without identity block' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_kubernetes_cluster(:no_identity, {
          name: "aks-basic",
          resource_group_name: "rg-test",
          location: "eastus",
          dns_prefix: "aksbasic",
          default_node_pool: {
            name: "default",
            vm_size: "Standard_B2s",
            node_count: 1
          }
        })
      end

      result = synthesizer.synthesis
      aks = result[:resource][:azurerm_kubernetes_cluster][:no_identity]

      expect(aks[:name]).to eq("aks-basic")
    end

    it 'provides kube_config_raw and node_resource_group in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_kubernetes_cluster(:ref_outputs, {
          name: "aks-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          dns_prefix: "aksref",
          default_node_pool: {
            name: "default",
            vm_size: "Standard_B2s",
            node_count: 1
          }
        })
      end

      expect(ref.outputs[:kube_config_raw]).to eq("${azurerm_kubernetes_cluster.ref_outputs.kube_config_raw}")
      expect(ref.outputs[:node_resource_group]).to eq("${azurerm_kubernetes_cluster.ref_outputs.node_resource_group}")
    end

    it 'coerces node_count from string' do
      attrs = Pangea::Resources::Azure::Types::AksDefaultNodePool.new(
        name: 'default',
        vm_size: 'Standard_B2s',
        node_count: '5'
      )
      expect(attrs.node_count).to eq(5)
    end
  end

  # ---------------------------------------------------------------------------
  # Container Registry edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_container_registry' do
    it 'synthesizes with admin_enabled false' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_container_registry(:no_admin, {
          name: "crnonadmin",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Basic",
          admin_enabled: false
        })
      end

      result = synthesizer.synthesis
      acr = result[:resource][:azurerm_container_registry][:no_admin]

      expect(acr[:admin_enabled]).to eq(false)
    end

    it 'provides login_server in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_container_registry(:ref_test, {
          name: "crref",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      expect(ref.outputs[:login_server]).to eq("${azurerm_container_registry.ref_test.login_server}")
      expect(ref.outputs[:admin_username]).to eq("${azurerm_container_registry.ref_test.admin_username}")
      expect(ref.outputs[:admin_password]).to eq("${azurerm_container_registry.ref_test.admin_password}")
    end
  end

  # ---------------------------------------------------------------------------
  # PostgreSQL Flexible Server edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_postgresql_flexible_server' do
    it 'synthesizes with all optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server(:full, {
          name: "psql-full",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "GP_Standard_D4s_v3",
          version: "16",
          administrator_login: "pgadmin",
          administrator_password: "P@ssw0rd!",
          storage_mb: 65536,
          backup_retention_days: 35,
          geo_redundant_backup_enabled: true,
          zone: "1",
          delegated_subnet_id: "${azurerm_subnet.pg.id}",
          private_dns_zone_id: "${azurerm_private_dns_zone.pg.id}",
          tags: { "Service" => "database" }
        })
      end

      result = synthesizer.synthesis
      pg = result[:resource][:azurerm_postgresql_flexible_server][:full]

      expect(pg[:version]).to eq("16")
      expect(pg[:storage_mb]).to eq(65536)
      expect(pg[:backup_retention_days]).to eq(35)
      expect(pg[:geo_redundant_backup_enabled]).to eq(true)
      expect(pg[:zone]).to eq("1")
      expect(pg[:delegated_subnet_id]).to eq("${azurerm_subnet.pg.id}")
    end

    it 'provides fqdn in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server(:ref_test, {
          name: "psql-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          sku_name: "B_Standard_B1ms"
        })
      end

      expect(ref.outputs[:fqdn]).to eq("${azurerm_postgresql_flexible_server.ref_test.fqdn}")
    end
  end

  # ---------------------------------------------------------------------------
  # PostgreSQL Flexible Server Database edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_postgresql_flexible_server_database' do
    it 'synthesizes with charset and collation' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server_database(:with_charset, {
          name: "mydb",
          server_id: "${azurerm_postgresql_flexible_server.test.id}",
          charset: "UTF8",
          collation: "en_US.utf8"
        })
      end

      result = synthesizer.synthesis
      db = result[:resource][:azurerm_postgresql_flexible_server_database][:with_charset]

      expect(db[:charset]).to eq("UTF8")
      expect(db[:collation]).to eq("en_US.utf8")
    end

    it 'omits optional charset and collation when nil' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_postgresql_flexible_server_database(:minimal, {
          name: "mindb",
          server_id: "${azurerm_postgresql_flexible_server.test.id}"
        })
      end

      result = synthesizer.synthesis
      db = result[:resource][:azurerm_postgresql_flexible_server_database][:minimal]

      expect(db).not_to have_key(:charset)
      expect(db).not_to have_key(:collation)
    end
  end

  # ---------------------------------------------------------------------------
  # DNS Zone edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_dns_zone' do
    it 'provides name_servers in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_zone(:ref_test, {
          name: "example.com",
          resource_group_name: "rg-test"
        })
      end

      expect(ref.outputs[:name_servers]).to eq("${azurerm_dns_zone.ref_test.name_servers}")
      expect(ref.outputs[:max_number_of_record_sets]).to eq("${azurerm_dns_zone.ref_test.max_number_of_record_sets}")
    end
  end

  # ---------------------------------------------------------------------------
  # DNS A Record edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_dns_a_record' do
    it 'synthesizes with target_resource_id' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_a_record(:with_target, {
          name: "www",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          records: ["10.0.0.1"],
          target_resource_id: "${azurerm_public_ip.test.id}"
        })
      end

      result = synthesizer.synthesis
      record = result[:resource][:azurerm_dns_a_record][:with_target]

      expect(record[:target_resource_id]).to eq("${azurerm_public_ip.test.id}")
      expect(record[:ttl]).to eq(300)
    end

    it 'coerces ttl from string' do
      attrs = Pangea::Resources::Azure::Types::DnsARecordAttributes.new(
        name: 'test',
        zone_name: 'example.com',
        resource_group_name: 'rg-test',
        ttl: '600',
        records: ['10.0.0.1']
      )
      expect(attrs.ttl).to eq(600)
    end
  end

  # ---------------------------------------------------------------------------
  # DNS CNAME Record edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_dns_cname_record' do
    it 'synthesizes with target_resource_id' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_cname_record(:with_target, {
          name: "api",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 3600,
          record: "api.example.net",
          target_resource_id: "${azurerm_cdn_endpoint.test.id}"
        })
      end

      result = synthesizer.synthesis
      record = result[:resource][:azurerm_dns_cname_record][:with_target]

      expect(record[:target_resource_id]).to eq("${azurerm_cdn_endpoint.test.id}")
      expect(record[:record]).to eq("api.example.net")
    end

    it 'provides fqdn in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_cname_record(:ref_test, {
          name: "mail",
          zone_name: "example.com",
          resource_group_name: "rg-test",
          ttl: 300,
          record: "mail.example.net"
        })
      end

      expect(ref.outputs[:fqdn]).to eq("${azurerm_dns_cname_record.ref_test.fqdn}")
    end
  end

  # ---------------------------------------------------------------------------
  # Redis Cache edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_redis_cache' do
    it 'rejects invalid Redis family' do
      expect {
        Pangea::Resources::Azure::Types::RedisCacheAttributes.new(
          name: 'redis-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          capacity: 1,
          family: 'X',
          sku_name: 'Standard'
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with all optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_redis_cache(:full, {
          name: "redis-full",
          resource_group_name: "rg-test",
          location: "eastus",
          capacity: 2,
          family: "P",
          sku_name: "Premium",
          enable_non_ssl_port: false,
          minimum_tls_version: "1.2",
          shard_count: 3,
          tags: { "Cache" => "primary" }
        })
      end

      result = synthesizer.synthesis
      redis = result[:resource][:azurerm_redis_cache][:full]

      expect(redis[:enable_non_ssl_port]).to eq(false)
      expect(redis[:minimum_tls_version]).to eq("1.2")
      expect(redis[:shard_count]).to eq(3)
      expect(redis[:family]).to eq("P")
    end

    it 'provides connection info in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_redis_cache(:ref_test, {
          name: "redis-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          capacity: 0,
          family: "C",
          sku_name: "Basic"
        })
      end

      expect(ref.outputs[:hostname]).to eq("${azurerm_redis_cache.ref_test.hostname}")
      expect(ref.outputs[:ssl_port]).to eq("${azurerm_redis_cache.ref_test.ssl_port}")
      expect(ref.outputs[:port]).to eq("${azurerm_redis_cache.ref_test.port}")
      expect(ref.outputs[:primary_access_key]).to eq("${azurerm_redis_cache.ref_test.primary_access_key}")
      expect(ref.outputs[:primary_connection_string]).to eq("${azurerm_redis_cache.ref_test.primary_connection_string}")
    end
  end

  # ---------------------------------------------------------------------------
  # Service Bus Namespace edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_servicebus_namespace' do
    it 'synthesizes with capacity and zone_redundant' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_servicebus_namespace(:premium, {
          name: "sb-premium",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Premium",
          capacity: 4,
          zone_redundant: true,
          tags: { "Tier" => "premium" }
        })
      end

      result = synthesizer.synthesis
      sb = result[:resource][:azurerm_servicebus_namespace][:premium]

      expect(sb[:capacity]).to eq(4)
      expect(sb[:zone_redundant]).to eq(true)
    end

    it 'provides connection strings in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_servicebus_namespace(:ref_test, {
          name: "sb-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "Standard"
        })
      end

      expect(ref.outputs[:default_primary_connection_string]).to eq("${azurerm_servicebus_namespace.ref_test.default_primary_connection_string}")
      expect(ref.outputs[:default_primary_key]).to eq("${azurerm_servicebus_namespace.ref_test.default_primary_key}")
    end
  end

  # ---------------------------------------------------------------------------
  # CosmosDB Account nested structures
  # ---------------------------------------------------------------------------
  describe 'azurerm_cosmosdb_account' do
    it 'rejects missing consistency_policy' do
      expect {
        Pangea::Resources::Azure::Types::CosmosdbAccountAttributes.new(
          name: 'cosmos-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          offer_type: 'Standard',
          geo_location: [{ location: 'eastus', failover_priority: 0 }]
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'rejects missing geo_location' do
      expect {
        Pangea::Resources::Azure::Types::CosmosdbAccountAttributes.new(
          name: 'cosmos-test',
          resource_group_name: 'rg-test',
          location: 'eastus',
          offer_type: 'Standard',
          consistency_policy: { consistency_level: 'Session' }
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'synthesizes with BoundedStaleness consistency and multi-geo' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_cosmosdb_account(:multi_geo, {
          name: "cosmos-multi",
          resource_group_name: "rg-test",
          location: "eastus",
          offer_type: "Standard",
          kind: "MongoDB",
          consistency_policy: {
            consistency_level: "BoundedStaleness",
            max_interval_in_seconds: 300,
            max_staleness_prefix: 100000
          },
          geo_location: [
            { location: "eastus", failover_priority: 0, zone_redundant: true },
            { location: "westus", failover_priority: 1, zone_redundant: false }
          ],
          enable_automatic_failover: true,
          enable_free_tier: false,
          tags: { "Database" => "cosmos" }
        })
      end

      result = synthesizer.synthesis
      cosmos = result[:resource][:azurerm_cosmosdb_account][:multi_geo]

      expect(cosmos[:kind]).to eq("MongoDB")
      expect(cosmos[:enable_automatic_failover]).to eq(true)
      expect(cosmos[:enable_free_tier]).to eq(false)
    end

    it 'provides connection strings in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_cosmosdb_account(:ref_test, {
          name: "cosmos-ref",
          resource_group_name: "rg-test",
          location: "eastus",
          offer_type: "Standard",
          consistency_policy: { consistency_level: "Eventual" },
          geo_location: [{ location: "eastus", failover_priority: 0 }]
        })
      end

      expect(ref.outputs[:endpoint]).to eq("${azurerm_cosmosdb_account.ref_test.endpoint}")
      expect(ref.outputs[:primary_key]).to eq("${azurerm_cosmosdb_account.ref_test.primary_key}")
      expect(ref.outputs[:connection_strings]).to eq("${azurerm_cosmosdb_account.ref_test.connection_strings}")
    end
  end

  # ---------------------------------------------------------------------------
  # Log Analytics Workspace edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_log_analytics_workspace' do
    it 'synthesizes with all optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_log_analytics_workspace(:full, {
          name: "law-full",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: "PerGB2018",
          retention_in_days: 90,
          daily_quota_gb: 10,
          internet_ingestion_enabled: true,
          internet_query_enabled: false,
          tags: { "Monitoring" => "central" }
        })
      end

      result = synthesizer.synthesis
      law = result[:resource][:azurerm_log_analytics_workspace][:full]

      expect(law[:sku]).to eq("PerGB2018")
      expect(law[:retention_in_days]).to eq(90)
      expect(law[:daily_quota_gb]).to eq(10)
      expect(law[:internet_ingestion_enabled]).to eq(true)
      expect(law[:internet_query_enabled]).to eq(false)
    end

    it 'provides workspace_id and keys in reference outputs' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_log_analytics_workspace(:ref_test, {
          name: "law-ref",
          resource_group_name: "rg-test",
          location: "eastus"
        })
      end

      expect(ref.outputs[:workspace_id]).to eq("${azurerm_log_analytics_workspace.ref_test.workspace_id}")
      expect(ref.outputs[:primary_shared_key]).to eq("${azurerm_log_analytics_workspace.ref_test.primary_shared_key}")
      expect(ref.outputs[:secondary_shared_key]).to eq("${azurerm_log_analytics_workspace.ref_test.secondary_shared_key}")
    end
  end

  # ---------------------------------------------------------------------------
  # Monitor Diagnostic Setting edge cases
  # ---------------------------------------------------------------------------
  describe 'azurerm_monitor_diagnostic_setting' do
    it 'synthesizes with eventhub target' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_monitor_diagnostic_setting(:eventhub, {
          name: "diag-eventhub",
          target_resource_id: "${azurerm_kubernetes_cluster.test.id}",
          eventhub_authorization_rule_id: "${azurerm_eventhub_namespace_authorization_rule.test.id}",
          eventhub_name: "diagnostics"
        })
      end

      result = synthesizer.synthesis
      diag = result[:resource][:azurerm_monitor_diagnostic_setting][:eventhub]

      expect(diag[:eventhub_name]).to eq("diagnostics")
      expect(diag[:eventhub_authorization_rule_id]).to eq("${azurerm_eventhub_namespace_authorization_rule.test.id}")
    end

    it 'synthesizes with storage_account_id' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_monitor_diagnostic_setting(:storage, {
          name: "diag-storage",
          target_resource_id: "${azurerm_key_vault.test.id}",
          storage_account_id: "${azurerm_storage_account.diag.id}"
        })
      end

      result = synthesizer.synthesis
      diag = result[:resource][:azurerm_monitor_diagnostic_setting][:storage]

      expect(diag[:storage_account_id]).to eq("${azurerm_storage_account.diag.id}")
    end

    it 'omits all nil optional fields' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_monitor_diagnostic_setting(:minimal, {
          name: "diag-minimal",
          target_resource_id: "${azurerm_resource_group.test.id}"
        })
      end

      result = synthesizer.synthesis
      diag = result[:resource][:azurerm_monitor_diagnostic_setting][:minimal]

      expect(diag).not_to have_key(:log_analytics_workspace_id)
      expect(diag).not_to have_key(:storage_account_id)
      expect(diag).not_to have_key(:eventhub_authorization_rule_id)
      expect(diag).not_to have_key(:eventhub_name)
    end
  end

  # ---------------------------------------------------------------------------
  # Application Gateway nested structures
  # ---------------------------------------------------------------------------
  describe 'azurerm_application_gateway' do
    it 'rejects invalid App Gateway SKU name' do
      expect {
        Pangea::Resources::Azure::Types::AppGatewaySku.new(
          name: 'Invalid_v3',
          tier: 'Standard_v2',
          capacity: 2
        )
      }.to raise_error(Dry::Struct::Error)
    end

    it 'coerces capacity from string' do
      sku = Pangea::Resources::Azure::Types::AppGatewaySku.new(
        name: 'Standard_v2',
        tier: 'Standard_v2',
        capacity: '3'
      )
      expect(sku.capacity).to eq(3)
    end
  end

  # ---------------------------------------------------------------------------
  # Resource reference type and name tracking
  # ---------------------------------------------------------------------------
  describe 'resource references' do
    it 'tracks resource type for resource group' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_resource_group(:tracked, {
          name: "rg-tracked",
          location: "eastus"
        })
      end

      expect(ref.type).to eq('azurerm_resource_group')
      expect(ref.name).to eq(:tracked)
    end

    it 'tracks resource type for virtual network' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_virtual_network(:tracked, {
          name: "vnet-tracked",
          resource_group_name: "rg-test",
          location: "eastus",
          address_space: ["10.0.0.0/16"]
        })
      end

      expect(ref.type).to eq('azurerm_virtual_network')
      expect(ref.name).to eq(:tracked)
    end

    it 'stores resource_attributes in reference' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_dns_zone(:attrs_test, {
          name: "example.org",
          resource_group_name: "rg-test",
          tags: { "Zone" => "public" }
        })
      end

      expect(ref.resource_attributes[:name]).to eq("example.org")
      expect(ref.resource_attributes[:resource_group_name]).to eq("rg-test")
    end
  end

  # ---------------------------------------------------------------------------
  # String key coercion (transform_keys)
  # ---------------------------------------------------------------------------
  describe 'string key coercion' do
    it 'accepts string keys for resource group' do
      attrs = Pangea::Resources::Azure::Types::ResourceGroupAttributes.new(
        'name' => 'rg-string-keys',
        'location' => 'westus'
      )
      expect(attrs.name).to eq('rg-string-keys')
      expect(attrs.location).to eq('westus')
    end

    it 'accepts string keys for nested structures' do
      attrs = Pangea::Resources::Azure::Types::NetworkInterfaceAttributes.new(
        'name' => 'nic-string',
        'resource_group_name' => 'rg-test',
        'location' => 'eastus',
        'ip_configuration' => {
          'name' => 'internal',
          'subnet_id' => 'subnet-id',
          'private_ip_address_allocation' => 'Dynamic'
        }
      )
      expect(attrs.ip_configuration.name).to eq('internal')
    end
  end
end
