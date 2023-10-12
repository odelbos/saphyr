# frozen_string_literal: true

RSpec.describe Saphyr::Asserts::NumericAssert do

  let(:test_class) {
    Class.new {
      include Saphyr::Asserts::NumericAssert
      def err(code)
        code
      end
    }
  }
  let (:errors) { [] }
  subject { test_class.new }

  describe '#assert_numeric_gt' do
    it 'return true if >' do
      expect(subject.assert_numeric_gt(5, 10, errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if not >' do
        expect(subject.assert_numeric_gt(10, 5, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'gt'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:gt]).to eq 10
      end

      it 'return false and an error if =' do
        expect(subject.assert_numeric_gt(5, 5, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'gt'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:gt]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if not >' do
        expect(subject.assert_numeric_gt(10, 5, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:gt]).to eq 10
      end
    end
  end

  describe '#assert_numeric_gte' do
    it 'return true if >=' do
      expect(subject.assert_numeric_gte(5, 10, errors)).to be true
      expect(errors).to be_empty
    end

    it 'return true if =' do
      expect(subject.assert_numeric_gte(5, 5, errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if not >=' do
        expect(subject.assert_numeric_gte(10, 5, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'gte'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:gte]).to eq 10
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if not >=' do
        expect(subject.assert_numeric_gte(10, 5, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:gte]).to eq 10
      end
    end
  end

  describe '#assert_numeric_lt' do
    it 'return true if <' do
      expect(subject.assert_numeric_lt(10, 5, errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if not <' do
        expect(subject.assert_numeric_lt(5, 10, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'lt'
        expect(errors.first[:data][:_val]).to eq 10
        expect(errors.first[:data][:lt]).to eq 5
      end

      it 'return false and an error if =' do
        expect(subject.assert_numeric_lt(5, 5, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'lt'
        expect(errors.first[:data][:_val]).to eq 5
        expect(errors.first[:data][:lt]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if not <' do
        expect(subject.assert_numeric_lt(5, 10, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:lt]).to eq 5
        expect(errors.first[:data][:_val]).to eq 10
      end
    end
  end

  describe '#assert_numeric_lte' do
    it 'return true if value if <=' do
      expect(subject.assert_numeric_lte(10, 5, errors)).to be true
      expect(errors).to be_empty
    end

    it 'return true if <=' do
      expect(subject.assert_numeric_lte(5, 5, errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if not <=' do
        expect(subject.assert_numeric_lte(5, 10, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'lte'
        expect(errors.first[:data][:_val]).to eq 10
        expect(errors.first[:data][:lte]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if not <=' do
        expect(subject.assert_numeric_lte(4, 10, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq 10
        expect(errors.first[:data][:lte]).to eq 4
      end
    end
  end
end
