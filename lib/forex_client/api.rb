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
	def get_url(function:, from_currency: false, to_currency: false, from_symbol: false, to_symbol: false, interval: false, outputsize: false, datatype: false)
    call = CallStruct.new(function, from_currency, to_currency, from_symbol, to_symbol, interval, outputsize, datatype)
    call.generate_url
	end

end


