require_relative '../../test_helper'

describe OdeonUk::Film do

  before { WebMock.disable_net_connect! }

  describe '.new(name)' do
    it 'stores name' do
      film = OdeonUk::Film.new 'Iron Man 3'
      film.name.must_equal 'Iron Man 3'
    end
  end
end
