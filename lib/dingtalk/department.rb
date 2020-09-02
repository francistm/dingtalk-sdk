require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module Department
    extend Dingtalk::Core

    # 获取部门列表
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/e6e1604e}
    add_request :get_department_list, :get, RequestUrl::GET_DEPARTMENT_LIST do |request|
      request.add_arg :id, in: :query           # 父部门id（如果不传，默认部门为根部门，根部门ID为1）
      request.add_arg :fetch_child, in: :query  # 是否递归部门的全部子部门
      request.add_arg :access_token, required: true, in: :query
    end

    # 获取部门详情
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/5bf960de}
    add_request :get_department_profile, :get, RequestUrl::GET_DEPARTMENT_PROFILE do |request|
      request.add_arg :id, in: :query, required: true
      request.add_arg :access_token, in: :query, required: true
    end
  end
end