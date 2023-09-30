# frozen_string_literal: true

RSpec.describe Saphyr::Fields::StringField do

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq 'string'
      # expect(Saphyr::Fields::StringField::PREFIX).to eq 'string'
    end
  end

  #
  # TODO: Tests options
  #  if using :len then can't use other options ...
  #

  #
  # TODO: Can't have :min > :max
  #

  #
  # TODO: if have :min = :max then use :len
  #

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
