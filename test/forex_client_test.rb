require "test_helper"
require "forex_client/api"

class ForexClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ForexClient::VERSION
  end

  def setup
    @callstruct =  API::CallStruct.new(function = "CURRENCY_EXCHANGE_RATE", from_currency = "USD", to_currency = "TWD")
  end

  def test_to_see_if_api_can_generate_a_url_with_the_right_format
    assert @callstruct.get_url == 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=TWD&apikey=' + API::API_KEY
  end

  def test_to_see_if_api_can_generate_a_json_correctly
    assert (API::get_json @callstruct).class == Hash 
  end

  def test_something
    API::test(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "TWD")
  end
end