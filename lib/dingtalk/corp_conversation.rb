require 'dingtalk/core'
require 'dingtalk/request_url'

module Dingtalk
  module CorpConversation
    extend Dingtalk::Core

    # 发送工作通知消息
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy}
    add_request :send_corp_conversation, :post, Dingtalk::RequestUrl::SEND_CORP_CONVERSATION do |request|
      request.add_arg :agent_id, in: :body, required: true
      request.add_arg :userid_list, in: :body
      request.add_arg :dept_id_list, in: :body
      request.add_arg :to_all_user, in: :body
      request.add_arg :msg, in: :body

      request.add_arg :access_token, in: :query, required: true
    end

    # 查询工作通知消息的发送进度
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/e2262dad}
    add_request :get_corp_conversation_progress, :post, Dingtalk::RequestUrl::CORP_CONVERSATION_SEND_PROGRESS do |request|
      request.add_arg :agent_id, in: :body, required: true
      request.add_arg :task_id, in: :body, required: true

      request.add_arg :access_token, in: :query, required: true
    end

    # 查询工作通知消息的发送结果
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/a5920210}
    add_request :get_corp_conversation_result, :post, Dingtalk::RequestUrl::CORP_CONVERSATION_SEND_RESULT do |request|
      request.add_arg :agent_id, in: :body, required: true
      request.add_arg :task_id, in: :body, required: true

      request.add_arg :access_token, in: :query, required: true
    end

    # 工作通知消息撤回
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/hYyV8}
    add_request :recall_corp_conversation, :post, Dingtalk::RequestUrl::RECALL_CORP_CONVERSATION do |request|
      request.add_arg :agent_id, in: :body, required: true
      request.add_arg :msg_task_id, in: :body, required: true

      request.add_arg :access_token, in: :query, required: true
    end
  end
end