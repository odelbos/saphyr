# frozen_string_literal: true

RSpec.describe Saphyr::Fields::UriField do

  let(:prefix) { 'uri' } 

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
      it 'return without error for email' do
        errors = subject.send :validate, nil, 'uri', 'test@test.com'
        expect(errors.size).to eq 0
      end

      it 'return without error for isbn' do
        errors = subject.send :validate, nil, 'uri', 'urn:isbn:0451450523'
        expect(errors.size).to eq 0
      end

      it 'return without error for url' do
        errors = subject.send :validate, nil, 'uri', 'https://example.com/page.html'
        expect(errors.size).to eq 0
      end
    end

    context 'when valid data' do
      it 'return without error' do
        errors = subject.send :validate, nil, 'uri', 'bad uri'
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq prefix + ':invalid'
        expect(errors.first[:data][:_val]).to eq 'bad uri'
      end
    end
  end
end
