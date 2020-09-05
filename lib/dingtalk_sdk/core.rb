# frozen_string_literal: true

require 'json'
require 'httparty'
require 'active_support'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/deep_merge'

require 'dingtalk_sdk'

module DingtalkSdk
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

      def json?
        @format == :json
      end

      def x_form?
        @format == :x_form
      end

      def form_data?
        @format == :form_data
      end

      def arg_required?(arg_name)
        @required_args.include? arg_name
      end

      def body?
        !@body_args.empty? || !@body_const.empty?
      end

      def query?
        !@query_args.empty? || !@query_const.empty?
      end

      def body_const?
        !@body_const.empty?
      end

      def query_const?
        !@query_const.empty?
      end

      attr_writer :format

      def add_arg(arg_name, option)
        case option[:in]
        when :body
          @body_args << arg_name
        when :query
          @query_args << arg_name
        else
          raise DingtalkSdk::Error, "unknown argument '#{arg_name}' position"
        end

        @required_args << arg_name if option[:required]
      end

      def add_const(arg_name, value, option)
        const_hash = { arg_name => value }

        case option[:in]
        when :body
          @body_const.merge! const_hash
        when :query
          @query_const.merge! const_hash
        else
          raise DingtalkSdk::Error, "unknown argument '#{arg_name}' position"
        end
      end
    end

    protected

    def add_request(request_name, method, url)
      builder = RequestBuilder.new
      yield builder if block_given?

      define_method request_name do |method_args = {}|
        request_options = {}.tap do |h|
          builder.required_args.each do |arg|
            raise DingtalkSdk::Error, "missing required argument '#{arg}' when invoke request #{request_name}" \
              if method_args[arg].nil?
          end

          %i[body query].each do |arg_pos|
            h[arg_pos] = {} if builder.send(:"#{arg_pos}?")

            builder.send(:"#{arg_pos}_args").each do |arg_name|
              arg_value = method_args[arg_name]
              next if arg_pos == :query && arg_value.nil?

              h[arg_pos][arg_name] = arg_value
            end

            builder.send(:"#{arg_pos}_const").each do |arg_name, arg_value|
              h[arg_pos][arg_name] = if arg_value.respond_to?(:call)
                                       arg_value.call(self)
                                     else
                                       arg_value
                                     end
            end
          end

          if builder.form_data?
            h[:multipart] = true
          elsif builder.json?
            h[:body] = h[:body].to_json if h[:body].is_a?(Hash)
            h[:headers] = { "Content-Type": 'application/json' }
          end
        end

        response = HTTParty.send(method, url, **request_options)
        symbolized_response = JSON.parse(response.body).deep_symbolize_keys

        if symbolized_response[:errcode] != 0
          raise DingtalkSdk::RequestFailedError.new(
            code: symbolized_response[:errcode],
            message: symbolized_response[:errmsg]
          )
        end

        symbolized_response
      end
    end
  end
end
