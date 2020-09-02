require "dingtalk/core"
require "dingtalk/request_url"
require "active_support/core_ext/object/to_query"

module Dingtalk
  module Auth
    extend Dingtalk::Core

    # 企业内部应用免登录 用户ID获取
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/clotub
    add_request :get_int_login_free_user_id, :get, Dingtalk::RequestUrl::INT_LOGIN_FREE_GET_USER_INFO do |request|
      request.add_arg :code, required: true, in: :query
      request.add_arg :access_token, required: true, in: :query
    end

    # 生成扫码登录跳转地址
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/kymkv6
    def get_qr_connect_uri(redirect_uri, state = "")
      qs = {}.tap do |h|
        h[:appid] = @app_key
        h[:response_type] = "code"
        h[:scope] = "snsapi_login"
        h[:state] = state
        h[:redirect_uri] = redirect_uri
      end

      "#{Dingtalk::RequestUrl::CONNECT_QR_REDIRECT}?#{qs.to_query}"
    end

    # 钉钉内免登录第三方网站 个人信息获取
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr
    add_request :get_3rd_login_free_user_profile, :post, Dingtalk::RequestUrl::GET_USER_INFO_SNS do |request|
      request.format = :json

      request.add_arg :accessKey, required: true, in: :query
      request.add_arg :timestamp, required: true, in: :query
      request.add_arg :signature, required: true, in: :query

      request.add_arg :tmp_auth_code, required: true, in: :body
    end
  end
end