# frozen_string_literal: true

RSpec.describe Saphyr::Asserts do

  describe 'Module' do
    it 'define ErrorConstants module' do
      expect(Saphyr::Asserts::ErrorConstants.class).to eq Module
    end

    it 'define BaseAssert module' do
      expect(Saphyr::Asserts::BaseAssert.class).to eq Module
    end

    it 'define SizeAssert module' do
      expect(Saphyr::Asserts::SizeAssert.class).to eq Module
    end

    it 'define NumericAssert module' do
      expect(Saphyr::Asserts::NumericAssert.class).to eq Module
    end

    it 'define StringAssert module' do
      expect(Saphyr::Asserts::StringAssert.class).to eq Module
    end
  end
end
