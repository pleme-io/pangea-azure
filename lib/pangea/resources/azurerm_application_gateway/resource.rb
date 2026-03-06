# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_application_gateway/types'
require 'pangea/resource_registry'

module Pangea::Resources
  module AzurermApplicationGateway
    include Pangea::Resources::ResourceBuilder

    define_resource :azurerm_application_gateway,
      attributes_class: Azure::Types::ApplicationGatewayAttributes,
      outputs: { id: :id },
      map: [:name, :resource_group_name, :location],
      tags: :tags do |r, attrs|
        r.sku do
          r.__send__(:name, attrs.sku.name)
          r.tier attrs.sku.tier
          r.capacity attrs.sku.capacity
        end

        r.gateway_ip_configuration do
          attrs.gateway_ip_configuration.each { |k, v| r.public_send(k, v) }
        end

        r.frontend_ip_configuration do
          attrs.frontend_ip_configuration.each { |k, v| r.public_send(k, v) }
        end

        r.frontend_port do
          attrs.frontend_port.each { |k, v| r.public_send(k, v) }
        end

        r.backend_address_pool do
          attrs.backend_address_pool.each { |k, v| r.public_send(k, v) }
        end

        r.backend_http_settings do
          attrs.backend_http_settings.each { |k, v| r.public_send(k, v) }
        end

        r.http_listener do
          attrs.http_listener.each { |k, v| r.public_send(k, v) }
        end

        r.request_routing_rule do
          attrs.request_routing_rule.each { |k, v| r.public_send(k, v) }
        end
      end
  end
  module Azure
    include AzurermApplicationGateway
  end
end
Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
