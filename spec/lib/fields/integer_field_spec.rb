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
