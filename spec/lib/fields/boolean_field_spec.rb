# frozen_string_literal: true

RSpec.describe Saphyr::Fields::BooleanField do

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq 'boolean'
    end
  end

  describe '.initialize' do
    let(:authorized_opts) { [:eq] }

    context 'authorized options' do
      it 'accept any valid options' do
        authorized_opts.each do |opt|
          field = described_class.new({ opt => 1 })
          expect(field).to be_a Saphyr::Fields::BooleanField
          expect(field.opts[opt]).to eq 1
        end
      end

      it 'raise an exception for invalid option' do
        expect { described_class.new({ err: 1 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :eq is used then cannot use any other options' do
      it 'raise an exception for invalid option' do
        authorized_opts.each do |opt|
          next if opt == :eq
          expect { described_class.new({ eq: true, opt => false }) }.to raise_error Saphyr::Error
        end
      end
    end
  end

  describe '#do_validate' do

    let (:assert_prefix) { 'boolean' }
    let(:errors) { [] }
    subject { described_class.new }

    context 'when valid data' do
      it 'return without error' do
        subject.send :do_validate, nil, true, true, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        subject.send :do_validate, nil, true, 'err', errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':type'
        expect(errors.first[:data][:type]).to eq [TrueClass, FalseClass].to_s
        expect(errors.first[:data][:got]).to eq 'String'
      end
    end
  end
end
