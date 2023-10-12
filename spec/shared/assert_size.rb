RSpec.shared_examples 'assert size' do

  context "assert size len" do
    subject {
      d = described_class.new
      m = d.opts.merge({ len: assert_value.size })
      d.instance_variable_set :@opts, m
      d
    }
    context 'when valid data' do
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_inf_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':size-len'
        expect(errors.first[:data][:_val]).to eq assert_inf_value
        expect(errors.first[:data][:len]).to eq assert_value.size
      end
    end
  end

  context "assert size min" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ min: assert_inf_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ min: assert_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ min: assert_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_inf_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':size-min'
        expect(errors.first[:data][:_val]).to eq assert_inf_value
        expect(errors.first[:data][:min]).to eq assert_value.size
      end
    end
  end

  context "assert size max" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ max: assert_sup_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ max: assert_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ max: assert_value.size })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_sup_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':size-max'
        expect(errors.first[:data][:_val]).to eq assert_sup_value
        expect(errors.first[:data][:max]).to eq assert_value.size
      end
    end
  end
end
