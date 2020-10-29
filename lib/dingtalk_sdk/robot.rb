# frozen_string_literal: true

require 'json'
require 'base64'
require 'openssl'
require 'dingtalk_sdk'
require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'
require 'active_support/core_ext/object'
require 'active_support/core_ext/integer'
require 'active_support/core_ext/time/zones'

module DingtalkSdk
  module Robot
    extend DingtalkSdk::Core

    def self.calculate_signature(secret, timestamp)
      raise ArgumentError, 'timestamp must in millis' if Math.log10(timestamp).ceil < 13

      origin_str = [timestamp, secret].join("\n")
      signature_str = OpenSSL::HMAC.digest('SHA256', secret, origin_str)
      signature_str_base64 = Base64.strict_encode64(signature_str)

      Signature.new(signature_str_base64)
    end

    def self.verify_signature(secret, signature, timestamp = Time.zone.now)
      return false if Time.zone.now - timestamp > 1.hour

      calculate_signature(secret, timestamp.to_i * 1000) == signature
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

      def at_mobile(mobile)
        @is_at_all = false
        @at_mobile_list = [*mobile]
      end

      def at_all
        @is_at_all = true
        @at_mobile_list = nil
      end

      def to_h
        {}.tap do |h|
          h.merge! @mesg

          if @is_at_all
            h[:isAtAll] = true
          elsif @at_mobile_list.try(:size).positive?
            h[:atMobiles] = @at_mobile_list
          end
        end
      end

      def to_json(*_args)
        JSON.generate to_h
      end
    end
  end
end
