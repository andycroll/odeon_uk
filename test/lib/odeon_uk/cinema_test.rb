require_relative '../../test_helper'

describe OdeonUk::Cinema do
  let(:described_class) { OdeonUk::Cinema }

  before { WebMock.disable_net_connect! }
end
