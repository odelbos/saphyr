# frozen_string_literal: true

RSpec.describe Saphyr::Asserts::StringAssert do

  let(:test_class) {
    Class.new {
      include Saphyr::Asserts::StringAssert
      def err(code)
        code
      end
    }
  }
  let (:errors) { [] }
  subject { test_class.new }

  describe '#assert_size_len' do
    it 'return true if value match regexp' do
      expect(subject.assert_string_regexp(/^[a-z]+$/, 'abcdef', errors)).to be true
      expect(errors).to be_empty
    end

    context 'when no error code is provided' do
      it 'return false and an error if value do not match regexp' do
        expect(subject.assert_string_regexp(/^[a-z]+$/, 'RL45ef', errors)).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'regexp'
        #
        # TODO: Test error format?
      end
    end

    context 'when a custom error code is provided' do
      it 'return false and an error if value do not match regexp' do
        expect(subject.assert_string_regexp(/^[a-z]+$/, 'RL45ef', errors, 'mycode')).to be false
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq 'mycode'
        #
        # TODO: Test error format?
      end
    end
  end
end
