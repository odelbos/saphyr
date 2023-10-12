# frozen_string_literal: true

RSpec.describe Saphyr::Asserts::BaseAssert do

  let(:test_class) {
    Class.new {
      include Saphyr::Asserts::BaseAssert
      def err(code)
        code
      end
    }
  }
  let (:errors) { [] }
  subject { test_class.new }

  describe '#assert_boolean' do
    it 'returns true for TrueClass' do
      expect(subject.assert_boolean(true)).to be true
    end

    it 'returns true for FalseClass' do
      expect(subject.assert_boolean(false)).to be true
    end

    it 'returns false for other classes' do
      expect(subject.assert_boolean('string')).to be false
      expect(subject.assert_boolean(123)).to be false
    end
  end

  describe '#assert_class' do
    it 'return true if value is of the specified class' do
      expect(subject.assert_class String, 'ok', errors).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not of the specified class' do
        expect(subject.assert_class(String, 0, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'type'
        expect(errors.first[:data][:type]).to eq 'String'
        expect(errors.first[:data][:got]).to eq 'Integer'
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not of the specified class' do
        expect(subject.assert_class(String, 0, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:type]).to eq 'String'
        expect(errors.first[:data][:got]).to eq 'Integer'
      end
    end
  end

  describe '#assert_eq' do
    it 'returns true if value is equal to opt_value' do
      expect(subject.assert_eq(5, 5, errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not equal to opt_value' do
        expect(subject.assert_eq(5, 10, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'eq'
        expect(errors.first[:data][:_val]).to eq 10
        expect(errors.first[:data][:eq]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not equal to opt_value' do
        expect(subject.assert_eq(5, 10, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq 10
        expect(errors.first[:data][:eq]).to eq 5
      end
    end
  end

  describe '#assert_in' do
    let (:values) { [1, 2, 3] }

    it 'returns true if value is in values' do
      values.each { |v| expect(subject.assert_in(values, v, errors)).to be true }
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not in values' do
        expect(subject.assert_in(values, 4, errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'in'
        #
        # TODO: Test error format?
        expect(errors.first[:data][:_val]).to eq 4
        expect(errors.first[:data][:in]).to eq [1, 2, 3]
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not in values' do
        expect(subject.assert_in(values, 4, errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end
end
