# frozen_string_literal: true

RSpec.describe Saphyr::Fields::IsoCountryField do

  let(:prefix) { 'iso-country' }

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
    context "when :alpha option is not provided" do
      subject { described_class.new }
      it "default :alpha must be equals to 2" do
        expect(subject.opts[:alpha]).to eq 2
      end
    end

    context 'when :alpha option is provided and valid' do
      it "accept 2 as value" do
        expect(described_class.new({alpha: 2}).opts[:alpha]).to eq 2
      end

      it "accept 3 as value" do
        expect(described_class.new({alpha: 3}).opts[:alpha]).to eq 3
      end
    end

    context 'when :alpha option is not valid' do
      it "raises an error if value is not equals to 2 or 3" do
        expect { described_class.new({strict: 'bad'}) }.to raise_error(Saphyr::Error)
      end
    end
  end

  describe '#do_validate' do
    subject { described_class.new }

    context 'when valid data' do
      context 'when :alpha option equals to 2 (default)' do
        it 'return without error' do
          errors = subject.send :validate, nil, 'country', 'FR'
          expect(errors.size).to eq 0
        end
      end

      context 'when :alpha option is set to 2' do
        subject { described_class.new({alpha: 2}) }
        it 'return without error' do
          errors = subject.send :validate, nil, 'country', 'BE'
          expect(errors.size).to eq 0
        end
      end

      context 'when :alpha option is set to 3' do
        subject { described_class.new({alpha: 3}) }
        it 'return without error' do
          errors = subject.send :validate, nil, 'country', 'BRA'
          expect(errors.size).to eq 0
        end
      end
    end

    context 'when invalid data' do
      subject { described_class.new }

      context 'when :alpha option equals to 2 (default)' do
        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'country', 'not-country'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-country'
        end
      end

      context 'when :alpha option is set to 2' do
        subject { described_class.new({alpha: 2}) }
        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'country', 'not-country'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-country'
        end
      end

      context 'when :alpha option is set to 3' do
        subject { described_class.new({alpha: 3}) }
        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'country', 'not-country'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-country'
        end
      end

      context 'when :alpha option is set to 2 and value is alpha-3' do
        subject { described_class.new({alpha: 2}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'country', 'FRA'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'FRA'
        end
      end

      context 'when :alpha option is set to 3 and value is alpha-2' do
        subject { described_class.new({alpha: 3}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'country', 'BE'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'BE'
        end
      end
    end
  end
end
