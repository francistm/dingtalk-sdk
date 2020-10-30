# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'dingtalk_sdk'
require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'
require 'active_support/core_ext/object'
require 'active_support/core_ext/integer'

module DingtalkSdk
  module Robot
    extend DingtalkSdk::Core

    class << self
      # 计算签名
      # timestamp 为毫秒单位
      # @return [DingtalkSdk::Signature]
      def calculate_signature(secret, timestamp)
        raise ArgumentError, 'timestamp must in millis' if Math.log10(timestamp).ceil < 13

        origin_str = [timestamp, secret].join("\n")
        signature_str = OpenSSL::HMAC.digest('SHA256', secret, origin_str)
        signature_str_base64 = Base64.strict_encode64(signature_str)

        Signature.new(signature_str_base64)
      end

      # 验证一个签名是否有效
      # @option timestamp 时间戳
      # @option url_encoded 签名是否经过 url encode
      # @option verify_timestamp 验证签名是否在有效时间段内 （1小时)
      # @return [Boolean]
      def verify_signature(secret, expected_signature, options = {})
        options.with_defaults!(
          timestamp: Time.now.to_i * 1000,
          url_encoded: false,
          verify_timestamp: true
        )

        if options[:verify_signature]
          datetime_timestamp = Time.at(options[:timestamp] / 1000)
          return false if Time.now - datetime_timestamp > 1.hour
        end

        actually_signature = calculate_signature(secret, options[:timestamp])
        expected_signature == if options[:url_encoded]
                                actually_signature.url_encoded
                              else
                                actually_signature.to_s
                              end
      end
    end

    class MessageBuilder
      def initialize
        @mesg = nil
        @is_at_all = false
        @at_mobile_list = nil
      end

      def text(text:)
        @mesg = {
          msgtype: 'text',
          text: { content: text }
        }
      end

      def markdown(title:, text:)
        @mesg = {
          msgtype: 'markdown',
          markdown: {
            title: title,
            text: text
          }
        }
      end

      def action_card_entire_link(title:, text:, single_title:, single_url:, btn_orientation: '0')
        raise ArgumentError, 'btn_orientation only accept 0 or 1' unless %w[0 1].include?(btn_orientation)

        @mesg = {
          msgtype: 'actionCard',
          actionCard: {
            title: title,
            text: text,
            singleTitle: single_title,
            singleURL: single_url,
            btnOrientation: btn_orientation
          }
        }
      end

      def action_card_separate_link(title:, text:, btn_orientation: '0', btns:)
        raise ArgumentError, 'btn_orientation only accept 0 or 1' unless %w[0 1].include?(btn_orientation)
        raise ArgumentError, 'btns must be an array of hash with title and actionURL' \
          unless btns.all? { |i| (%i[title actionURL] & [*i.try(:keys)]).any? }

        @mesg = {
          msgtype: 'actionCard',
          actionCard: {
            title: title,
            text: text,
            btnOrientation: btn_orientation,
            btns: [*btns]
          }
        }
      end

      def feed_card(links:)
        @mesg = {
          msgtype: 'feedCard',
          feedCard: {
            links: links
          }
        }
      end

      def at_mobiles(mobiles)
        @is_at_all = false
        @at_mobile_list = [*mobiles].map(&:to_s).uniq
      end

      def at_all
        @is_at_all = true
        @at_mobile_list = nil
      end

      def to_h
        {}.tap do |h|
          h.merge! @mesg

          if @is_at_all
            h[:at] = { isAtAll: true }
          elsif @at_mobile_list.try(:size).try(:positive?)
            h[:at] = { isAtAll: false, atMobiles: @at_mobile_list }
          end
        end
      end
    end
  end
end
