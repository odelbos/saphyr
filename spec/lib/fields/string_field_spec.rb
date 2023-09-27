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
    let(:errors) { [] }

    subject { described_class.new }

    context "assert type" do
      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 3, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:type'
          expect(errors.first[:msg]).to eq "Expecting type 'String', got: Integer"
        end
      end
    end

    context "assert eq" do
      subject {
        d = described_class.new
        m = d.opts.merge({ eq: 'my item' })
        d.instance_variable_set :@opts, m
        d
      }

      context 'when valid data' do
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'err', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:eq'
          expect(errors.first[:msg]).to eq "Expecting value to be equals to: my item, got: err"
        end
      end
    end

    context "assert size len" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ len: 7 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ len: 3 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:size-len'
          expect(errors.first[:msg]).to eq "Expecting size equals to: 3, got: 7"
        end
      end
    end

    context "assert size min" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ min: 3 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ min: 15 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:size-min'
          expect(errors.first[:msg]).to eq "Expecting size >= 15, got: 7"
        end
      end
    end

    context "assert size max" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ max: 15 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ max: 3 })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:size-max'
          expect(errors.first[:msg]).to eq "Expecting size <= 3, got: 7"
        end
      end
    end

    context "assert in" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ in: ['ok', 'my item'] })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'my item', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ in: ['ok', 'my item'] })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'err', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:in'
          expect(errors.first[:msg]).to eq "Expecting value to be in: [\"ok\", \"my item\"], got: err"
        end
      end
    end

    context "assert regexp" do
      context 'when valid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ regexp: /^[a-z]+$/ })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return without error' do
          subject.send :do_validate, nil, 'name', 'myitem', errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        subject {
          d = described_class.new
          m = d.opts.merge({ regexp: /^[a-z]+$/ })
          d.instance_variable_set :@opts, m
          d
        }
        it 'return an error' do
          subject.send :do_validate, nil, 'name', 'My Item3', errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq 'string:regexp'
          expect(errors.first[:msg]).to eq "Value failed to match regexp: (?-mix:^[a-z]+$), got: My Item3"
        end
      end
    end
  end
end
