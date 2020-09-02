require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module User
    extend Dingtalk::Core

    # 获取用户详情
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/AaRQe
    add_request :get_user_profile, :get, Dingtalk::RequestUrl::GET_USER_PROFILE do |request|
      request.add_arg :userid, required: true, in: :query
      request.add_arg :access_token, required: true, in: :query
    end

    # 根据 unionId 获取 userId
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/602f4b15
    add_request :get_userid_by_unionid, :get, Dingtalk::RequestUrl::GET_USERID_FROM_UNIONID  do |request|
      request.add_arg :unionid, required: true, in: :query
      request.add_arg :access_token, required: true, in: :query
    end

    # 根据手机号获取 userId
    # @url https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/soV11
    add_request :get_userid_by_mobile, :get, Dingtalk::RequestUrl::GET_USERID_FROM_MOBILE do |request|
      request.add_arg :mobile, required: true, in: :query
      request.add_arg :access_token, required: true, in: :query
    end
  end
end