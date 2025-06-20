# frozen_string_literal: true

RSpec.describe Saphyr::Fields::IpField do

  let(:prefix) { 'ip' } 

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
    context "when :kind option is not provided" do
      subject { described_class.new }
      it "default :kind must be equals to ':any'" do
        expect(subject.opts[:kind]).to eq :any
      end
    end

    context 'when :kind option is provided and valid' do
      it "accept ':any' value" do
        expect(described_class.new({kind: :any}).opts[:kind]).to eq :any
      end

      it "accept ':ipv4' value" do
        expect(described_class.new({kind: :ipv4}).opts[:kind]).to eq :ipv4
      end

      it "accept ':ipv6' value" do
        expect(described_class.new({kind: :ipv6}).opts[:kind]).to eq :ipv6
      end
    end

    context 'when :kind option is not valid' do
      it "raises an error if value is not in [:any, :ipv4, :ipv6]" do
        expect { described_class.new({strict: 'bad'}) }.to raise_error(Saphyr::Error)
      end
    end
  end

  describe '#do_validate' do
    subject { described_class.new }

    context 'when valid data' do
      context 'when :kind option equals to :any' do
        it 'return without error with ipv4' do
          errors = subject.send :validate, nil, 'host', '19.123.45.67'
          expect(errors.size).to eq 0
        end

        it 'return without error with ipv6' do
          errors = subject.send :validate, nil, 'host', '2002:cb0a:3cdd:1::1'
          expect(errors.size).to eq 0
        end
      end

      context 'when :kind option equals to :ipv4' do
        it 'return without error' do
          errors = subject.send :validate, nil, 'host', '19.123.45.67'
          expect(errors.size).to eq 0
        end
      end

      context 'when :kind option equals to :ipv6' do
        it 'return without error' do
          errors = subject.send :validate, nil, 'host', '2002:cb0a:3cdd:1::1'
          expect(errors.size).to eq 0
        end
      end
    end

    context 'when invalid data' do
      subject { described_class.new }

      context 'when :kind option equals to :any' do
        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'host', 'not-ip'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-ip'
        end
      end

      context 'when :kind option equals to :ipv4' do
        subject { described_class.new({kind: :ipv4}) }

        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'host', 'not-ip'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-ip'
        end

        it 'return with error on valid ipv6' do
          errors = subject.send :validate, nil, 'host', '2001:db8:85a3::8a2e:370:7334'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq '2001:db8:85a3::8a2e:370:7334'
        end
      end

      context 'when :kind option equals to :ipv6' do
        subject { described_class.new({kind: :ipv6}) }

        it 'return with error on emtpy string' do
          errors = subject.send :validate, nil, 'host', ''
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':not-empty'
          expect(errors.first[:data][:_val]).to eq ''
        end

        it 'return with error' do
          errors = subject.send :validate, nil, 'host', 'not-ip'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq 'not-ip'
        end

        it 'return with error on valid ipv4' do
          errors = subject.send :validate, nil, 'host', '220.12.145.34'
          expect(errors.size).to eq 1
          expect(errors.first[:type]).to eq prefix + ':invalid'
          expect(errors.first[:data][:_val]).to eq '220.12.145.34'
        end
      end
    end
  end
end
