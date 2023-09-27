# frozen_string_literal: true

RSpec.describe Saphyr::Fields::FieldBase do
  describe 'class' do
    subject { described_class }
    it { is_expected.to include Saphyr::Asserts::ErrorConstants }
    it { is_expected.to include Saphyr::Asserts::BaseAssert }
    it { is_expected.to include Saphyr::Asserts::SizeAssert }
    it { is_expected.to include Saphyr::Asserts::NumericAssert }
    it { is_expected.to include Saphyr::Asserts::StringAssert }
  end

  it 'must hold options' do
    subject { described_class.new }
    is_expected.to respond_to :opts
  end

  describe '.initialize' do
    subject { described_class.new }

    context 'without any options' do
      it 'assign values to default options' do
        expect(subject.opts[:required]).to be true
        expect(subject.opts[:nullable]).to be false
      end
    end

    context 'with default options provided' do
      subject { described_class.new({required: false, nullable: true}) }
      it 'must set :required and :nullable default options' do
        expect(subject.opts[:required]).to be false
        expect(subject.opts[:nullable]).to be true
      end

      it 'raises an error when :required is not a boolean' do
        expect { described_class.new({required: 1}) }.to raise_error(Saphyr::Error)
      end

      it 'raises an error when :nullable is not a boolean' do
        expect { described_class.new({nullable: 1}) }.to raise_error(Saphyr::Error)
      end
    end

    context 'with extra options provided' do
      subject { described_class.new({min: 3, max: 10}) }
      it 'merge default options and extra options' do
        expect(subject.opts[:required]).to be true
        expect(subject.opts[:nullable]).to be false
        expect(subject.opts[:min]).to be 3
        expect(subject.opts[:max]).to be 10
        expect(subject.opts.size).to be 4
      end
    end
  end

  describe '#prefix' do
    context 'when base class' do
      it 'returns the prefix' do
        subject { described_class.new }
        expect(subject.prefix).to eq 'base'
      end
    end

    context 'when subclass' do
      it 'returns the prefix' do
        # subject { SaphyrTest::FieldTest.new }   # NOTE: Don't works
        # expect{ subject.prefix }.to eq 'test'
        # expect(subject.prefix).to eq 'test'
        field = SaphyrTest::FieldTest.new
        expect(field.prefix).to eq 'test'
      end
    end
  end

  describe '#err' do
    context 'when base class' do
      it 'formats the error code with the prefix' do
        subject { described_class.new }
        expect(subject.err('code')).to eq 'base:code'
      end
    end

    context 'when subclass' do
      it 'formats the error code with the prefix' do
        field = SaphyrTest::FieldTest.new
        expect(field.err('code')).to eq 'test:code'
      end
    end
  end

  describe '#required?' do
    context 'without :required option' do
      it 'returns true' do
        field = described_class.new {}
        expect(field.required?).to be true
      end
    end

    context 'with default :required options provided' do
      it 'returns true when :required=true' do
        field = described_class.new required: true
        expect(field.required?).to be true
      end

      it 'returns false when :required=false' do
        field = described_class.new required: false
        expect(field.required?).to be false
      end
    end
  end

  describe '#nullable?' do
    context 'without :nullable option' do
      it 'returns false' do
        field = described_class.new {}
        expect(field.nullable?).to be false
      end
    end

    context 'with default :nullable options provided' do
      it 'returns true when :nullable=true' do
        field = described_class.new nullable: true
        expect(field.nullable?).to be true
      end

      it 'returns false when :nullable=false' do
        field = described_class.new nullable: false
        expect(field.nullable?).to be false
      end
    end
  end

  describe '#validate' do
    let(:validator) { SaphyrTest::OneFieldNoOptValidator.new }
    let(:valid_data) { { "name" => 'my item', } }
    let(:invalid_data) { { "name" => 3, } }

    let(:missing_in_schema_data) { { "name" => 'my item', 'missing' => 'err' } }
    let(:missing_in__data) { {} }

    context 'with valid data' do
      it 'returns true' do
        expect(validator.validate valid_data).to be true
      end
    end

    context 'with invalid data' do
      it 'returns false' do
        expect(validator.validate invalid_data).to be false
      end
    end
  end

  describe 'private methods' do
    describe '#do_validate' do
      it 'must respond' do
        subject { described_class.new }
        expect(subject.respond_to?(:do_validate, true)).to be true
      end

      it 'must raise not implemented' do
        subject { described_class.new }
        expect{ subject.send :do_validate, nil, nil, nil, nil }.to raise_error Saphyr::Error
      end
    end
  end
end
