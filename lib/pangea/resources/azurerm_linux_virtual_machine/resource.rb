# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_linux_virtual_machine/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermLinuxVirtualMachine
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_linux_virtual_machine,
      attributes_class: Azure::Types::LinuxVirtualMachineAttributes,
      outputs: { id: :id, private_ip_address: :private_ip_address, public_ip_address: :public_ip_address },
      map: [:name, :resource_group_name, :location, :size, :admin_username, :network_interface_ids],
      map_present: [:admin_password, :custom_data],
      map_bool: [:disable_password_authentication],
      tags: :tags do |r, attrs|
        r.os_disk do
          r.caching attrs.os_disk.caching
          r.storage_account_type attrs.os_disk.storage_account_type
          r.disk_size_gb attrs.os_disk.disk_size_gb if attrs.os_disk.disk_size_gb
        end

        if attrs.source_image_reference
          r.source_image_reference do
            r.publisher attrs.source_image_reference.publisher
            r.offer attrs.source_image_reference.offer
            r.sku attrs.source_image_reference.sku
            r.version attrs.source_image_reference.version
          end
        end
      end
  end
  module Azure
    include AzurermLinuxVirtualMachine
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
