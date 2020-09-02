require "dingtalk/config"

RSpec.describe Dingtalk::Config do
  before :each do
    @app_key = "ci_dingtalk_app_key"
    @app_secret = "ci_dingtalk_app_secret"
  end

  it "can set and read config singleton" do
    Dingtalk::Config.app_key = @app_key
    Dingtalk::Config.app_secret = @app_secret

    expect(Dingtalk::Config.app_key).to eq(@app_key)
    expect(Dingtalk::Config.app_secret).to eq(@app_secret)
  end
end