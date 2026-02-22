# frozen_string_literal: true

require 'dry-struct'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Azure
      module Types
        class AppGatewaySku < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, ::Pangea::Resources::Types::AzureAppGatewaySkuName
          attribute :tier, ::Pangea::Resources::Types::AzureAppGatewaySkuTier
          attribute :capacity, Dry::Types['coercible.integer']
        end

        class ApplicationGatewayAttributes < Dry::Struct
          transform_keys(&:to_sym)

          attribute :name, Dry::Types['strict.string']
          attribute :resource_group_name, Dry::Types['strict.string']
          attribute :location, ::Pangea::Resources::Types::AzureLocation
          attribute :sku, AppGatewaySku
          attribute :gateway_ip_configuration, Dry::Types['nominal.hash']
          attribute :frontend_ip_configuration, Dry::Types['nominal.hash']
          attribute :frontend_port, Dry::Types['nominal.hash']
          attribute :backend_address_pool, Dry::Types['nominal.hash']
          attribute :backend_http_settings, Dry::Types['nominal.hash']
          attribute :http_listener, Dry::Types['nominal.hash']
          attribute :request_routing_rule, Dry::Types['nominal.hash']
          attribute :tags, ::Pangea::Resources::Types::AzureTags
        end
      end
    end
  end
end
