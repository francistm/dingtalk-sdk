# frozen_string_literal: true

module Dingtalk
  module RequestUrl
    # 获取 AccessToken
    ACCESS_TOKEN = "https://oapi.dingtalk.com/gettoken"

    # 扫码登录第三方网站 OAuth 跳转地址
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/kymkv6
    CONNECT_QR_REDIRECT = "https://oapi.dingtalk.com/connect/qrconnect"

    # 企业内应用免登录获取用户ID
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/clotub
    INT_LOGIN_FREE_GET_USER_INFO = "https://oapi.dingtalk.com/user/getuserinfo"

    # 服务端通过临时授权码获取授权用户的个人信息
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr
    GET_USER_INFO_SNS = "https://oapi.dingtalk.com/sns/getuserinfo_bycode"
  end
end