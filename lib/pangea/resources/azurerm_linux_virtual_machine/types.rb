# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class LinuxVmOsDisk < Dry::Struct
          transform_keys(&:to_sym)

          attribute :caching, ::Pangea::Resources::Types::AzureOsDiskCaching
          attribute :storage_account_type, ::Pangea::Resources::Types::AzureManagedDiskType
          attribute :disk_size_gb, Dry::Types['coercible.integer'].optional.default(nil)
        end

        class LinuxVmSourceImageReference < Dry::Struct
          transform_keys(&:to_sym)

          attribute :publisher, Dry::Types['strict.string']
          attribute :offer, Dry::Types['strict.string']
          attribute :sku, Dry::Types['strict.string']
          attribute :version, Dry::Types['strict.string']
        end

        class LinuxVirtualMachineAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :size, Dry::Types['strict.string']
          attribute :admin_username, Dry::Types['strict.string']
          attribute :admin_password, Dry::Types['strict.string'].optional.default(nil)
          attribute :disable_password_authentication, Dry::Types['strict.bool'].optional.default(nil)
          attribute :network_interface_ids, Dry::Types['strict.array'].of(Dry::Types['strict.string'])
          attribute :os_disk, LinuxVmOsDisk
          attribute :source_image_reference, LinuxVmSourceImageReference.optional.default(nil)
          attribute :custom_data, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
