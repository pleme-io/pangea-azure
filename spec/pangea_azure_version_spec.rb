# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PangeaAzure do
  describe 'VERSION' do
    it 'is defined' do
      expect(PangeaAzure::VERSION).not_to be_nil
    end

    it 'is a frozen string' do
      expect(PangeaAzure::VERSION).to be_frozen
    end

    it 'follows semantic versioning format' do
      expect(PangeaAzure::VERSION).to match(/\A\d+\.\d+\.\d+(\.\w+)?\z/)
    end

    it 'matches the gemspec version' do
      gemspec_path = File.expand_path('../pangea-azure.gemspec', __dir__)
      gemspec = Gem::Specification.load(gemspec_path)
      expect(PangeaAzure::VERSION).to eq(gemspec.version.to_s)
    end
  end
end
