class BaseApiService
    class << self
      private
  
      def get_request(path:, parameters: nil)
        HTTP.get(
          uri(path:),
          headers:,
          params: parameters
        )
      end
  
      def post_request(path:, parameters: nil)
        HTTP.post(
          uri(path:),
          headers:,
          body: parameters&.to_json
        )
      end
  
      def put_request(path:, parameters: nil)
        HTTP.put(
          uri(path:),
          headers:,
          body: parameters&.to_json
        )
      end
  
      def delete_request(path:, parameters: nil)
        HTTP.delete(
          uri(path:),
          headers:,
          body: parameters&.to_json
        )
      end
  
      def get_async(path:, parameters: nil)
        HttpRequestJob.perform_async(
          'get',
          uri(path:).to_s,
          parameters&.deep_stringify_keys,
          headers&.deep_stringify_keys
        )
      end
  
      def post_async(path:, parameters: nil)
        HttpRequestJob.perform_async(
          'post',
          uri(path:).to_s,
          parameters&.deep_stringify_keys,
          headers&.deep_stringify_keys
        )
      end
  
      def put_async(path:, parameters: nil)
        HttpRequestJob.perform_async(
          'put',
          uri(path:).to_s,
          parameters&.deep_stringify_keys,
          headers&.deep_stringify_keys
        )
      end
  
      def delete_async(path:, parameters: nil)
        HttpRequestJob.perform_async(
          'delete',
          uri(path:).to_s,
          parameters&.deep_stringify_keys,
          headers&.deep_stringify_keys
        )
      end
  
      def headers
        {
          'Content-Type': 'application/json'
        }
      end
  
      def uri_base
        throw NoMethodError.new("#{self.class.name} class should override `self.uri_base` method")
      end
  
      def uri(path:)
        throw StandardError, 'BaseApiService: URI Base should end with a trailing slash' unless uri_base.ends_with?('/')
        throw StandardError, 'BaseApiService: path should not start with a slash' if path.starts_with?('/')
        URI.join(uri_base, path)
      end
    end
  end
  