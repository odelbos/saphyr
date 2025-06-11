# frozen_string_literal: true

RSpec.describe Saphyr::Fields::IsoLangField do

  let(:prefix) { 'iso-lang' }

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
    context "when :version option is not provided" do
      subject { described_class.new }
      it "default :version must be equals to 1" do
        expect(subject.opts[:version]).to eq 1
      end
    end

    context 'when :version option is provided and valid' do
      it "accept 1 as value" do
        expect(described_class.new({version: 1}).opts[:version]).to eq 1
      end

      it "accept 2 as value" do
        expect(described_class.new({version: 2}).opts[:version]).to eq 2
      end
    end

    context 'when :version option is not valid' do
      it "raises an error if value is not equals to 1 or 2" do
        expect { described_class.new({strict: 'bad'}) }.to raise_error(Saphyr::Error)
      end
    end
  end

  describe '#do_validate' do
    subject { described_class.new }

    context 'when valid data' do
      context 'when :version option equals to 1 (default)' do
        it 'return without error' do
          errors = subject.send :validate, nil, 'lang', 'kg'
          expect(errors.size).to eq 0
        end
      end

      context 'when :version option is set to 1' do
        subject { described_class.new({version: 1}) }
        it 'return without error' do
          errors = subject.send :validate, nil, 'lang', 'ro'
          expect(errors.size).to eq 0
        end
      end

      context 'when :version option is set to 2' do
        subject { described_class.new({version: 2}) }
        it 'return without error' do
          errors = subject.send :validate, nil, 'lang', 'aus'
          expect(errors.size).to eq 0
        end
      end
    end

    context 'when invalid data' do
      subject { described_class.new }

      context 'when value is an empty string' do
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq ''
        end
      end

      context 'when :version option equals to 1 (default)' do
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', 'not-lang'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-lang'
        end
      end

      context 'when :version option is set to 1' do
        subject { described_class.new({version: 1}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', 'not-lang'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-lang'
        end
      end

      context 'when :version option is set to 2' do
        subject { described_class.new({version: 2}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', 'not-lang'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-lang'
        end
      end

      context 'when :version option is set to 1 and value is version 2' do
        subject { described_class.new({version: 1}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', 'aus'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'aus'
        end
      end

      context 'when :version option is set to 2 and value is version 1' do
        subject { described_class.new({version: 2}) }
        it 'return with error' do
          errors = subject.send :validate, nil, 'lang', 'kg'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'kg'
        end
      end
    end
  end
end
