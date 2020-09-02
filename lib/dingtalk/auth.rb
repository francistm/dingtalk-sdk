require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module Auth
    class << self
      extend Dingtalk::Core

      # 企业内部应用免登录 用户ID获取
      # @url https://ding-doc.dingtalk.com/doc#/serverapi2/clotub
      add_request :get_int_login_free_user_id, :get, Dingtalk::RequestUrl::INT_LOGIN_FREE_GET_USER_INFO do |request|
        request.add_arg :code, required: true, in: :query
        request.add_arg :access_token, required: true, in: :query
      end

      # 钉钉内免登录第三方网站 个人信息获取
      # @url https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr
      add_request :get_3rd_login_free_user_profile, :post, Dingtalk::RequestUrl::GET_USER_INFO_SNS do |request|
        request.is_json = true

        request.add_arg :accessKey, required: true, in: :query
        request.add_arg :timestamp, required: true, in: :query
        request.add_arg :signature, required: true, in: :query

        request.add_arg :tmp_auth_code, required: true, in: :body
      end
    end
  end
end