# frozen_string_literal: true

require 'spec_helper'
require 'terraform-synthesizer'
require 'pangea/resources/azurerm_kubernetes_cluster/resource'

RSpec.describe 'azurerm_kubernetes_cluster synthesis' do
  include Pangea::Resources::Azure

  let(:synthesizer) { TerraformSynthesizer.new }

  describe 'terraform synthesis' do
    it 'synthesizes basic kubernetes cluster' do
      synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_kubernetes_cluster(:test, {
          name: "aks-test",
          resource_group_name: "rg-test",
          location: "eastus",
          dns_prefix: "akstest",
          default_node_pool: {
            name: "default",
            vm_size: "Standard_D2_v2",
            node_count: 3
          },
          identity: {
            type: "SystemAssigned"
          }
        })
      end

      result = synthesizer.synthesis
      aks = result[:resource][:azurerm_kubernetes_cluster][:test]

      expect(aks).to include(
        name: "aks-test",
        dns_prefix: "akstest"
      )
    end
  end

  describe 'resource references' do
    it 'provides correct terraform interpolation strings' do
      ref = synthesizer.instance_eval do
        extend Pangea::Resources::Azure
        azurerm_kubernetes_cluster(:test, {
          name: "aks-test",
          resource_group_name: "rg-test",
          location: "eastus",
          dns_prefix: "akstest",
          default_node_pool: {
            name: "default",
            vm_size: "Standard_D2_v2",
            node_count: 3
          }
        })
      end

      expect(ref.id).to eq("${azurerm_kubernetes_cluster.test.id}")
      expect(ref.outputs[:fqdn]).to eq("${azurerm_kubernetes_cluster.test.fqdn}")
      expect(ref.outputs[:kube_config_raw]).to eq("${azurerm_kubernetes_cluster.test.kube_config_raw}")
    end
  end
end
