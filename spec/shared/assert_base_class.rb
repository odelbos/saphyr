RSpec.shared_examples 'assert base class' do

  context "assert class" do
    context 'when valid data' do
      it 'return without error' do
        errors = subject.send :validate, nil, 'ref', assert_value
        expect(errors.size).to eq 0
      end
    end

    context 'when invalid data' do
      it 'return an error' do
        errors = subject.send :validate, nil, 'ref', assert_err_value
        expect(errors.size).to eq 1
        expect(errors.first[:type]).to eq assert_prefix + ':type'
        expect(errors.first[:data][:type]).to eq [assert_value.class].to_s
        expect(errors.first[:data][:got]).to eq assert_err_value.class.name
      end
    end
  end
end
