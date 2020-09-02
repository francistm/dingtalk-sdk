require "json"
require "dingtalk/auth"

RSpec.describe Dingtalk::Auth do
  before :each do
    @app_key = "mocked_app_key"
    @app_secret = "mocked_app_secret"

    @int_user_id = 100
    @access_token = "mocked_access_token"
    @int_login_code = "mocked_int_login_code"
    @timestamp = (Time.now.localtime("+08:00").to_f * 1000).to_i

    @signature = Dingtalk.login_free_signature(@app_secret, timestamp: @timestamp)

    # 企业内部免登 响应结果
    get_user_info_response_body = {}.tap do |h|
      h[:userid] = @int_user_id
      h[:is_sys] = false
      h[:sys_level] = 0
    end

    # 钉钉内免登第三方网站 响应结果
    get_user_info_by_code_response_body = {}.tap do |h|
      h[:errcode] = 0
      h[:errmsg] = "ok"
      h[:user_info] = {
        nick: "张三",
        openid: "liSii8KCxxxxx",
        unionid: "7Huu46kk"
      }
    end

    stub_request(:get, /oapi.dingtalk.com\/user\/getuserinfo/)
      .with(query: { code: @int_login_code, access_token: @access_token })
      .to_return(status: 200, body: get_user_info_response_body.to_json)

    stub_request(:post, /oapi.dingtalk.com\/sns\/getuserinfo_bycode/)
      .with(
        query: { accessKey: @app_key, timestamp: @timestamp.to_s, signature: @signature.to_s },
        body: { tmp_auth_code: "23152698ea18304da4d0ce1xxxxx" }.to_json,
        headers: { :"Content-Type" => "application/json" }
      )
      .to_return(status: 200, body: get_user_info_by_code_response_body.to_json)
  end

  it 'should get user id in internal app login-free scenario' do
    response = Dingtalk::Auth.get_int_login_free_user_id(
      code: @int_login_code,
      access_token: @access_token,
    )

    expect(response[:userid]).to eq(@int_user_id)
    expect(response[:is_sys]).to eq(false)
    expect(response[:sys_level]).to eq(0)
  end

  # 详情见 https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr
  it 'should get user profile through temp auth code in login-free scenario' do
    response = Dingtalk::Auth.get_3rd_login_free_user_profile(
      accessKey: @app_key,
      timestamp: @timestamp,
      signature: @signature.to_s,
      tmp_auth_code: "23152698ea18304da4d0ce1xxxxx"
    )

    expect(response[:user_info]).to be_a(Hash)
    expect(response[:user_info][:nick]).to eq("张三")
    expect(response[:user_info][:openid]).to eq("liSii8KCxxxxx")
    expect(response[:user_info][:unionid]).to eq("7Huu46kk")
  end
end