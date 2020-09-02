require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module AccessToken
    extend Dingtalk::Core

    # 获取 access_token
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/eev437}
    add_request :get_access_token, :get, Dingtalk::RequestUrl::ACCESS_TOKEN do |request|
      request.add_const :appkey, ->(r) { r.app_key }, in: :query
      request.add_const :appsecret, ->(r) { r.app_secret }, in: :query
    end
  end
end