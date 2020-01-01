require 'Faraday'
module API
	API_KEY = ENV['ALPHA_VANTAGE_API_KEY'].to_s
  CallStruct = Struct.new(:function, :from_currency, :to_currency, :from_symbol, :to_symbol, :interval, :outputsize, :datatype) do
    def validate_data

    end

    def generate_url
      arr = []
      self.each_pair do |parameter, value|
        arr << "#{parameter}=#{value}" if value
      end
      'https://www.alphavantage.co/query?' + arr.join('&') + '&apikey=' + API_KEY
    end
  end

  module_function 

  def get_json(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, interval: false, outputsize: false, datatype: false)
    json_result = Faraday.get CallStruct.new(function, from_currency, to_currency, from_symbol, to_symbol, interval, outputsize, datatype).generate_url
    puts json_result.body
  end

end


