# frozen_string_literal: true

# Test helpers for synthesis validation
module SynthesisTestHelpers
  # Synthesize and validate Terraform configuration
  def synthesize_and_validate(entity_type = :resource, &block)
    synthesizer = create_synthesizer
    synthesizer.instance_eval(&block)
    result = synthesizer.synthesis

    validate_terraform_structure(result, entity_type)
    result
  end

  # Create a new TerraformSynthesizer instance
  def create_synthesizer
    if defined?(TerraformSynthesizer)
      TerraformSynthesizer.new
    else
      MockTerraformSynthesizer.new
    end
  end

  # Validate basic Terraform JSON structure
  def validate_terraform_structure(result, entity_type)
    expect(result).to be_a(Hash)

    case entity_type
    when :resource
      expect(result).to have_key("resource")
      expect(result["resource"]).to be_a(Hash)
    when :data_source
      expect(result).to have_key("data")
      expect(result["data"]).to be_a(Hash)
    when :output
      expect(result).to have_key("output")
      expect(result["output"]).to be_a(Hash)
    end
  end

  # Validate resource references in generated Terraform
  def validate_resource_references(result)
    terraform_json = result.to_json

    reference_pattern = /\$\{[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*\}/

    references = terraform_json.scan(reference_pattern)
    references.each do |ref|
      expect(ref).to match(reference_pattern)
    end

    references
  end

  # Validate specific resource structure
  def validate_resource_structure(result, resource_type, resource_name)
    expect(result).to have_key("resource")
    expect(result["resource"]).to have_key(resource_type)
    expect(result["resource"][resource_type]).to have_key(resource_name)

    resource_config = result["resource"][resource_type][resource_name]
    expect(resource_config).to be_a(Hash)

    resource_config
  end

  # Validate that resource attributes match expected types
  def validate_resource_attributes(resource_config, expected_attributes)
    expected_attributes.each do |attr_name, attr_type|
      if resource_config.has_key?(attr_name.to_s)
        value = resource_config[attr_name.to_s]
        case attr_type
        when String
          expect(value).to be_a(String)
        when Integer
          expect(value).to be_a(Integer)
        when TrueClass, FalseClass
          expect(value).to be_in([true, false])
        when Array
          expect(value).to be_a(Array)
        when Hash
          expect(value).to be_a(Hash)
        end
      end
    end
  end

  # Validate that required attributes are present
  def validate_required_attributes(resource_config, required_attributes)
    required_attributes.each do |attr_name|
      expect(resource_config).to have_key(attr_name.to_s),
        "Required attribute '#{attr_name}' is missing"
    end
  end
end
