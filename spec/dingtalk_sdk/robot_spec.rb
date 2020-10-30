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

  it 'should return true in verify_signature' do
    timestamp = 1_603_868_410_000
    secret = 'this is secret'
    signature = '3E1RZgQrn1ZLgQGU4C4n4SMei+ObeZVym5BbqrwOJPs='

    is_valid = DingtalkSdk::Robot.verify_signature(
      secret,
      signature,
      {
        timestamp: timestamp,
        url_encoded: false,
        verify_timestamp: false
      }
    )

    expect(is_valid).to be_truthy
  end

  describe DingtalkSdk::Robot::MessageBuilder do
    it 'should compose text message' do
      builder = DingtalkSdk::Robot::MessageBuilder.new
      builder.text text: 'hello world'
      mesg_h = builder.to_h

      expect(mesg_h[:msgtype]).to eq('text')
      expect(mesg_h[:text][:content]).to eq('hello world')
      expect(mesg_h[:at]).to be_nil
    end

    it 'should compose message with at all' do
      builder = DingtalkSdk::Robot::MessageBuilder.new
      builder.text text: 'hello world'
      builder.at_all
      mesg_h = builder.to_h

      expect(mesg_h[:at][:isAtAll]).to be_truthy
      expect(mesg_h[:at][:atMobiles]).to be_nil
    end

    it 'should compose message with at mobiles' do
      builder = DingtalkSdk::Robot::MessageBuilder.new
      builder.text text: 'hello world'
      builder.at_mobiles [123, 456]
      mesg_h = builder.to_h

      expect(mesg_h[:at][:isAtAll]).to be_falsey
      expect(mesg_h[:at][:atMobiles]).to eq(%w[123 456])
    end
  end
end
