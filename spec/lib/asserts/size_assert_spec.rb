# frozen_string_literal: true

RSpec.describe Saphyr::Asserts::SizeAssert do

  let(:test_class) {
    Class.new {
      include Saphyr::Asserts::SizeAssert
      def err(code)
        code
      end
    }
  }
  let (:errors) { [] }
  subject { test_class.new }

  describe '#assert_size_len' do
    it 'returns true if value is of the correct length' do
      expect(subject.assert_size_len(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not of correct length' do
        expect(subject.assert_size_len(10, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-len'
        #
        # TODO: Test error format?
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not of correct length' do
        expect(subject.assert_size_len(10, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end

  describe '#assert_size_min' do
    it 'returns true if value is of minimum length' do
      expect(subject.assert_size_min(3, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    it 'returns true if value is of minimum length or equals' do
      expect(subject.assert_size_min(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not of minimum length' do
        expect(subject.assert_size_min(10, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-min'
        #
        # TODO: Test error format?
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not of minimum length' do
        expect(subject.assert_size_min(10, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end

  describe '#assert_size_max' do
    it 'returns true if value is of maximum length' do
      expect(subject.assert_size_max(10, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    it 'returns true if value is of maximum length or equals' do
      expect(subject.assert_size_max(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'returns false and adds an error if value is not of maximum length' do
        expect(subject.assert_size_max(4, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-max'
        #
        # TODO: Test error format?
      end
    end

    context 'when a custom error code is provided' do
      it 'returns false and adds an error if value is not of maximum length' do
        expect(subject.assert_size_max(4, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end
end
