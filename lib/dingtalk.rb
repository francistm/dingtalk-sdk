require 'uri'
require 'base64'
require 'openssl'
require "dingtalk/version"

require "dingtalk/auth"
require "dingtalk/user"
require "dingtalk/department"
require "dingtalk/access_token"
require "dingtalk/corp_conversation"

module Dingtalk
  class Error < StandardError
  end

  class Signature
    def initialize(s)
      @signature = s
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

    attr_reader :app_key, :app_secret

    def initialize(app_key:, app_secret:)
      @app_key, @app_secret = app_key, app_secret
    end
  end

  class << self
    # 个人免登录场景的签名计算
    # @url https://ding-doc.dingtalk.com/doc#/faquestions/hxs5v9
    # timestamp 用于计算的时间戳 如果不提供，表示当前时间
    # url_encode 是否对最终结果进行 rfc2396 转义
    def login_free_signature(app_secret, options = {})
      default_options = {
        timestamp: nil,
        url_encode: true,
      }

      options = default_options.merge(options)

      timestamp = unless options[:timestamp].nil?
        options[:timestamp]
      else
        (Time.now.localtime("+08:00").to_f * 1000).to_i
      end

      signature_str = OpenSSL::HMAC.digest("SHA256", app_secret, timestamp.to_s)
      signature_str_base64 = Base64.encode64(signature_str).strip

      Signature.new(signature_str_base64)
    end
  end
end
