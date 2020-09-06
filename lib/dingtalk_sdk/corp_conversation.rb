# frozen_string_literal: true

require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module CorpConversation
    extend DingtalkSdk::Core

    # 发送工作通知消息
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy}
    # @!method send_corp_conversation(userid_list:, dept_id_list:, to_all_user:, msg:, access_token:)
    # @return [Hash]
    add_request :send_corp_conversation, :post, DingtalkSdk::RequestUrl::SEND_CORP_CONVERSATION do |request|
      request.add_arg :userid_list, in: :body
      request.add_arg :dept_id_list, in: :body
      request.add_arg :to_all_user, in: :body
      request.add_arg :msg, in: :body

      request.add_arg :access_token, in: :query, required: true

      request.add_const :agent_id, ->(r) { r.agent_id }, in: :body
    end

    # 查询工作通知消息的发送进度
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/e2262dad}
    # @!method get_corp_conversation_progress(task_id:, access_token:)
    # @return [Hash]
    add_request :get_corp_conversation_progress, :post, DingtalkSdk::RequestUrl::CORP_CONVERSATION_SEND_PROGRESS do |request|
      request.add_arg :task_id, in: :body, required: true

      request.add_const :agent_id, ->(r) { r.agent_id }, in: :body
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end

    # 查询工作通知消息的发送结果
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/a5920210}
    # @!method get_corp_conversation_result(task_id:, access_token:)
    # @return [Hash]
    add_request :get_corp_conversation_result, :post, DingtalkSdk::RequestUrl::CORP_CONVERSATION_SEND_RESULT do |request|
      request.add_arg :task_id, in: :body, required: true

      request.add_const :agent_id, ->(r) { r.agent_id }, in: :body
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end

    # 工作通知消息撤回
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/hYyV8}
    # @!method recall_corp_conversation(msg_task_id:, access_token:)
    # @return [Hash]
    add_request :recall_corp_conversation, :post, DingtalkSdk::RequestUrl::RECALL_CORP_CONVERSATION do |request|
      request.add_arg :msg_task_id, in: :body, required: true

      request.add_const :agent_id, ->(r) { r.agent_id }, in: :body
      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end
  end
end
