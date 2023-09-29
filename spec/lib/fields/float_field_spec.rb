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
    let(:errors) { [] }

    subject { described_class.new }

    context "assert type" do
      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'ref', 3.14, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'ref', 'err', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'float:type'
          expect(errors.first[:msg]).to eq "Expecting type 'Float', got: String"
        end
      end
    end

    context "assert eq" do
      subject {
        d = described_class.new
        m = d.opts.merge({ eq: 5.25 })
        d.instance_variable_set :@opts, m
        d
      }

      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5.25, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 8.12, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'float:eq'
          expect(errors.first[:msg]).to eq "Expecting value to be equals to: 5.25, got: 8.12"
        end
      end
    end

    #
    # ...
    #

  end
end
