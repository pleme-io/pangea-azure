# frozen_string_literal: true

require 'pangea-core'
require 'terraform-synthesizer'

# Azure types
require_relative 'pangea/resources/types/azure/core'

# Azure resources
require_relative 'pangea/resources/azurerm_resource_group/resource'
require_relative 'pangea/resources/azurerm_virtual_network/resource'
require_relative 'pangea/resources/azurerm_subnet/resource'
require_relative 'pangea/resources/azurerm_network_security_group/resource'
require_relative 'pangea/resources/azurerm_network_security_rule/resource'
require_relative 'pangea/resources/azurerm_public_ip/resource'
require_relative 'pangea/resources/azurerm_network_interface/resource'
require_relative 'pangea/resources/azurerm_linux_virtual_machine/resource'
require_relative 'pangea/resources/azurerm_storage_account/resource'
require_relative 'pangea/resources/azurerm_storage_container/resource'
require_relative 'pangea/resources/azurerm_key_vault/resource'
require_relative 'pangea/resources/azurerm_key_vault_secret/resource'
require_relative 'pangea/resources/azurerm_kubernetes_cluster/resource'
require_relative 'pangea/resources/azurerm_container_registry/resource'
require_relative 'pangea/resources/azurerm_postgresql_flexible_server/resource'
require_relative 'pangea/resources/azurerm_postgresql_flexible_server_database/resource'
require_relative 'pangea/resources/azurerm_dns_zone/resource'
require_relative 'pangea/resources/azurerm_dns_a_record/resource'
require_relative 'pangea/resources/azurerm_dns_cname_record/resource'
require_relative 'pangea/resources/azurerm_application_gateway/resource'
require_relative 'pangea/resources/azurerm_redis_cache/resource'
require_relative 'pangea/resources/azurerm_servicebus_namespace/resource'
require_relative 'pangea/resources/azurerm_cosmosdb_account/resource'
require_relative 'pangea/resources/azurerm_log_analytics_workspace/resource'
require_relative 'pangea/resources/azurerm_monitor_diagnostic_setting/resource'

# Azure module aggregator
require_relative 'pangea/resources/azure'
