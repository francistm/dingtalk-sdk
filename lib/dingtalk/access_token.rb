require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module AccessToken
    class << self
      extend Dingtalk::Core

      # 获取 access_token
      # @url https://ding-doc.dingtalk.com/doc#/serverapi2/eev437
      add_request :get_access_token, :get, Dingtalk::RequestUrl::ACCESS_TOKEN do |request|
        request.with_key_and_secret!
      end
    end
  end
end