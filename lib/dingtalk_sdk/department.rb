# frozen_string_literal: true

require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module Department
    extend DingtalkSdk::Core

    # 获取部门列表
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/e6e1604e}
    # @!method get_department_list(id:, fetch_child:)
    # @return [Hash]
    add_request :get_department_list, :get, DingtalkSdk::RequestUrl::GET_DEPARTMENT_LIST do |request|
      request.add_arg :id, in: :query           # 父部门id（如果不传，默认部门为根部门，根部门ID为1）
      request.add_arg :fetch_child, in: :query  # 是否递归部门的全部子部门
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end

    # 获取部门详情
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/5bf960de}
    # @!method get_department_profile(id:)
    # @return [Hash]
    add_request :get_department_profile, :get, DingtalkSdk::RequestUrl::GET_DEPARTMENT_PROFILE do |request|
      request.add_arg :id, in: :query, required: true
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end
  end
end
