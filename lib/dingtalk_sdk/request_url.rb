# frozen_string_literal: true

module DingtalkSdk
  module RequestUrl
    # 获取 AccessToken
    ACCESS_TOKEN = 'https://oapi.dingtalk.com/gettoken'

    # 扫码登录第三方网站 OAuth 跳转地址
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/kymkv6}
    CONNECT_QR_REDIRECT = 'https://oapi.dingtalk.com/connect/qrconnect'

    # 企业内应用免登录获取用户ID
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/clotub}
    INT_LOGIN_FREE_GET_USER_INFO = 'https://oapi.dingtalk.com/user/getuserinfo'

    # 服务端通过临时授权码获取授权用户的个人信息
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/etaarr}
    GET_USER_INFO_SNS = 'https://oapi.dingtalk.com/sns/getuserinfo_bycode'

    # 获取用户详情
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/AaRQe}
    GET_USER_PROFILE = 'https://oapi.dingtalk.com/user/get'

    # 通过 unionId 获取 userId
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/602f4b15}
    GET_USERID_FROM_UNIONID = 'https://oapi.dingtalk.com/user/getUseridByUnionid'

    # 根据手机号获取 userId
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/ege851/soV11}
    GET_USERID_FROM_MOBILE = 'https://oapi.dingtalk.com/user/get_by_mobile'

    # 获取部门列表
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/e6e1604e}
    GET_DEPARTMENT_LIST = 'https://oapi.dingtalk.com/department/list'

    # 获取部门详情
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/dubakq/5bf960de}
    GET_DEPARTMENT_PROFILE = 'https://oapi.dingtalk.com/department/get'

    # 发送工作通知消息
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy}
    SEND_CORP_CONVERSATION = 'https://oapi.dingtalk.com/topapi/message/corpconversation/asyncsend_v2'

    # 查询工作通知消息的发送进度
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/e2262dad}
    CORP_CONVERSATION_SEND_PROGRESS = 'https://oapi.dingtalk.com/topapi/message/corpconversation/getsendprogress'

    # 查询工作通知消息的发送结果
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/a5920210}
    CORP_CONVERSATION_SEND_RESULT = 'https://oapi.dingtalk.com/topapi/message/corpconversation/getsendresult'

    # 工作通知消息撤回
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/pgoxpy/hYyV8}
    RECALL_CORP_CONVERSATION = 'https://oapi.dingtalk.com/topapi/message/corpconversation/recall'

    # 上传媒体文件
    # {https://ding-doc.dingtalk.com/doc#/serverapi2/bcmg0i/08d5a73b}
    UPLOAD_MEDIA_FILE = 'https://oapi.dingtalk.com/media/upload'
  end
end
