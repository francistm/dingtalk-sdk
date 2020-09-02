require "dingtalk/core"
require "dingtalk/request_url"

module Dingtalk
  module Auth
    class << self
      extend Dingtalk::Core

      # 企业内部应用免登
      # @url https://ding-doc.dingtalk.com/doc#/serverapi2/clotub
      add_request :get_int_user_id, :get, Dingtalk::RequestUrl::GET_USER_INFO do |request|
        request.add_arg :code, required: true, in: :query
        request.add_arg :access_token, required: true, in: :query
      end
    end
  end
end