# frozen_string_literal: true

RSpec.describe Saphyr::Fields::SchemaField do

  describe 'class' do
    subject { described_class }

    it 'must have a prefix' do
      expect(subject.const_get(:PREFIX)).to eq 'schema'
    end
  end

  describe '.initialize' do
    let(:authorized_opts) { [:name] }

    context 'authorized options' do
      it 'accept any valid options' do
        authorized_opts.each do |opt|
          field = described_class.new({ name: 'ok' })
          expect(field).to be_a Saphyr::Fields::SchemaField
          expect(field.opts[opt]).to eq 'ok'
        end
      end

      it 'raise an exception for invalid option' do
        expect { described_class.new({ err: 1 }) }.to raise_error Saphyr::Error
      end
    end
  end

  describe '#do_validate' do
    let(:validator) { SaphyrTest::SchemaValidator.new }

    let(:valid_data) {
      { "upload" => { "name" => 'ok' }, }
    }

    let(:invalid_data) {
      { "upload" => { "name" => 1 }, }
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
