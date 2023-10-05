# frozen_string_literal: true

RSpec.describe Saphyr::Fields::IntegerField do

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq 'integer'
      # expect(Saphyr::Fields::StringField::PREFIX).to eq 'string'
    end
  end

  #
  # TODO: Tests options
  #  if using :len then can't use other options ...
  #

  #
  # TODO: Can't have :lt > :gt
  # Can't have :lte > :gte
  #

  #
  # TODO: if have :lte = :gte then use :aq
  #


  describe '.initialize' do
    let(:authorized_opts) { [:eq, :gt, :gte, :lt, :lte, :in] }

    context 'authorized options' do
      it 'accept any valid options' do
        authorized_opts.each do |opt|
          field = described_class.new({ opt => 1 })
          expect(field).to be_a Saphyr::Fields::IntegerField
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
          expect { described_class.new({ eq: 1, opt => 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when :in is used then cannot use any other options' do
      it 'raise an exception for invalid option' do
        authorized_opts.each do |opt|
          next if opt == :in
          expect { described_class.new({ in: [], opt => 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when :gt is used then cannot use :gte' do
      it 'raise an exception' do
        expect { described_class.new({ gt: 1, gte: 3 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :lt is used then cannot use :lte' do
      it 'raise an exception' do
        expect { described_class.new({ lt: 1, lte: 3 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :gt >= :lt' do
      it 'raise an exception' do
        expect { described_class.new({ gt: 5, lt: 3 }) }.to raise_error Saphyr::Error
        expect { described_class.new({ gt: 5, lt: 5 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :gt >= :lte' do
      it 'raise an exception' do
        expect { described_class.new({ gt: 5, lte: 3 }) }.to raise_error Saphyr::Error
        expect { described_class.new({ gt: 5, lte: 5 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :gte >= :lt' do
      it 'raise an exception' do
        expect { described_class.new({ gte: 5, lt: 3 }) }.to raise_error Saphyr::Error
        expect { described_class.new({ gte: 5, lt: 5 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :gte > :lte' do
      it 'raise an exception' do
        expect { described_class.new({ gte: 5, lte: 3 }) }.to raise_error Saphyr::Error
      end
    end

    context 'when :lte = :gte' do
      it 'raise an exception' do
        expect { described_class.new({ lte: 5, gte: 5 }) }.to raise_error Saphyr::Error
      end
    end
  end

  describe '#do_validate' do
    let (:assert_prefix) { 'integer' }
    let(:errors) { [] }
    subject { described_class.new }

    context 'assert base class' do
      let (:assert_value) { 5 }
      let (:assert_err_value) { 'err' }
      it_behaves_like 'assert base class'
    end

    context 'assert base eq' do
      let (:assert_value) { 5 }
      let (:assert_err_value) { 7 }
      it_behaves_like 'assert base eq'
    end

    context 'assert numric' do
      let (:assert_value) { 5 }
      it_behaves_like 'assert numeric'
    end

    context 'assert base in' do
      let (:assert_values) { [3, 5, 7] }
      let (:assert_err_value) { 15 }
      it_behaves_like 'assert base in'
    end
  end
end
