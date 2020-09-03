RSpec.describe DingtalkSdk do
  it "has a version number" do
    expect(DingtalkSdk::VERSION).not_to be nil
  end

  # 测试样本见 https://ding-doc.dingtalk.com/doc#/faquestions/hxs5v9 底部
  it "sign correct timestamp with app_secret in personal login-free scenario" do
    timestamp = 1546084445901
    app_secret = "testappSecret"

    signature = DingtalkSdk.login_free_signature(app_secret, timestamp: timestamp)

    expect(signature).to be_a(DingtalkSdk::Signature)
    expect(signature.url_encoded).to eq("HCbG3xNE3vzhO%2Bu7qCUL1jS5hsu2n5r2cFhnTrtyDAE%3D")
  end
end
