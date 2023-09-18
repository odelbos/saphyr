# frozen_string_literal: true

RSpec.describe Saphyr do

  describe 'Module' do
    it 'should have a version number' do
      expect(Saphyr::VERSION).not_to be_nil
    end

    it 'should have a valid version format' do
      # x.x.x(.[ pre | beta | rc1 | ...])
      expect(Saphyr::VERSION).to match(/\d+\.\d+\.\d+(\.\w+)?/)
    end
  end
end
