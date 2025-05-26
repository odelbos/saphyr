# frozen_string_literal: true

RSpec.describe Saphyr::Fields::EmailField do

  let(:prefix) { 'email' } 

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq prefix
    end

    it 'must have EXPECTED_TYPES equals to String' do
      subject { described_class }
      expect(subject.class.const_get(:EXPECTED_TYPES)).to eq String
    end

  end

  describe '#do_validate' do
    subject { described_class.new }

    context 'when valid data' do
      it 'return without error' do
        errors = subject.send :validate, nil, 'email', 'test@test.com'
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return with error' do
        errors = subject.send :validate, nil, 'email', 'bad email'
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq prefix + ':invalid'
        expect(errors.first[:data][:_val]).to eq 'bad email'
      end
    end
  end
end
