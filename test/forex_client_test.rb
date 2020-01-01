require "test_helper"
require "forex_client/api"

class ForexClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ForexClient::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_to_see_if_api_can_generate_a_url_with_the_right_format
    assert API::CallStruct.new(function = "CURRENCY_EXCHANGE_RATE", from_currency = "USD", to_currency = "TWD").generate_url == 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=TWD&apikey=' + API::API_KEY
  end
  def test_to_see_if_api_can_generate_a_json_correctly
    API::get_json(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "TWD") 
  end
end
