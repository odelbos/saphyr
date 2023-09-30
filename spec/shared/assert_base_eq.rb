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
          subject.send :do_validate, nil, 'name', assert_value, errors
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', assert_value + 1, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq assert_prefix + ':eq'
          expect(errors.first[:msg]).to eq "Expecting value to be equals to: #{assert_value}, got: #{assert_value + 1}"
        end
      end
    end
end
