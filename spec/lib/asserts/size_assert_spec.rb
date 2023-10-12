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
    it 'return true if value size is correct' do
      expect(subject.assert_size_len(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if value size is not correct' do
        expect(subject.assert_size_len(10, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-len'
        expect(errors.first[:data][:_val]).to eq '12345'
        expect(errors.first[:data][:len]).to eq 10
        expect(errors.first[:data][:got]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if value size is not correct' do
        expect(subject.assert_size_len(10, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq '12345'
        expect(errors.first[:data][:len]).to eq 10
        expect(errors.first[:data][:got]).to eq 5
      end
    end
  end

  describe '#assert_size_min' do
    it 'return true if value size minimum is correct (> case)' do
      expect(subject.assert_size_min(3, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    it 'return true if value size minimum is correct (= case)' do
      expect(subject.assert_size_min(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if value size is not orrect' do
        expect(subject.assert_size_min(10, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-min'
        expect(errors.first[:data][:_val]).to eq '12345'
        expect(errors.first[:data][:min]).to eq 10
        expect(errors.first[:data][:got]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if value size is not correct' do
        expect(subject.assert_size_min(10, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end

  describe '#assert_size_max' do
    it 'return true if value size maximum is correct (< case)' do
      expect(subject.assert_size_max(10, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    it 'return true if value size size maximum is correct (= case)' do
      expect(subject.assert_size_max(5, '12345', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if value size maximum is not correct' do
        expect(subject.assert_size_max(4, '12345', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'size-max'
        expect(errors.first[:data][:_val]).to eq '12345'
        expect(errors.first[:data][:max]).to eq 4
        expect(errors.first[:data][:got]).to eq 5
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if value size maximum is not correct' do
        expect(subject.assert_size_max(4, '12345', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        expect(errors.first[:data][:_val]).to eq '12345'
        expect(errors.first[:data][:max]).to eq 4
        expect(errors.first[:data][:got]).to eq 5
      end
    end
  end
end
