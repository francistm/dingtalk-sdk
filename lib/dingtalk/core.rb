require "json"
require "httparty"
require "active_support"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/deep_merge"
require "dingtalk"
require "dingtalk/config"

module Dingtalk
  module Core
    class RequestBuilder
      attr_reader :query_args, :payload_args, :required_args

      def initialize
        @query_args = []
        @payload_args = []
        @required_args = []
        @with_key_and_secret = false
      end

      def with_key_and_secret!
        @with_key_and_secret = true
      end

      def with_key_and_secret?
        @with_key_and_secret
      end

      def is_arg_required?(arg_name)
        @required_args.include? arg_name
      end

      def add_arg(arg_name, option)
        case option[:in]
        when :query
          @query_args << arg_name
        when :payload
          @payload_args << arg_name
        else
          raise Dingtalk::Error.new("unknown argument position")
        end

        @required_args << arg_name if option[:required]
      end
    end

    # options
    #  with_key_secret 是否携带 appkey, appsecret 在请求 query 中
    def add_request(request_name, method, url)
      builder = RequestBuilder.new
      yield builder if block_given?

      define_method request_name do |method_args = {}|
        default_options = {
          query: {}
        }

        request_options = default_options.tap do |h|
          if builder.with_key_and_secret?
            h[:query].merge!({
              appkey: Dingtalk::Config.app_key,
              appsecret: Dingtalk::Config.app_secret,
            })
          end

          builder.required_args.each do |arg|
            raise Dingtalk::Error.new("missing required argument '#{arg}' when invoke request #{request_name}") \
              if method_args[arg].nil?
          end

          builder.query_args.each do |arg|
            h[:query][arg] = method_args[arg] unless method_args[arg].nil?
          end

          builder.payload_args.each do |arg|
          end
        end

        response = HTTParty.send(method, url, **request_options)

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end