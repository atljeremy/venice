require 'time'

module Venice
  class Receipt
    # For detailed explanations on these keys/values, see
    # https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW1

    # The app’s bundle identifier.
    attr_reader :bundle_id

    # The app’s version number.
    attr_reader :application_version

    # The receipt for an in-app purchase. In the JSON file, the value of this key is an array containing all in-app purchase receipts.
    attr_reader :in_app

    # The version of the app that was originally purchased.
    attr_reader :original_application_version

    # The date when the app receipt was created
    attr_reader :creation_date

    # The date that the app receipt expires.
    attr_reader :expiration_date

    # Original json response from AppStore
    attr_reader :original_json_response

    attr_accessor :environment
    attr_accessor :latest_receipt_info
    
    def initialize(attributes = {})
      @original_json_response = attributes['original_json_response']
      @environment = attributes['environment']
      @bundle_id = attributes['bundle_id']
      @application_version = attributes['application_version']
      @original_application_version = attributes['original_application_version']

      expiration_date = attributes['expiration_date']
      @expiration_date = DateTime.parse(expiration_date) if expiration_date
      
      creation_date = attributes['creation_date']
      @creation_date = DateTime.parse(creation_date) if creation_date
      
      @in_app = []
      attributes['in_app'].each do |iap_attributes|
        @in_app << InAppReceipt.new(iap_attributes)
      end if attributes['in_app']
    end

    def to_hash
      {
        bundle_id: @bundle_id,
        application_version: @application_version,
        original_application_version: @original_application_version,
        creation_date: (@creation_date.httpdate rescue nil),
        expiration_date: (@expiration_date.httpdate rescue nil),
        in_app: @in_app.map{ |iap| iap.to_h }
      }
    end
    alias_method :to_h, :to_hash

    def to_json
      self.to_hash.to_json
    end

    class << self
      def verify(data, options = {})
        verify!(data, options) rescue false
      end

      def verify!(data, options = {})
        client = Client.production

        begin
          client.verify!(data, options)
        rescue Venice::VerificationError => error
          case error.code
          when 21007
            client = Client.development
            retry
          when 21008
            client = Client.production
            retry
          else
            raise error
          end
        end
      end

      alias :validate :verify
      alias :validate! :verify!
    end
  end
end
