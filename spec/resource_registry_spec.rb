# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Pangea::ResourceRegistry' do
  describe 'Azure module registration' do
    it 'has registered the Azure module' do
      expect(Pangea::ResourceRegistry.registered?(Pangea::Resources::Azure)).to be true
    end

    it 'includes Azure module in registered_modules list' do
      expect(Pangea::ResourceRegistry.registered_modules).to include(Pangea::Resources::Azure)
    end
  end

  describe 'registry stats' do
    it 'reports at least one registered module' do
      stats = Pangea::ResourceRegistry.stats
      expect(stats[:total_modules]).to be >= 1
    end
  end
end
