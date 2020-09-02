module Dingtalk
  module RequestUrl
    # 获取 AccessToken
    ACCESS_TOKEN = "https://oapi.dingtalk.com/gettoken".freeze

    # 企业内应用免登录获取用户ID
    # https://ding-doc.dingtalk.com/doc#/serverapi2/clotub
    GET_USER_INFO = "https://oapi.dingtalk.com/user/getuserinfo".freeze

    # 服务端通过临时授权码获取授权用户的个人信息
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr
    GET_USER_INFO_SNS = "https://oapi.dingtalk.com/sns/getuserinfo_bycode".freeze
  end
end