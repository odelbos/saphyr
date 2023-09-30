# frozen_string_literal: true

RSpec.describe Saphyr::Fields::FloatField do

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq 'float'
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
    let (:assert_prefix) { 'float' }
    let(:errors) { [] }
    subject { described_class.new }

    context 'assert base class' do
      let (:assert_value) { 5.25 }
      let (:assert_err_value) { 'err' }
      it_behaves_like 'assert base class'
    end

    context 'assert base eq' do
      let (:assert_value) { 5.25 }
      it_behaves_like 'assert base eq'
    end

    context 'assert numric' do
      let (:assert_value) { 5.25 }
      it_behaves_like 'assert numeric'
    end

    context 'assert base in' do
      let (:assert_values) { [3.14, 5.25, 7.48] }
      let (:assert_err_value) { 15.67 }
      it_behaves_like 'assert base in'
    end
  end
end
