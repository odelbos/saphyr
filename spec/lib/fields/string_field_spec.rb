# frozen_string_literal: true

RSpec.describe Saphyr::Fields::StringField do

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq 'string'
    end
  end

  describe '.initialize' do
    let(:authorized_opts) { [:eq, :len, :min, :max, :in, :regexp] }

    context 'authorized options' do
      it 'accept any valid options' do
        authorized_opts.each do |opt|
          field = described_class.new({ opt => 1 })
          expect(field).to be_a Saphyr::Fields::StringField
          expect(field.opts[opt]).to eq 1
        end
      end

      it 'raise an exception for invalid option' do
        expect { described_class.new({ err: 1 }) }.to raise_error Saphyr::Error
      end
    end

    context 'if use :eq then cannot use any other options' do
      it 'raise an exception for invalid option' do
        authorized_opts.each do |opt|
          next if opt == :eq
          expect { described_class.new({ eq: 1, opt => 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'if use :in then cannot use any other options' do
      it 'raise an exception for invalid option' do
        authorized_opts.each do |opt|
          next if opt == :in
          expect { described_class.new({ in: [], opt => 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'if use :len then cannot use :eq, :min, :max, :in options' do
      it 'raise an exception for invalid option' do
        [:eq, :min, :max, :in].each do |opt|
          expect { described_class.new({ len: 1, opt => 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when :min > :max' do
      it 'raise an exception' do
        expect { described_class.new({ min: 5, max: 3 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :min = :max' do
      it 'raise an exception' do
        expect { described_class.new({ min: 5, max: 5 }) }.to raise_error Saphyr::Error
      end
    end
  end

  describe '#do_validate' do
    let (:assert_prefix) { 'string' }
    let(:errors) { [] }
    subject { described_class.new }

    context 'assert base class' do
      let (:assert_value) { 'ok' }
      let (:assert_err_value) { 3 }
      it_behaves_like 'assert base class'
    end

    context 'assert base eq' do
      let (:assert_value) { 'ok' }
      let (:assert_err_value) { 'err' }
      it_behaves_like 'assert base eq'
    end

    context 'assert size' do
      let (:assert_value) { 'ok' }
      let (:assert_inf_value) { 'o' }
      let (:assert_sup_value) { 'sup' }
      it_behaves_like 'assert size'
    end

    context 'assert base in' do
      let (:assert_values) { ['ok', 'one', 'two'] }
      let (:assert_err_value) { 'err' }
      it_behaves_like 'assert base in'
    end

    context 'assert string regexp' do
      let (:assert_regexp) { /^[a-z]+$/ }
      let (:assert_ok_value) { 'myitem' }
      let (:assert_err_value) { 'My Item3' }
      it_behaves_like 'assert string regexp'
    end
  end
end
