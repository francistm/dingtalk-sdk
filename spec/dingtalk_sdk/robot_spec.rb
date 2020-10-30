# frozen_string_literal: true

require 'dingtalk_sdk'
require 'dingtalk_sdk/robot'

RSpec.describe DingtalkSdk::Robot do
  it 'should calculate correct signature' do
    timestamp = 1_603_868_410_000
    secret = 'this is secret'
    sign = DingtalkSdk::Robot.calculate_signature(secret, timestamp)

    expect(sign.url_encoded).to eq('3E1RZgQrn1ZLgQGU4C4n4SMei%2BObeZVym5BbqrwOJPs%3D')
  end
end
