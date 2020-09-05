# frozen_string_literal: true

require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module AccessToken
    extend DingtalkSdk::Core

    # 获取 access_token
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/eev437}
    # @!method get_access_token
    # @return [Hash]
    add_request :get_access_token, :get, DingtalkSdk::RequestUrl::ACCESS_TOKEN do |request|
      request.add_const :appkey, ->(r) { r.app_key }, in: :query
      request.add_const :appsecret, ->(r) { r.app_secret }, in: :query
    end

    # 获取缓存的 access_token
    # 通过 Request.set_access_token_cache_method 定义缓存方法
    # @return [Hash]
    def cached_access_token
      method_name = :@@ak_cache_method

      unless self.class.class_variable_defined? method_name
        raise DingtalkSdk::Error, 'access_token cache method not found'
      end

      self.class.class_variable_get(method_name).call(agent_id, app_key, app_secret)
    end

    module ClassMethods
      def set_access_token_cache_method
        raise ArgumentError, 'invalid access_token cache method' unless block_given?

        class_variable_set :@@ak_cache_method, ->(agent_id, app_key, app_secret) { yield(agent_id, app_key, app_secret) }
      end

      def unset_access_token_cache_method
        remove_class_variable :@@ak_cache_method if class_variable_defined?(AK_CACHE_METHOD_NAME)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
