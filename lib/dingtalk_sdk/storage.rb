require 'dingtalk_sdk/core'
require 'dingtalk_sdk/request_url'

module DingtalkSdk
  module Storage
    extend DingtalkSdk::Core

    # 上传媒体文件
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/bcmg0i/08d5a73b}
    # @!method upload_media(type:, access_token:, media:)
    # @return [Hash]
    add_request :upload_media, :post, DingtalkSdk::RequestUrl::UPLOAD_MEDIA_FILE do |request|
      request.add_arg :type, in: query, required: true
      request.add_arg :access_token, in: :query, required: true
      request.add_arg :media, in: :body, required: true
    end
  end
end