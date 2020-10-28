# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'dingtalk_sdk'
require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'
require 'active_support/core_ext/time/zones'

module DingtalkSdk
  module Robot
    extend DingtalkSdk::Core

    def self.calculate_signature(secret, timestamp = nil)
      timestamp = Time.zone.now.to_i if timestamp.nil?

      origin_str = [timestamp * 1000, secret].join("\n")
      signature_str = OpenSSL::HMAC.digest('SHA256', secret, origin_str)
      signature_str_base64 = Base64.strict_encode64(signature_str)

      Signature.new(signature_str_base64)
    end
  end
end
