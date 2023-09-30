RSpec.shared_examples 'assert base class' do

  context "assert class" do
    context 'when valid data' do
      it 'return without error' do
        subject.send :do_validate, nil, 'ref', assert_value, errors
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        subject.send :do_validate, nil, 'ref', assert_err_value, errors
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':type'
        # TODO: How to manage msg test?
        # expect(errors.first[:msg]).to eq "Expecting type 'Float', got: String"
      end
    end
  end
end
