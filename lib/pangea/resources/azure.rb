# frozen_string_literal: true

module Pangea
  module Resources
    # Aggregator module that includes all Azure resource modules.
    # Each resource file reopens this module and includes itself,
    # so by the time this file is loaded all resource modules are
    # already mixed in. This file exists as a single entry point
    # for consumers who want `include Pangea::Resources::Azure`.
    module Azure
      include AzurermResourceGroup
      include AzurermVirtualNetwork
      include AzurermSubnet
      include AzurermNetworkSecurityGroup
      include AzurermNetworkSecurityRule
      include AzurermPublicIp
      include AzurermNetworkInterface
      include AzurermLinuxVirtualMachine
      include AzurermStorageAccount
      include AzurermStorageContainer
      include AzurermKeyVault
      include AzurermKeyVaultSecret
      include AzurermKubernetesCluster
      include AzurermContainerRegistry
      include AzurermPostgresqlFlexibleServer
      include AzurermPostgresqlFlexibleServerDatabase
      include AzurermDnsZone
      include AzurermDnsARecord
      include AzurermDnsCnameRecord
      include AzurermApplicationGateway
      include AzurermRedisCache
      include AzurermServicebusNamespace
      include AzurermCosmosdbAccount
      include AzurermLogAnalyticsWorkspace
      include AzurermMonitorDiagnosticSetting
    end
  end
end
