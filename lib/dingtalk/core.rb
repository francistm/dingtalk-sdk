require "json"
require "httparty"
require "active_support"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/deep_merge"
require "dingtalk"

module Dingtalk
  module Core
    class RequestBuilder
      attr_reader :query_args, :body_args, :query_const, :body_const, :required_args

      def initialize
        @format = nil

        @body_args = []
        @query_args = []
        @required_args = []

        @body_const = {}
        @query_const = {}
      end

      def is_json?
        @format == :json
      end

      def is_x_form?
        @format == :x_form
      end

      def is_form_data?
        @format == :form_data
      end

      def is_arg_required?(arg_name)
        @required_args.include? arg_name
      end

      def has_body?
        !@body_args.empty? || !@body_const.empty?
      end

      def has_query?
        !@query_args.empty? || !@query_const.empty?
      end

      def has_body_const?
        !@body_const.empty?
      end

      def has_query_const?
        !@query_const.empty?
      end

      def format=(format)
        @format = format
      end

      def add_arg(arg_name, option)
        case option[:in]
        when :body
          @body_args << arg_name
        when :query
          @query_args << arg_name
        else
          raise Dingtalk::Error.new("unknown argument '#{arg_name}' position")
        end

        @required_args << arg_name if option[:required]
      end

      def add_const(arg_name, value, option)
        const_hash = {arg_name => value}

        case option[:in]
        when :body
          @body_const.merge! const_hash
        when :query
          @query_const.merge! const_hash
        else
          raise Dingtalk::Error.new("unknown argument '#{arg_name}' position")
        end
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

          [:body, :query].each do |arg_pos|
            h[arg_pos] = {} if builder.send(:"has_#{arg_pos}?")

            builder.send(:"#{arg_pos}_args").each do |arg_name|
              arg_value = method_args[arg_name]
              next if arg_pos == :query && arg_value.nil?
              h[arg_pos][arg_name] = arg_value
            end

            builder.send(:"#{arg_pos}_const").each do |arg_name, arg_value|
              if arg_value.respond_to?(:call)
                h[arg_pos][arg_name] = arg_value.call(self)
              else
                h[arg_pos][arg_name] = arg_value
              end
            end
          end

          if builder.is_form_data?
            h[:multipart] = true
          elsif builder.is_json?
            h[:body] = h[:body].to_json if Hash === h[:body]
            h[:headers] = {:"Content-Type" => "application/json"}
          end
        end

        response = HTTParty.send(method, url, **request_options)

        JSON.parse(response.body).deep_symbolize_keys
      end
    end
  end
end