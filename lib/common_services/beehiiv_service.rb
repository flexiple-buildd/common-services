# https://developers.beehiiv.com/docs/v2/1a77a563675ee-create
class BeehiivService < BaseApiService
    URI_BASE = 'https://api.beehiiv.com/v2/'.freeze
    PUBLICATION_ID = ENV.fetch('BEEHIIV_BUILDD_PUBLICATION_ID')
  
    class BeehiivApiError < StandardError
      def initialize(error_object, status)
        super("Beehiiv API error: #{status}")
        @error_object = error_object
      end
  
      def message
        @error_object.errors[0].message
      end
    end
  
    class << self
      def get_subscription_for_user(user)
        response = get_request(path: "publications/#{PUBLICATION_ID}/subscriptions/by_email/#{user.email}")
        return nil if response.status == 404
  
        parsed_response = Hashie::Mash.new(JSON.parse(response))
        # https://developers.beehiiv.com/docs/v2/1a77a563675ee-create#Responses
        if parsed_response.key?('status')
          error = BeehiivApiError.new(parsed_response, parsed_response.status)
          return { status:parsed_response.status, error: error.message }
        else
          return {status: 200, message: parsed_response.data.to_json}
        end
      end
  
      def create_subscription(user, source: 'signup')
        response = post_request(path: "publications/#{PUBLICATION_ID}/subscriptions", parameters: {
                                  email: user[:email],
                                  utm_source: source
                                })
        parsed_response = Hashie::Mash.new(JSON.parse(response))
        # https://developers.beehiiv.com/docs/v2/1a77a563675ee-create#Responses
        if parsed_response.key?('status')
          error = BeehiivApiError.new(parsed_response, parsed_response.status)
          return { status:parsed_response.status, error: error.message }
        else
          return {status: 200, message: parsed_response.data.to_json}
        end
      end
  
      def update_subscription(buildd_user)
        subscription = get_subscription_for_user(buildd_user)
        return if subscription.blank?
  
        response = put_request(
          path: "publications/#{PUBLICATION_ID}/subscriptions/#{subscription.id}",
          parameters: {
            email: buildd_user.email,
            custom_fields: custom_fields(buildd_user)
          }
        )
  
        parsed_response = Hashie::Mash.new(JSON.parse(response))
        # https://developers.beehiiv.com/docs/v2/1a77a563675ee-create#Responses
        if parsed_response.key?('status')
          error = BeehiivApiError.new(parsed_response, parsed_response.status)
          return { status:parsed_response.status, error: error.message }
        else
          return {status: 200, message: parsed_response.data.to_json}
        end
      end
  
      def delete_subscription(buildd_user)
        subscription = get_subscription_for_user(buildd_user)
        return if subscription.blank?
  
        response = delete_request(
          path: "publications/#{PUBLICATION_ID}/subscriptions/#{subscription.id}"
        )
  
        parsed_response = Hashie::Mash.new(JSON.parse(response))
        # https://developers.beehiiv.com/docs/v2/1a77a563675ee-create#Responses
        if parsed_response.key?('status')
          error = BeehiivApiError.new(parsed_response, parsed_response.status)
          return { status:parsed_response.status, error: error.message }
        else
          return {status: 200, message: parsed_response.data.to_json}
        end
      end
  
      private
  
      def headers
        super.merge({
                      'Authorization': "Bearer #{ENV.fetch('BEEHIIV_API_KEY')}"
                    })
      end
  
      def uri_base
        URI_BASE
      end
    end
  end
  