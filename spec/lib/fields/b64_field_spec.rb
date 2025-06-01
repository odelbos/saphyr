# frozen_string_literal: true

RSpec.describe Saphyr::Fields::B64Field do

  let(:prefix) { 'b64' } 

  describe 'class' do
    it 'must have a prefix' do
      subject { described_class }
      expect(subject.class.const_get(:PREFIX)).to eq prefix
    end

    it 'must have EXPECTED_TYPES equals to String' do
      subject { described_class }
      expect(subject.class.const_get(:EXPECTED_TYPES)).to eq String
    end
  end

  describe '.initialize' do
    context "when :strict option is not provided" do
      subject { described_class.new }
      it "default :strict must be equals to 'true'" do
        expect(subject.opts[:strict]).to eq true
      end
    end

    context 'when :strict option is provided' do
      subject { described_class.new({strict: true}) }
      it "accept 'true' value" do
        expect(subject.opts[:strict]).to eq true
      end
    end

    context 'when :strict option is provided' do
      subject { described_class.new({strict: false}) }
      it "accept 'false' value" do
        expect(subject.opts[:strict]).to eq false
      end

      it "raises an error if value is not a boolean" do
        expect { described_class.new({strict: 'bad'}) }.to raise_error(Saphyr::Error)
      end
    end
  end

  describe '#do_validate' do
    subject { described_class.new }

    context 'when valid data' do
      context 'when in strict mode' do
        it 'return without error' do
          errors = subject.send :validate, nil, 'content', 'SGVsbG8='
          expect(errors.size).to eq 0
        end
      end

      context 'when not in strict mode' do
        subject { described_class.new({strict: false}) }

        it 'return without error (padded)' do
          errors = subject.send :validate, nil, 'content', 'SGVsbG8='
          expect(errors.size).to eq 0
        end

        it 'return without error (not padded)' do
          errors = subject.send :validate, nil, 'content', 'SGVsbG8'
          expect(errors.size).to eq 0
        end

        it 'return without error whith line breaks' do
          errors = subject.send :validate, nil, 'content', "SGVs\nbG8=\n"
          expect(errors.size).to eq 0
        end

        it 'return without error whith windows line breaks' do
          errors = subject.send :validate, nil, 'content', "SGVs\r\nbG8=\n"
          expect(errors.size).to eq 0
        end
      end
    end

    context 'when invalid data' do
      context 'when in strict mode' do
        it 'return with error (emtpy string)' do
          errors = subject.send :validate, nil, 'content', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error (bad format)' do
          errors = subject.send :validate, nil, 'content', 'not-b54**str'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-b54**str'
        end

        it 'return with error when not padded' do
          errors = subject.send :validate, nil, 'content', 'SGVsbG8'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'SGVsbG8'
        end

        it 'return with error whith line breaks' do
          errors = subject.send :validate, nil, 'content', "SGVs\nbG8=\n"
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq "SGVs\nbG8=\n"
        end

        it 'return with error whith windows line breaks' do
          errors = subject.send :validate, nil, 'content', "SGVs\r\nbG8=\n"
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq "SGVs\r\nbG8=\n"
        end
      end

      context 'when not in strict mode' do
        subject { described_class.new({strict: false}) }

        it 'return with error (empty string)' do
          errors = subject.send :validate, nil, 'content', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error (bad format)' do
          errors = subject.send :validate, nil, 'content', 'not-b54**str'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-b54**str'
        end
      end
    end
  end
end
