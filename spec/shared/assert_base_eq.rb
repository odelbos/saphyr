RSpec.shared_examples 'assert base eq' do

  context "assert eq" do
    subject {
      d = described_class.new
      m = d.opts.merge({ eq: assert_value })
      d.instance_variable_set :@opts, m
      d
    }

    context 'when valid data' do
      it 'return without error' do
        errors = subject.send :validate, nil, 'name', assert_value
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        errors = subject.send :validate, nil, 'name', assert_err_value
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':eq'
        expect(errors.first[:data][:_val]).to eq assert_err_value
        expect(errors.first[:data][:eq]).to eq assert_value
      end
    end
  end
end
