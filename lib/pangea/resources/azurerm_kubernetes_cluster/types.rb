# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class AksDefaultNodePool < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :vm_size, Dry::Types['strict.string']
          attribute :node_count, Dry::Types['coercible.integer']
          attribute :min_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :max_count, Dry::Types['coercible.integer'].optional.default(nil)
          attribute :enable_auto_scaling, Dry::Types['strict.bool'].optional.default(nil)
          attribute :os_disk_size_gb, Dry::Types['coercible.integer'].optional.default(nil)
        end

        class AksIdentity < Dry::Struct
          transform_keys(&:to_sym)

          attribute :type, ::Pangea::Resources::Types::AzureIdentityType
        end

        class KubernetesClusterAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :dns_prefix, Dry::Types['strict.string']
          attribute :default_node_pool, AksDefaultNodePool
          attribute :identity, AksIdentity.optional.default(nil)
          attribute :kubernetes_version, Dry::Types['strict.string'].optional.default(nil)
          attribute :sku_tier, Dry::Types['strict.string'].optional.default(nil)
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
