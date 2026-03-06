# pangea-azure

Azure provider bindings for the Pangea infrastructure DSL.

## Overview

Provides 25 typed Terraform resource functions for Azure, covering resource groups,
virtual networks, VMs, storage, Key Vault, AKS, PostgreSQL, DNS, and monitoring.
Each resource uses Dry::Struct validation and compiles to Terraform JSON via
terraform-synthesizer. Built on pangea-core.

## Installation

```ruby
gem 'pangea-azure', '~> 0.1'
```

## Usage

```ruby
require 'pangea-azure'

template :my_infra do
  provider :azurerm do
    features {}
  end

  rg = azurerm_resource_group(:main, { name: "my-rg", location: "eastus" })
  azurerm_virtual_network(:vnet, { name: "my-vnet", resource_group_name: rg.ref(:name), address_space: ["10.0.0.0/16"], location: "eastus" })
end
```

## Development

```bash
nix develop
bundle exec rspec
```

## License

Apache-2.0
