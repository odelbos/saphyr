RSpec.shared_examples 'assert string regexp' do

  context 'assert regexp' do
    subject {
      d = described_class.new
      m = d.opts.merge({ regexp: assert_regexp })
      d.instance_variable_set :@opts, m
      d
    }

    context 'when valid data' do
      it 'return without error' do
        subject.send :do_validate, nil, 'name', assert_ok_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        subject.send :do_validate, nil, 'name', assert_err_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':regexp'
        expect(errors.first[:data][:_val]).to eq assert_err_value
        expect(errors.first[:data][:regexp]).to eq assert_regexp
      end
    end
  end
end
