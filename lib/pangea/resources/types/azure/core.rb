# frozen_string_literal: true

require 'pangea/resources/types/core'

module Pangea
  module Resources
    module Types
      # Azure Subscription ID validation (UUID format)
      # Accepts both valid UUIDs and Terraform interpolation strings
      AzureSubscriptionId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        unless value.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          raise Dry::Types::ConstraintError, "Azure Subscription ID must be a valid UUID or a Terraform interpolation string"
        end
        value
      }

      # Azure Resource Group Name (1-90 chars, alphanumeric, hyphens, underscores, periods, parentheses)
      AzureResourceGroupName = String.constrained(
        format: /\A[a-zA-Z0-9._\-()]{1,90}\z/
      )

      # Azure Location (common Azure regions)
      AzureLocation = String.enum(
        'eastus', 'eastus2', 'westus', 'westus2', 'westus3',
        'centralus', 'northcentralus', 'southcentralus', 'westcentralus',
        'canadacentral', 'canadaeast',
        'brazilsouth', 'brazilsoutheast',
        'northeurope', 'westeurope', 'uksouth', 'ukwest',
        'francecentral', 'francesouth',
        'germanywestcentral', 'germanynorth',
        'norwayeast', 'norwaywest',
        'swedencentral', 'swedensouth',
        'switzerlandnorth', 'switzerlandwest',
        'southeastasia', 'eastasia',
        'australiaeast', 'australiasoutheast', 'australiacentral',
        'japaneast', 'japanwest',
        'koreacentral', 'koreasouth',
        'centralindia', 'southindia', 'westindia',
        'uaenorth', 'uaecentral',
        'southafricanorth', 'southafricawest'
      )

      # Azure SKU tiers
      AzureSku = String.enum('Free', 'Basic', 'Standard', 'Premium')

      # Azure Tags (Hash of String => String)
      AzureTags = Hash.map(String, String).default({}.freeze)

      # Azure resource IDs (accept strings and Terraform interpolation)
      AzureSubnetId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        next value if value.match?(/\A\/subscriptions\//)
        value
      }

      AzureVnetId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        next value if value.match?(/\A\/subscriptions\//)
        value
      }

      # Azure Tenant ID (UUID format)
      AzureTenantId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        unless value.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          raise Dry::Types::ConstraintError, "Azure Tenant ID must be a valid UUID or a Terraform interpolation string"
        end
        value
      }

      # Azure generic resource ID (accepts Terraform interpolation or Azure resource paths)
      AzureResourceId = String.constructor { |value|
        next value if value.match?(/\A\$\{.+\}\z/)
        next value if value.match?(/\A\/subscriptions\//)
        value
      }

      # Azure IP allocation method
      AzureAllocationMethod = String.enum('Static', 'Dynamic')

      # Azure IP SKU
      AzureIpSku = String.enum('Basic', 'Standard')

      # Azure storage account tier
      AzureAccountTier = String.enum('Standard', 'Premium')

      # Azure storage replication type
      AzureAccountReplicationType = String.enum('LRS', 'GRS', 'ZRS', 'RAGRS', 'GZRS', 'RAGZRS')

      # Azure storage container access type
      AzureContainerAccessType = String.enum('private', 'blob', 'container')

      # Azure Key Vault SKU
      AzureKeyVaultSku = String.enum('standard', 'premium')

      # Azure Container Registry SKU
      AzureContainerRegistrySku = String.enum('Basic', 'Standard', 'Premium')

      # Azure network protocol
      AzureNetworkProtocol = String.enum('Tcp', 'Udp', 'Icmp', '*')

      # Azure network access
      AzureNetworkAccess = String.enum('Allow', 'Deny')

      # Azure network direction
      AzureNetworkDirection = String.enum('Inbound', 'Outbound')

      # Azure OS disk caching
      AzureOsDiskCaching = String.enum('None', 'ReadOnly', 'ReadWrite')

      # Azure storage account type for managed disks
      AzureManagedDiskType = String.enum('Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS', 'UltraSSD_LRS')

      # Azure identity type
      AzureIdentityType = String.enum('SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned')

      # Azure Log Analytics SKU
      AzureLogAnalyticsSku = String.enum('Free', 'PerNode', 'Premium', 'Standard', 'Standalone', 'Unlimited', 'CapacityReservation', 'PerGB2018')

      # Azure Service Bus SKU
      AzureServiceBusSku = String.enum('Basic', 'Standard', 'Premium')

      # Azure Redis SKU
      AzureRedisSku = String.enum('Basic', 'Standard', 'Premium')

      # Azure Redis family
      AzureRedisFamily = String.enum('C', 'P')

      # Azure CosmosDB offer type
      AzureCosmosDbOfferType = String.enum('Standard')

      # Azure CosmosDB kind
      AzureCosmosDbKind = String.enum('GlobalDocumentDB', 'MongoDB', 'Parse')

      # Azure CosmosDB consistency level
      AzureCosmosDbConsistencyLevel = String.enum('BoundedStaleness', 'ConsistentPrefix', 'Eventual', 'Session', 'Strong')

      # Azure Application Gateway SKU name
      AzureAppGatewaySkuName = String.enum('Standard_Small', 'Standard_Medium', 'Standard_Large', 'Standard_v2', 'WAF_Medium', 'WAF_Large', 'WAF_v2')

      # Azure Application Gateway SKU tier
      AzureAppGatewaySkuTier = String.enum('Standard', 'Standard_v2', 'WAF', 'WAF_v2')
    end
  end
end
