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
    let(:errors) { [] }

    subject { described_class.new }

    context "assert type" do
      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'ref', 3, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'ref', 'err', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:type'
          expect(errors.first[:msg]).to eq "Expecting type 'Integer', got: String"
        end
      end
    end

    context "assert eq" do
      subject {
        d = described_class.new
        m = d.opts.merge({ eq: 5 })
        d.instance_variable_set :@opts, m
        d
      }

      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 8, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:eq'
          expect(errors.first[:msg]).to eq "Expecting value to be equals to: 5, got: 8"
        end
      end
    end

    context "assert numeric gt" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ gt: 2 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ gt: 10 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:gt'
          expect(errors.first[:msg]).to eq "Expecting value > 10, got: 5"
        end
      end
    end

    context "assert numeric gte" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ gte: 5 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ gte: 10 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:gte'
          expect(errors.first[:msg]).to eq "Expecting value >= 10, got: 5"
        end
      end
    end

    context "assert numeric lt" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ lt: 10 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ lt: 3 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 3, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:lt'
          expect(errors.first[:msg]).to eq "Expecting value < 3, got: 3"
        end
      end
    end

    context "assert numeric lte" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ lte: 5 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ lte: 3 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:lte'
          expect(errors.first[:msg]).to eq "Expecting value <= 3, got: 5"
        end
      end
    end

    context "assert in" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ in: [3, 5] })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 5, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ in: [3, 5] })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 8, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'integer:in'
          expect(errors.first[:msg]).to eq "Expecting value to be in: [3, 5], got: 8"
        end
      end
    end
  end
end
