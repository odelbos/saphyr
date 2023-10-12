RSpec.shared_examples 'assert numeric' do

  context "assert numeric gt" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ gt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value + 1, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ gt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':gt'
        expect(errors.first[:data][:_val]).to eq assert_value
        expect(errors.first[:data][:gt]).to eq assert_value
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ gt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value - 1, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':gt'
        expect(errors.first[:data][:_val]).to eq assert_value - 1
        expect(errors.first[:data][:gt]).to eq assert_value
      end
    end
  end

  context "assert numeric gte" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ gte: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value + 1, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ gte: assert_value })
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
        m = d.opts.merge({ gte: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value - 1, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':gte'
        expect(errors.first[:data][:_val]).to eq assert_value - 1
        expect(errors.first[:data][:gte]).to eq assert_value
      end
    end
  end

  context "assert numeric lt" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ lt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value - 1, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ lt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':lt'
        expect(errors.first[:data][:_val]).to eq assert_value
        expect(errors.first[:data][:lt]).to eq assert_value
      end
    end

    context 'when invalid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ lt: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value + 1, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':lt'
        expect(errors.first[:data][:_val]).to eq assert_value + 1
        expect(errors.first[:data][:lt]).to eq assert_value
      end
    end
  end

  context "assert numeric lte" do
    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ lte: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_value - 1, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when valid data' do
      subject {
        d = described_class.new
        m = d.opts.merge({ lte: assert_value })
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
        m = d.opts.merge({ lte: assert_value })
        d.instance_variable_set :@opts, m
        d
      }
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_value + 1, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':lte'
        expect(errors.first[:data][:_val]).to eq assert_value + 1
        expect(errors.first[:data][:lte]).to eq assert_value
      end
    end
  end
end
