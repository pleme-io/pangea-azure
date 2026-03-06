# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_network_interface/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermNetworkInterface
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_network_interface,
      attributes_class: Azure::Types::NetworkInterfaceAttributes,
      outputs: { id: :id, private_ip_address: :private_ip_address, mac_address: :mac_address },
      map: [:name, :resource_group_name, :location],
      tags: :tags do |r, attrs|
        r.ip_configuration do
          r.__send__(:name, attrs.ip_configuration.name)
          r.subnet_id attrs.ip_configuration.subnet_id
          r.private_ip_address_allocation attrs.ip_configuration.private_ip_address_allocation
          r.private_ip_address attrs.ip_configuration.private_ip_address if attrs.ip_configuration.private_ip_address
          r.public_ip_address_id attrs.ip_configuration.public_ip_address_id if attrs.ip_configuration.public_ip_address_id
        end
      end
  end
  module Azure
    include AzurermNetworkInterface
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
