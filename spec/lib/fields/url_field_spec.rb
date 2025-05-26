# frozen_string_literal: true

RSpec.describe Saphyr::Fields::UrlField do

  let(:prefix) { 'url' } 

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
      it 'return without error for http url' do
        errors = subject.send :validate, nil, 'url', 'http://test.com/page.html'
        p errors
        expect(errors.size).to eq 0
      end

      it 'return without error for https url' do
        errors = subject.send :validate, nil, 'url', 'https://www.test.com/?p=1'
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return with error' do
        errors = subject.send :validate, nil, 'url', 'bad url'
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq prefix + ':invalid'
        expect(errors.first[:data][:_val]).to eq 'bad url'
      end

      it 'return with error' do
        errors = subject.send :validate, nil, 'url', 'urn:isbn:0451450523'
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq prefix + ':invalid'
        expect(errors.first[:data][:_val]).to eq 'urn:isbn:0451450523'
      end
    end
  end
end
