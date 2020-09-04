# frozen_string_literal: true

require 'json'
require 'dingtalk_sdk'
require 'dingtalk_sdk/access_token'

RSpec.describe DingtalkSdk::AccessToken do
  before :each do
    @agent_id = 'mocked_agent_id'
    @app_key = 'mocked_app_key'
    @app_secret = 'mocked_app_secret'
    @mocked_access_token = 'mocked_access_token'

    @dingtalk_request = DingtalkSdk::Request.new(
      agent_id: @agent_id,
      app_key: @app_key,
      app_secret: @app_secret
    )

    response_body = {}.tap do |h|
      h[:errcode] = 0
      h[:errmsg] = 0
      h[:access_token] = @mocked_access_token
    end

    stub_request(:get, /oapi.dingtalk.com/)
      .with(query: { appkey: @app_key, appsecret: @app_secret })
      .to_return(status: 200, body: response_body.to_json)
  end

  it 'should return correct access_token from request' do
    response = @dingtalk_request.get_access_token

    expect(response[:access_token]).to eq(@mocked_access_token)
  end
end
