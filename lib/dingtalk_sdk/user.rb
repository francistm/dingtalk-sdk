# frozen_string_literal: true

require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module User
    extend DingtalkSdk::Core

    # 获取用户详情
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/AaRQe}
    # @!method get_user_profile(userid:)
    # @return [Hash]
    add_request :get_user_profile, :get, DingtalkSdk::RequestUrl::GET_USER_PROFILE do |request|
      request.add_arg :userid, required: true, in: :query
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end

    # 根据 unionId 获取 userId
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/602f4b15}
    # @!method get_userid_by_unionid(unionid:)
    # @return [Hash]
    add_request :get_userid_by_unionid, :get, DingtalkSdk::RequestUrl::GET_USERID_FROM_UNIONID do |request|
      request.add_arg :unionid, required: true, in: :query
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end

    # 根据手机号获取 userId
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/soV11}
    # @!method get_userid_by_mobile(mobile:)
    # @return [Hash]
    add_request :get_userid_by_mobile, :get, DingtalkSdk::RequestUrl::GET_USERID_FROM_MOBILE do |request|
      request.add_arg :mobile, required: true, in: :query
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end
  end
end
