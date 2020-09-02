require "json"
require "dingtalk/auth"

RSpec.describe Dingtalk::Auth do
  before :each do
    @int_user_id = 100
    @access_token = "mocked_access_token"
    @int_login_code = "mocked_int_login_code"

    response_body = {}.tap do |h|
      h[:userid] = @int_user_id
      h[:is_sys] = false
      h[:sys_level] = 0
    end

    stub_request(:get, /oapi.dingtalk.com\/user\/getuserinfo/)
      .with(query: { code: @int_login_code, access_token: @access_token })
      .to_return(status: 200, body: response_body.to_json)
  end

  it 'should get internal app user id' do
    response = Dingtalk::Auth.get_int_user_id code: @int_login_code, access_token: @access_token

    expect(response[:userid]).to eq(@int_user_id)
    expect(response[:is_sys]).to eq(false)
    expect(response[:sys_level]).to eq(0)
  end
end