# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_linux_virtual_machine/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermLinuxVirtualMachine
      def azurerm_linux_virtual_machine(name, attributes = {})
        attrs = Azure::Types::LinuxVirtualMachineAttributes.new(attributes)

        resource(:azurerm_linux_virtual_machine, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location
          size attrs.size
          admin_username attrs.admin_username
          admin_password attrs.admin_password if attrs.admin_password
          disable_password_authentication attrs.disable_password_authentication unless attrs.disable_password_authentication.nil?
          network_interface_ids attrs.network_interface_ids

          os_disk do
            caching attrs.os_disk.caching
            storage_account_type attrs.os_disk.storage_account_type
            disk_size_gb attrs.os_disk.disk_size_gb if attrs.os_disk.disk_size_gb
          end

          if attrs.source_image_reference
            source_image_reference do
              publisher attrs.source_image_reference.publisher
              offer attrs.source_image_reference.offer
              sku attrs.source_image_reference.sku
              version attrs.source_image_reference.version
            end
          end

          custom_data attrs.custom_data if attrs.custom_data
          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_linux_virtual_machine',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_linux_virtual_machine.#{name}.id}",
            private_ip_address: "${azurerm_linux_virtual_machine.#{name}.private_ip_address}",
            public_ip_address: "${azurerm_linux_virtual_machine.#{name}.public_ip_address}"
          }
        )
      end
    end

    module Azure
      include AzurermLinuxVirtualMachine
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
