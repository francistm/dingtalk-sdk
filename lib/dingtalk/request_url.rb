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

    # 获取用户详情
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/AaRQe
    GET_USER_PROFILE = "https://oapi.dingtalk.com/user/get"

    # 通过 unionId 获取 userId
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/602f4b15
    GET_USERID_FROM_UNIONID = "https://oapi.dingtalk.com/user/getUseridByUnionid"

    # 根据手机号获取 userId
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/soV11
    GET_USERID_FROM_MOBILE = "https://oapi.dingtalk.com/user/get_by_mobile"
  end
end