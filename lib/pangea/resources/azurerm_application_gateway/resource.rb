# frozen_string_literal: true

require 'pangea/resources/base'
require 'pangea/resources/reference'
require 'pangea/resources/azurerm_application_gateway/types'
require 'pangea/resource_registry'

module Pangea
  module Resources
    module AzurermApplicationGateway
      def azurerm_application_gateway(name, attributes = {})
        attrs = Azure::Types::ApplicationGatewayAttributes.new(attributes)

        resource(:azurerm_application_gateway, name) do
          self.name attrs.name
          resource_group_name attrs.resource_group_name
          location attrs.location

          sku do
            self.name attrs.sku.name
            tier attrs.sku.tier
            capacity attrs.sku.capacity
          end

          gateway_ip_configuration do
            attrs.gateway_ip_configuration.each { |k, v| public_send(k, v) }
          end

          frontend_ip_configuration do
            attrs.frontend_ip_configuration.each { |k, v| public_send(k, v) }
          end

          frontend_port do
            attrs.frontend_port.each { |k, v| public_send(k, v) }
          end

          backend_address_pool do
            attrs.backend_address_pool.each { |k, v| public_send(k, v) }
          end

          backend_http_settings do
            attrs.backend_http_settings.each { |k, v| public_send(k, v) }
          end

          http_listener do
            attrs.http_listener.each { |k, v| public_send(k, v) }
          end

          request_routing_rule do
            attrs.request_routing_rule.each { |k, v| public_send(k, v) }
          end

          tags attrs.tags if attrs.tags.any?
        end

        ResourceReference.new(
          type: 'azurerm_application_gateway',
          name: name,
          resource_attributes: attrs.to_h,
          outputs: {
            id: "${azurerm_application_gateway.#{name}.id}"
          }
        )
      end
    end

    module Azure
      include AzurermApplicationGateway
    end
  end
end

Pangea::ResourceRegistry.register_module(Pangea::Resources::Azure)
