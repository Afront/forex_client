require "test_helper"

class ForexClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ForexClient::VERSION
  end

  def test_it_does_something_useful
  	p "hi"
    assert true
  end
end
