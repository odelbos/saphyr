RSpec.shared_examples 'assert base in' do

    context "assert in" do
      subject {
        d = described_class.new
        m = d.opts.merge({ in: assert_values })
        d.instance_variable_set :@opts, m
        d
      }

      context 'when valid data' do
        it 'return without error' do
          assert_values.each do |v|
            subject.send :do_validate, nil, 'name', v, errors
          end
          expect(errors.size).to eq 0
        end
      end

      context 'when invalid data' do
        it 'return an error' do
          subject.send :do_validate, nil, 'name', assert_err_value, errors
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq assert_prefix + ':in'
          # TODO: How to test msg?
          # expect(errors.first[:msg]).to eq "Expecting value to be equals to: #{assert_value}, got: #{assert_value + 1}"
        end
      end
    end
end
