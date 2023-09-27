# frozen_string_literal: true

RSpec.describe Saphyr::Asserts::ErrorConstants do

  context 'Module constants' do
    it 'has the correct value for ERR_NOT_NULLABLE' do
      expect(described_class::ERR_NOT_NULLABLE).to eq 'not-nullable'
    end

    it 'has the correct value for ERR_BAD_FORMAT' do
      expect(described_class::ERR_BAD_FORMAT).to eq 'bad-format'
    end

    it 'has the correct value for ERR_TYPE' do
      expect(described_class::ERR_TYPE).to eq 'type'
    end

    it 'has the correct value for ERR_IN' do
      expect(described_class::ERR_IN).to eq 'in'
    end

    it 'has the correct value for ERR_EQ' do
      expect(described_class::ERR_EQ).to eq 'eq'
    end

    it 'has the correct value for ERR_SIZE_EQ' do
      expect(described_class::ERR_SIZE_EQ).to eq 'size-eq'
    end

    it 'has the correct value for ERR_SIZE_LEN' do
      expect(described_class::ERR_SIZE_LEN).to eq 'size-len'
    end

    it 'has the correct value for ERR_SIZE_MIN' do
      expect(described_class::ERR_SIZE_MIN).to eq 'size-min'
    end

    it 'has the correct value for ERR_SIZE_MAX' do
      expect(described_class::ERR_SIZE_MAX).to eq 'size-max'
    end

    it 'has the correct value for ERR_GT' do
      expect(described_class::ERR_GT).to eq 'gt'
    end

    it 'has the correct value for ERR_GTE' do
      expect(described_class::ERR_GTE).to eq 'gte'
    end

    it 'has the correct value for ERR_LT' do
      expect(described_class::ERR_LT).to eq 'lt'
    end

    it 'has the correct value for ERR_LTE' do
      expect(described_class::ERR_LTE).to eq 'lte'
    end

    it 'has the correct value for ERR_LEN' do
      expect(described_class::ERR_LEN).to eq 'len'
    end

    it 'has the correct value for ERR_MIN' do
      expect(described_class::ERR_MIN).to eq 'min'
    end

    it 'has the correct value for ERR_MAX' do
      expect(described_class::ERR_MAX).to eq 'max'
    end

    it 'has the correct value for ERR_REGEXP' do
      expect(described_class::ERR_REGEXP).to eq 'regexp'
    end
  end
end
