# frozen_string_literal: true

RSpec.describe Saphyr::Fields::DateTimeField do

  let(:prefix) { 'datetime' }

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

  describe '.initialize' do
    it "accaccept :format optionpt 1 as value" do
      expect(described_class.new({format: '%Y'}).opts[:format]).to eq '%Y'
    end
  end

  describe '#do_validate' do
    subject { described_class.new }

    let(:valid_dates) {
      [
        '2025-06-12T14:08:00',
        '12/06/2025 14:08',
        'Thursday, 12 June 2025 14:08:00',
        '06/12/25 2:08 PM',
        '2025-06-12 14:08:00',
        '2025-06-12T14:08:00.000Z',
        '12-Jun-2025 14:08',
        '2025-06-12T14:08:00+02:00',
        'Thu, 12 Jun 2025 14:08:00 GMT',
        '20250612T140800Z'
      ]
    }

    context 'when valid data' do
      context 'when :format option is not provided' do
        it 'return without error' do
          valid_dates.each do |d|
            errors = subject.send :validate, nil, 'dt', d
            expect(errors.size).to eq 0
          end
        end
      end

      context 'when :format option is provided' do
        subject { described_class.new({format: '%d/%m/%Y %H:%M:%S'}) }

        it 'return without error' do
          errors = subject.send :validate, nil, 'dt', '21/03/2021 10:45:23'
          expect(errors.size).to eq 0
        end
      end
    end

    context 'when invalid data' do
      subject { described_class.new }

      context 'when value is an empty string' do
        it 'return with error' do
          errors = subject.send :validate, nil, 'dt', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end
      end

      context 'when :format is not provided' do
        it 'return with error' do
          errors = subject.send :validate, nil, 'dt', 'not-dt'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-dt'
        end
      end

      context 'when :format is provided' do
        subject { described_class.new({format: '%d/%m/%Y %H:%M:%S'}) }

        it 'return with error' do
          # Valid datetime but not the expected format
          errors = subject.send :validate, nil, 'dt', '12-Jun-2025 14:08'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq '12-Jun-2025 14:08'
        end
      end
    end
  end
end
