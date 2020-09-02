require "json"
require "httparty"
require "active_support"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/deep_merge"
require "dingtalk"

module Dingtalk
  module Core
    class RequestBuilder
      attr_reader :query_args, :body_args, :required_args

      def initialize
        @is_json = false

        @body_args = []
        @query_args = []
        @required_args = []
        @with_key_and_secret = false
      end

      def is_json?
        @is_json
      end

      def is_arg_required?(arg_name)
        @required_args.include? arg_name
      end

      def has_body_args?
        !@body_args.empty?
      end

      def has_query_args?
        !@query_args.empty?
      end

      def is_json=(b)
        @is_json = b
      end

      def add_arg(arg_name, option)
        case option[:in]
        when :body
          @body_args << arg_name
        when :query
          @query_args << arg_name
        else
          raise Dingtalk::Error.new("unknown argument position")
        end

        @required_args << arg_name if option[:required]
      end
    end

    def add_request(request_name, method, url)
      builder = RequestBuilder.new
      yield builder if block_given?

      define_method request_name do |method_args = {}|
        request_options = {}.tap do |h|
          builder.required_args.each do |arg|
            raise Dingtalk::Error.new("missing required argument '#{arg}' when invoke request #{request_name}") \
              if method_args[arg].nil?
          end

          h[:body] = {} if builder.has_body_args?
          h[:query] = {} if builder.has_query_args?

          builder.body_args.each do |arg|
            h[:body][arg] = method_args[arg]
          end

          builder.query_args.each do |arg|
            h[:query][arg] = method_args[arg] unless method_args[arg].nil?
          end

          if builder.is_json?
            h[:body] = h[:body].to_json
            h[:headers] = {:"Content-Type" => "application/json"} if builder.is_json?
          end
        end

        response = HTTParty.send(method, url, **request_options)

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end