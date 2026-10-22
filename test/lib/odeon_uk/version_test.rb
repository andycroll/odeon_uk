require_relative '../../test_helper'

class OdeonUk::VersionTest < Minitest::Test
  def test_version_is_defined
    refute_nil OdeonUk::VERSION
  end
end
