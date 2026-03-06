# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_security_rule/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermNetworkSecurityRule
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_network_security_rule,
      attributes_class: Azure::Types::NetworkSecurityRuleAttributes,
      outputs: { id: :id },
      map: [:name, :resource_group_name, :network_security_group_name, :priority, :direction, :access, :protocol],
      map_present: [:source_port_range, :destination_port_range, :source_address_prefix, :destination_address_prefix,
                    :source_port_ranges, :destination_port_ranges, :source_address_prefixes, :destination_address_prefixes,
                    :description]
  end
  module Azure
    include AzurermNetworkSecurityRule
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
