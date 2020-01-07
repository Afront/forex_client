require 'Faraday'
require 'JSON'

module API
  raise IOError, 'ALPHA_VANTAGE_API_KEY is not set as an environmental variable' if ENV['ALPHA_VANTAGE_API_KEY'].nil?
  API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :interval, :outputsize, :datatype) do
    def get_url #previously validate_data, get_valid_arr, generate_url
      parameters = {"CURRENCY_EXCHANGE_RATE"=> {:required => [function, from_currency, to_currency], :optional => []}, 
        "FX_INTRADAY"=> {:required => [function, from_symbol, to_symbol, interval], :optional => [outputsize, datatype]},  
        "FX_DAILY"=> {:required => [function, from_symbol, to_symbol], :optional => [outputsize, datatype]},
        "FX_WEEKLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]},
        "FX_MONTHLY"=> {:required => [function, from_symbol, to_symbol], :optional => [datatype]},
        }

      required_parameters = parameters[function][:required]
      optional_parameters = parameters[function][:optional]

      arr_err = []
      arr_valid = []
      self.each_pair do |parameter, value|
        arr_err << "#{parameter} is not set" if !value && (required_parameters.include? value) #need to fix name choices soon
        arr_err << "#{parameter} should not be set for #{function}" unless (required_parameters+optional_parameters).include?(value) || !value
        arr_valid << "#{parameter}=#{value}" if value
        break unless arr_err.empty?
      end

      raise ArgumentError, arr_err.join('\n') unless arr_err.empty? #fix newline

      'https://www.alphavantage.co/query?' + arr_valid.join('&') + '&apikey=' + API_KEY
    end
  end

  module_function 

  def get_json call_struct
    json_result = Faraday.get call_struct.get_url
    JSON.parse json_result.body
  end

  def print_json json
    json.first[1].each {|key, value| puts "#{key.gsub(/\d+\. /, '')}: #{value}"}
  end

  def test(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, interval: false, outputsize: false, datatype: false)
    call = CallStruct.new(function, from_currency, to_currency, from_symbol, to_symbol, interval, outputsize, datatype)
    print_json(get_json(call))
  end
end

=begin
require 'benchmark'
n = 10000
Benchmark.bm(7) do |x|
  x.report("Generating struct instance and url")   {API::CallStruct.new(function = "CURRENCY_EXCHANGE_RATE", from_currency = "USD", to_currency = "TWD").generate_url}
  x.report("Generating class instance and url") {API::CallStructClass.new(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "TWD").generate_url}
  x.report("Generating struct instance")   {API::CallStruct.new(function = "CURRENCY_EXCHANGE_RATE", from_currency = "USD", to_currency = "TWD")}
  x.report("Generating class instance") {API::CallStructClass.new(function: "CURRENCY_EXCHANGE_RATE", from_currency: "USD", to_currency: "TWD").generate_url}
end
=end