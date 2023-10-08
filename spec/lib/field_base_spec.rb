# frozen_string_literal: true

RSpec.describe Saphyr::Fields::FieldBase do
  describe 'class' do
    subject { described_class }
    it { is_expected.to include Saphyr::Asserts::ErrorConstants }
    it { is_expected.to include Saphyr::Asserts::BaseAssert }
    it { is_expected.to include Saphyr::Asserts::SizeAssert }
    it { is_expected.to include Saphyr::Asserts::NumericAssert }
    it { is_expected.to include Saphyr::Asserts::StringAssert }
  end

  it 'must hold options' do
    subject { described_class.new }
    is_expected.to respond_to :opts
  end

  describe '.initialize' do
    subject { described_class.new }

    context 'without any options' do
      it 'assign values to default options' do
        expect(subject.opts[:required]).to be true
        expect(subject.opts[:nullable]).to be false
      end
    end

    context 'with default options provided' do
      subject { described_class.new({required: false, nullable: true}) }
      it 'must set :required and :nullable default options' do
        expect(subject.opts[:required]).to be false
        expect(subject.opts[:nullable]).to be true
      end

      it 'raises an error when :required is not a boolean' do
        expect { described_class.new({required: 1}) }.to raise_error(Saphyr::Error)
      end

      it 'raises an error when :nullable is not a boolean' do
        expect { described_class.new({nullable: 1}) }.to raise_error(Saphyr::Error)
      end
    end

    context 'with extra options provided' do
      subject { described_class.new({min: 3, max: 10}) }
      it 'merge default options and extra options' do
        expect(subject.opts[:required]).to be true
        expect(subject.opts[:nullable]).to be false
        expect(subject.opts[:min]).to be 3
        expect(subject.opts[:max]).to be 10
        expect(subject.opts.size).to be 4
      end
    end

    context 'when AUTHORIZED_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          # AUTHORIZED_OPTIONS = [:opt1, :opt2]    # NOTE: Don't works
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
        }
      }

      context 'when provided options are authorised' do
        it 'create a new instance' do
          field = test_class.new({ opt1: 1, opt2: 2 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 1
          expect(field.opts[:opt2]).to eq 2
        end
      end

      context 'when provided options are not authorised' do
        it 'raise an exception' do
          expect { test_class.new({ err1: 1, err2: 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when REQUIRED_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
          required_options = [:opt1 ]
          self.const_set 'REQUIRED_OPTIONS', required_options
        }
      }

      context 'when required option is provided' do
        it 'create a new instance' do
          field = test_class.new({ opt1: 1 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 1
        end
      end

      context 'when required option is not provided' do
        it 'raise an exception' do
          expect { test_class.new }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when REQUIRED_ONE_OF_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
          one_of_options = [:opt1, :opt2]
          self.const_set 'REQUIRED_ONE_OF_OPTIONS', one_of_options
        }
      }

      context 'when one required option is provided' do
        it 'create a new instance with first option' do
          field = test_class.new({ opt1: 1 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 1
        end

        it 'create a new instance with second option' do
          field = test_class.new({ opt2: 2 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt2]).to eq 2
        end
      end

      context 'when no options are provided' do
        it 'raise an exception' do
          expect { test_class.new }.to raise_error Saphyr::Error
        end
      end

      context 'when two options are provided' do
        it 'raise an exception' do
          expect { test_class.new({ opt1: 1, opt2: 2 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when EXCLUSIVE_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2, :opt3]
          exclusive_options = [
            [:opt1, [:opt3]],
          ]
          self.const_set 'EXCLUSIVE_OPTIONS', exclusive_options
        }
      }

      context 'when provided options are correct' do
        it 'create a new instance' do
          field = test_class.new({ opt1: 1, opt2: 2 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 1
          expect(field.opts[:opt2]).to eq 2
        end
      end

      context 'when provided options are not correct' do
        it 'raise an exception' do
          expect { test_class.new({ err1: 1, err3: 3 }) }.to raise_error Saphyr::Error
        end
      end

      context 'when :_all_ is provided' do
        let(:test_class) {
          Class.new(Saphyr::Fields::FieldBase) {
            self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2, :opt3]
            exclusive_options = [
              [:opt1, [:_all_]],
            ]
            self.const_set 'EXCLUSIVE_OPTIONS', exclusive_options
          }
        }

        context 'when provided options are correct' do
          it 'create a new instance' do
            field = test_class.new({ opt1: 1 })
            expect(field).to be_a Saphyr::Fields::FieldBase
            expect(field.opts[:opt1]).to eq 1

            field = test_class.new({ opt2: 2 })
            expect(field).to be_a Saphyr::Fields::FieldBase
            expect(field.opts[:opt2]).to eq 2

            field = test_class.new({ opt3: 3 })
            expect(field).to be_a Saphyr::Fields::FieldBase
            expect(field.opts[:opt3]).to eq 3

            field = test_class.new({ opt2: 2, opt3: 3 })
            expect(field).to be_a Saphyr::Fields::FieldBase
            expect(field.opts[:opt2]).to eq 2
            expect(field.opts[:opt3]).to eq 3
          end
        end

        context 'when provided options are not correct' do
          it 'raise an exception' do
            expect { test_class.new({ err1: 1, err2: 2 }) }.to raise_error Saphyr::Error
            expect { test_class.new({ err1: 1, err3: 3 }) }.to raise_error Saphyr::Error
          end
        end
      end
    end

    context 'when NOT_SUP_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
          not_sup_options = [
            [:opt1, :opt2],
          ]
          self.const_set 'NOT_SUP_OPTIONS', not_sup_options
        }
      }

      context 'when provided options are correct' do
        it 'create a new instance' do
          field = test_class.new({ opt1: 3, opt2: 5 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 3
          expect(field.opts[:opt2]).to eq 5
        end
      end

      context 'when provided options are not correct' do
        it 'raise an exception' do
          expect { test_class.new({ opt1: 5, opt2: 3 }) }.to raise_error Saphyr::Error
        end
      end
    end

    context 'when NOT_SUP_OR_EQUALS_OPTIONS is defined' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
          not_sup_options = [
            [:opt1, :opt2],
          ]
          self.const_set 'NOT_SUP_OR_EQUALS_OPTIONS', not_sup_options
        }
      }

      context 'when provided options are correct' do
        it 'create a new instance' do
          field = test_class.new({ opt1: 3, opt2: 5 })
          expect(field).to be_a Saphyr::Fields::FieldBase
          expect(field.opts[:opt1]).to eq 3
          expect(field.opts[:opt2]).to eq 5
        end
      end

      context 'when provided options are not correct' do
        it 'raise an exception' do
          expect { test_class.new({ opt1: 5, opt2: 3 }) }.to raise_error Saphyr::Error
          expect { test_class.new({ opt1: 5, opt2: 5 }) }.to raise_error Saphyr::Error
        end
      end
    end
  end

  describe '#prefix' do
    context 'when base class' do
      it 'return the prefix' do
        subject { described_class.new }
        expect(subject.prefix).to eq 'base'
      end
    end

    context 'when subclass' do
      # subject { SaphyrTest::FieldTest.new }   # NOTE: Don't works
      it 'return the prefix' do
        # expect(subject.prefix).to eq 'test'
        field = SaphyrTest::FieldTest.new
        expect(field.prefix).to eq 'test'
      end
    end
  end

  describe '#authorised_options' do
    context 'when base class' do
      it 'return the AUTHORIZED_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.authorized_options).to be_an_instance_of Array
        expect(subject.authorized_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
        }
      }
      subject { test_class.new }

      it 'return the AUTHORIZED_OPTIONS class constant' do
        expect(subject.authorized_options).to be_an_instance_of Array
        expect(subject.authorized_options.size).to eq 2
        expect(subject.authorized_options[0]).to eq :opt1
        expect(subject.authorized_options[1]).to eq :opt2
      end
    end
  end

  describe '#required_options' do
    context 'when base class' do
      it 'return the REQUIRED_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.required_options).to be_an_instance_of Array
        expect(subject.required_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'REQUIRED_OPTIONS', [ :opt1 ]
        }
      }
      subject { test_class.new({ opt1: 1 }) }

      it 'return the REQUIRED_OPTIONS class constant' do
        expect(subject.required_options).to be_an_instance_of Array
        expect(subject.required_options.size).to eq 1
        expect(subject.required_options[0]).to eq :opt1
      end
    end
  end

  describe '#required_one_of_options' do
    context 'when base class' do
      it 'return the REQUIRED_ONE_OF_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.required_one_of_options).to be_an_instance_of Array
        expect(subject.required_one_of_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2]
          one_of_options = [:opt1, :opt2]
          self.const_set 'REQUIRED_ONE_OF_OPTIONS', one_of_options
        }
      }
      subject { test_class.new({opt1: 'ok'}) }

      it 'return the REQUIRED_ONE_OF_OPTIONS class constant' do
        expect(subject.required_one_of_options).to be_an_instance_of Array
        expect(subject.required_one_of_options.size).to eq 2
        expect(subject.authorized_options[0]).to eq :opt1
        expect(subject.authorized_options[1]).to eq :opt2
      end
    end
  end

  describe '#exclusive_options' do
    context 'when base class' do
      it 'return the EXCLUSIVE_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.exclusive_options).to be_an_instance_of Array
        expect(subject.exclusive_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'AUTHORIZED_OPTIONS', [:opt1, :opt2, :opt3]
          exclusive_options = [
            [:opt1, [:opt3]],
          ]
          self.const_set 'EXCLUSIVE_OPTIONS', exclusive_options
        }
      }
      subject { test_class.new }

      it 'return the EXCLUSIVE_OPTIONS class constant' do
        expect(subject.exclusive_options).to be_an_instance_of Array
        expect(subject.exclusive_options.size).to eq 1
      end
    end
  end

  describe '#not_equals_options' do
    context 'when base class' do
      it 'return the NOT_EQUALS_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.not_equals_options).to be_an_instance_of Array
        expect(subject.not_equals_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'NOT_EQUALS_OPTIONS', [
            [:opt1, :opt2],
          ]
        }
      }
      subject { test_class.new }

      it 'return the NOT_EQUALS_OPTIONS class constant' do
        expect(subject.not_equals_options).to be_an_instance_of Array
        expect(subject.not_equals_options.size).to eq 1
        expect(subject.not_equals_options.first[0]).to eq :opt1
        expect(subject.not_equals_options.first[1]).to eq :opt2
      end
    end
  end

  describe '#not_sup_options' do
    context 'when base class' do
      it 'return the NOT_SUP_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.not_sup_options).to be_an_instance_of Array
        expect(subject.not_sup_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'NOT_SUP_OPTIONS', [
            [:opt1, :opt2],
          ]
        }
      }
      subject { test_class.new }

      it 'return the NOT_SUP_OPTIONS class constant' do
        expect(subject.not_sup_options).to be_an_instance_of Array
        expect(subject.not_sup_options.size).to eq 1
        expect(subject.not_sup_options.first[0]).to eq :opt1
        expect(subject.not_sup_options.first[1]).to eq :opt2
      end
    end
  end

  describe '#not_sup_or_equals_options' do
    context 'when base class' do
      it 'return the NOT_SUP_OR_EQUALS_OPTIONS class constant' do
        subject { described_class.new }
        expect(subject.not_sup_or_equals_options).to be_an_instance_of Array
        expect(subject.not_sup_or_equals_options).to be_empty
      end
    end

    context 'when subclass' do
      let(:test_class) {
        Class.new(Saphyr::Fields::FieldBase) {
          self.const_set 'NOT_SUP_OR_EQUALS_OPTIONS', [
            [:opt1, :opt2],
          ]
        }
      }
      subject { test_class.new }

      it 'return the NOT_SUP_OR_EQUALS_OPTIONS class constant' do
        expect(subject.not_sup_or_equals_options).to be_an_instance_of Array
        expect(subject.not_sup_or_equals_options.size).to eq 1
        expect(subject.not_sup_or_equals_options.first[0]).to eq :opt1
        expect(subject.not_sup_or_equals_options.first[1]).to eq :opt2
      end
    end
  end

  describe '#err' do
    context 'when base class' do
      it 'formats the error code with the prefix' do
        subject { described_class.new }
        expect(subject.err('code')).to eq 'base:code'
      end
    end

    context 'when subclass' do
      it 'formats the error code with the prefix' do
        field = SaphyrTest::FieldTest.new
        expect(field.err('code')).to eq 'test:code'
      end
    end
  end

  describe '#required?' do
    context 'without :required option' do
      it 'return true' do
        field = described_class.new {}
        expect(field.required?).to be true
      end
    end

    context 'with default :required options provided' do
      it 'return true when :required=true' do
        field = described_class.new required: true
        expect(field.required?).to be true
      end

      it 'return false when :required=false' do
        field = described_class.new required: false
        expect(field.required?).to be false
      end
    end
  end

  describe '#nullable?' do
    context 'without :nullable option' do
      it 'return false' do
        field = described_class.new {}
        expect(field.nullable?).to be false
      end
    end

    context 'with default :nullable options provided' do
      it 'return true when :nullable=true' do
        field = described_class.new nullable: true
        expect(field.nullable?).to be true
      end

      it 'return false when :nullable=false' do
        field = described_class.new nullable: false
        expect(field.nullable?).to be false
      end
    end
  end

  describe '#validate' do
    let(:validator) { SaphyrTest::OneFieldNoOptValidator.new }
    let(:valid_data) { { "name" => 'my item', } }
    let(:invalid_data) { { "name" => 3, } }

    let(:missing_in_schema_data) { { "name" => 'my item', 'missing' => 'err' } }
    let(:missing_in__data) { {} }

    context 'with valid data' do
      it 'return true' do
        expect(validator.validate valid_data).to be true
      end
    end

    context 'with invalid data' do
      it 'return false' do
        expect(validator.validate invalid_data).to be false
      end
    end
  end

  describe 'private methods' do
    describe '#do_validate' do
      it 'must respond' do
        subject { described_class.new }
        expect(subject.respond_to?(:do_validate, true)).to be true
      end

      it 'must raise not implemented' do
        subject { described_class.new }
        expect{ subject.send :do_validate, nil, nil, nil, nil }.to raise_error Saphyr::Error
      end
    end
  end
end
