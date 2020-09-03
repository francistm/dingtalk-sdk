require "dingtalk_sdk/core"
require "dingtalk_sdk/request_url"

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
  end
end