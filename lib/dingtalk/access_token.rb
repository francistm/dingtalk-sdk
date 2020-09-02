require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module AccessToken
    class << self
      extend Dingtalk::Core

      # 获取 access_token
      # @url https://ding-doc.dingtalk.com/doc#/serverapi2/eev437
      add_request :get_access_token, :get, Dingtalk::RequestUrl::ACCESS_TOKEN do |request|
        request.add_arg :appkey, required: true, in: :query
        request.add_arg :appsecret, required: true, in: :query
      end
    end
  end
end