# frozen_string_literal: true

require 'uri'
require 'base64'
require 'openssl'

require 'dingtalk_sdk/version'
require 'dingtalk_sdk/auth'
require 'dingtalk_sdk/user'
require 'dingtalk_sdk/department'
require 'dingtalk_sdk/access_token'
require 'dingtalk_sdk/corp_conversation'

module DingtalkSdk
  class Error < StandardError; end

  class RequestFailedError < Error
    attr_reader :code, :message

    def initialize(code:, message:)
      @code = code
      @message = message
    end
  end

  class Signature
    def initialize(signature)
      @signature = signature
    end

    def to_s
      @signature
    end

    def url_encoded
      URI.encode_www_form_component @signature
    end
  end

  class Request
    include Auth
    include User
    include Department
    include AccessToken
    include CorpConversation

    attr_reader :agent_id, :app_key, :app_secret

    def initialize(agent_id:, app_key:, app_secret:)
      @agent_id = agent_id
      @app_key = app_key
      @app_secret = app_secret
    end
  end

  class << self
    # 个人免登录场景的签名计算
    # {https://ding-doc.dingtalk.com/doc#/faquestions/hxs5v9}
    # timestamp 用于计算的时间戳 如果不提供，表示当前时间
    # url_encode 是否对最终结果进行 rfc2396 转义
    def login_free_signature(app_secret, options = {})
      default_options = {
        timestamp: nil,
        url_encode: true
      }

      options = default_options.merge(options)

      timestamp = if options[:timestamp].nil?
                    (Time.now.localtime('+08:00').to_f * 1000).to_i
                  else
                    options[:timestamp]
                  end

      signature_str = OpenSSL::HMAC.digest('SHA256', app_secret, timestamp.to_s)
      signature_str_base64 = Base64.encode64(signature_str).strip

      Signature.new(signature_str_base64)
    end
  end
end
