# frozen_string_literal: true

RSpec.describe Saphyr::Fields do

  describe 'Module' do
    it 'define FieldBase' do
      expect(defined?(Saphyr::Fields::FieldBase)).to eq 'constant'
      expect(Saphyr::Fields::FieldBase.class).to eq Class
    end

    it 'define StringField' do
      expect(defined?(Saphyr::Fields::StringField)).to eq 'constant'
      expect(Saphyr::Fields::StringField.class).to eq Class
    end

    it 'define IntegerField' do
      expect(defined?(Saphyr::Fields::IntegerField)).to eq 'constant'
      expect(Saphyr::Fields::IntegerField.class).to eq Class
    end

    it 'define FloatField' do
      expect(defined?(Saphyr::Fields::FloatField)).to eq 'constant'
      expect(Saphyr::Fields::FloatField.class).to eq Class
    end
  end
end
