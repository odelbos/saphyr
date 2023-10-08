# frozen_string_literal: true

RSpec.describe Saphyr::Fields::ArrayField do


  describe 'class' do
    subject { described_class }

    it 'must have a prefix' do
      expect(subject.const_get(:PREFIX)).to eq 'array'
    end
  end

  describe '.initialize' do
    let(:authorized_opts) { [:len, :min, :max, :of_type, :of_schema, :opts] }

    context 'authorized options' do
      let (:test_opts) { authorized_opts - [:of_type, :of_schema] }

      it 'accept any valid options with :of_type' do
        test_opts.each do |opt|
          field = described_class.new({ opt => 1, of_type: :t })
          expect(field).to be_a Saphyr::Fields::ArrayField
          expect(field.opts[opt]).to eq 1
        end
      end

      it 'accept any valid options with :of_schema' do
        test_opts.each do |opt|
          next if opt = :opts              # Can't use :opts with :of_schema
          field = described_class.new({ opt => 1, of_schema: :s })
          expect(field).to be_a Saphyr::Fields::ArrayField
          expect(field.opts[opt]).to eq 1
        end
      end

      it 'raise an exception for invalid option' do
        expect { described_class.new({ err: 1, of_type: :t }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :len is used then cannot use : min, max options' do
      it 'raise an exception for invalid option' do
        [:min, :max].each do |opt|
          expect { described_class.new({ len: 1, opt => 2, of_type: :t }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when :min > :max' do
      it 'raise an exception' do
        expect { described_class.new({ min: 5, max: 3, of_type: :t }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :min = :max' do
      it 'raise an exception' do
        expect { described_class.new({ min: 5, max: 5, of_type: :t }) }.to raise_error Saphyr::Error
      end
    end

    context 'must provide array element type' do
      context 'when type is provided' do
        it 'create an array field with :of_type' do
          expect(described_class.new({ of_type: :t })).to be_a Saphyr::Fields::ArrayField
        end
        it 'create an array field with :of_schame' do
          expect(described_class.new({ of_schema: :s })).to be_a Saphyr::Fields::ArrayField
        end
      end

      context 'when type is not provided' do
        it 'raise an exception' do
          expect { described_class.new({}) }.to raise_error Saphyr::Error
        end
      end

      context 'when both type is provided' do
        it 'raise an exception' do
          expect { described_class.new({of_type: :t, of_schema: :s}) }.to raise_error Saphyr::Error
        end
      end
    end
  end

  describe '#do_validate' do
    let(:validator) { SaphyrTest::ArrayValidator.new }

    let(:valid_data) {
      { "type" => [1, 2, 3], }
    }

    let(:invalid_data) {
      { "type" => ['err', 'bad', 'bug'], }
    }

    context 'with valid data' do
      it 'return true' do
        expect(validator.validate valid_data).to be true
      end
    end

    context 'with invalid data' do
      it 'return false' do
        expect(validator.validate invalid_data).to be false
      end
    end
  end
end
