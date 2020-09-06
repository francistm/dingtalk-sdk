# frozen_string_literal: true

require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module Storage
    extend DingtalkSdk::Core

    # 上传媒体文件
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/bcmg0i/08d5a73b}
    # @!method upload_media(type:, media:)
    # @return [Hash]
    add_request :upload_media, :post, DingtalkSdk::RequestUrl::UPLOAD_MEDIA_FILE do |request|
      request.add_arg :type, in: query, required: true
      request.add_arg :media, in: :body, required: true

      request.add_const :access_token, ->(r) { r.cached_access_token }, in: :query
    end
  end
end
