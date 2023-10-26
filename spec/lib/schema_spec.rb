# frozen_string_literal: true

RSpec.describe Saphyr::Schema do

  subject { described_class.new }

  describe '#initialize' do
    it 'sets default values for strict, root, fields, and schemas' do
      expect(subject.instance_variable_get :@strict).to be true
      expect(subject.instance_variable_get :@root).to be :object
      expect(subject.instance_variable_get(:@fields).class).to eq Hash
      expect(subject.instance_variable_get :@fields).to be_empty
      expect(subject.instance_variable_get(:@schemas).class).to eq Hash
      expect(subject.instance_variable_get :@schemas).to be_empty
    end
  end

  context 'Part of DSL' do
    describe '#strict' do
      it 'sets the strict attribute' do
        subject.strict false
        expect(subject.instance_variable_get :@strict).to be false
      end
    end

    describe '#root' do
      it 'sets the root attribute' do
        subject.root :array
        expect(subject.instance_variable_get :@root).to be :array
      end
    end

    describe '#field' do
      it 'add a field to the fields to schema' do
        subject.field :name, :string
        expect(subject.fields).to include('name' => an_instance_of(Saphyr::Fields::StringField))
      end
    end

    describe '#schema' do
      it 'add a local schema to schema' do
        subject.schema(:user) do
          # ... schema configuration
        end
        expect(subject.instance_variable_get :@schemas).to include(user:  an_instance_of(Saphyr::Schema))
      end
    end

    describe '#contionial' do
      it 'add a conditional schema to schema' do
        subject.conditional(:cond_method) do
          field :name, :string
        end
        expect(subject.conditionals.size).to eq 1
        cond, schema = subject.conditionals[0]
        expect(cond).to eq :cond_method
        expect(schema).to be_an_instance_of Saphyr::Schema
      end

      context "when 'cond' argument is invalid" do
        it 'raise an exception' do
          expect {
            subject.conditional(4) do
              field :name, :string
            end
          }.to raise_error Saphyr::Error
        end
      end
    end

    describe '#cast' do
      it 'add field casting to schema' do
        subject.cast(:name, :method)
        expect(subject.casts.size).to eq 1
        method = subject.casts['name']
        expect(method).to eq 'method'
      end

      context "when 'method' argument is invalid" do
        it 'raise an exception' do
          expect {
            subject.cast(:name, 5)
          }.to raise_error Saphyr::Error
        end
      end
    end
  end

  describe '#find_schema' do
    it 'returns the schema with the specified name' do
      subject.schema(:user) do
        # Add schema configuration here
      end
      found_schema = subject.find_schema :user
      expect(found_schema).to be_an_instance_of Saphyr::Schema
    end

    it 'returns nil if the schema does not exist' do
      found_schema = subject.find_schema :missing_schema
      expect(found_schema).to be_nil
    end
  end

  describe '#strict?' do
    it 'returns the value of strict' do
      subject.strict false
      expect(subject.strict?).to be false
    end
  end

  describe '#root_array?' do
    it 'returns true if root is set to :array' do
      subject.root :array
      expect(subject.root_array?).to be true
    end

    it 'returns false if root is not set to :object' do
      expect(subject.root_array?).to be false
    end
  end

  describe '#root_object?' do
    it 'returns true if root is set to :object' do
      expect(subject.root_object?).to be true
    end

    it 'returns false if root is not set to :array' do
      subject.root :array
      expect(subject.root_object?).to be false
    end
  end
end
