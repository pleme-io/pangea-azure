# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_application_gateway/resource'

RSpec.describe 'azurerm_application_gateway synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic application gateway' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_application_gateway(:test, {
          name: "appgw-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: {
            name: "Standard_v2",
            tier: "Standard_v2",
            capacity: 2
          },
          gateway_ip_configuration: {
            name: "gateway-ip-config",
            subnet_id: "${azurerm_subnet.test.id}"
          },
          frontend_ip_configuration: {
            name: "frontend-ip-config",
            public_ip_address_id: "${azurerm_public_ip.test.id}"
          },
          frontend_port: {
            name: "frontend-port",
            port: 80
          },
          backend_address_pool: {
            name: "backend-pool"
          },
          backend_http_settings: {
            name: "http-settings",
            cookie_based_affinity: "Disabled",
            port: 80,
            protocol: "Http"
          },
          http_listener: {
            name: "http-listener",
            frontend_ip_configuration_name: "frontend-ip-config",
            frontend_port_name: "frontend-port",
            protocol: "Http"
          },
          request_routing_rule: {
            name: "routing-rule",
            rule_type: "Basic",
            http_listener_name: "http-listener",
            backend_address_pool_name: "backend-pool",
            backend_http_settings_name: "http-settings",
            priority: 1
          }
        })
      end

      result = synthesizer.synthesis
      appgw = result[:resource][:azurerm_application_gateway][:test]

      expect(appgw).to include(
        name: "appgw-test"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_application_gateway(:test, {
          name: "appgw-test",
          resource_group_name: "rg-test",
          location: "eastus",
          sku: {
            name: "Standard_v2",
            tier: "Standard_v2",
            capacity: 2
          },
          gateway_ip_configuration: { name: "gw-ip" },
          frontend_ip_configuration: { name: "fe-ip" },
          frontend_port: { name: "fe-port", port: 80 },
          backend_address_pool: { name: "be-pool" },
          backend_http_settings: { name: "be-http" },
          http_listener: { name: "listener" },
          request_routing_rule: { name: "rule" }
        })
      end

      expect(ref.id).to eq("${azurerm_application_gateway.test.id}")
    end
  end
end
