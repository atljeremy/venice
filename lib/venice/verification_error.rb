module Venice
  class VerificationError < StandardError
    attr_accessor :code, :retryable

    def initialize(code, retryable: false)
      @code = code.to_i
      @retryable = retryable.to_s == 'true'
    end

    def message
      case @code
        when 21000
          "The App Store could not read the JSON object you provided."
        when 21002
          "The data in the receipt-data property was malformed."
        when 21003
          "The receipt could not be authenticated."
        when 21004
          "The shared secret you provided does not match the shared secret on file for your account."
        when 21005
          "The receipt server is not currently available."
        when 21006
          "This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response."
        when 21007
          "This receipt is a sandbox receipt, but it was sent to the production service for verification."
        when 21008
          "This receipt is a production receipt, but it was sent to the sandbox service for verification."
        when 21010
          "This receipt could not be authorized. Treat this the same as if a purchase was never made."
        else
          "Unknown Error: #{code}. Retryable: #{retryable}"
      end
    end
  end
end
