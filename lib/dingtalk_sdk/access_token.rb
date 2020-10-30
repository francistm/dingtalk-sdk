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
    # 如果未设置 会自动调用 get_access_token 获取一个新的 access_token
    # 通过 Request.set_access_token_cache_method 定义缓存方法
    # @return [Hash]
    def cached_access_token
      var_name = :@ak_cache_method

      return get_access_token unless self.class.instance_variable_defined?(var_name)

      self.class.instance_variable_get(var_name).call(self)
    end

    module ClassMethods
      def set_access_token_cache_method
        raise ArgumentError, 'invalid access_token cache method' unless block_given?

        @ak_cache_method = ->(request) { yield request }
      end

      def unset_access_token_cache_method
        var_name = :@ak_cache_method
        remove_instance_variable(var_name) if instance_variable_defined?(var_name)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
