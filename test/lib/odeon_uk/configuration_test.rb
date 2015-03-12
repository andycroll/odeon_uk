require_relative '../../test_helper'

describe OdeonUk do
  describe '.configuration' do
    describe '.method' do
      it 'sets default value' do
        OdeonUk.configuration.method.must_equal(:html)
      end
    end
  end

  describe '.configure' do
    before do
      OdeonUk.configure do |config|
        config.method = :api
      end
    end

    after do
      OdeonUk.configure do |config|
        config.method = :html
      end
    end

    it 'sets the small words for the gem to downcase' do
      OdeonUk.configuration.method.must_equal(:api)
    end
  end
end
