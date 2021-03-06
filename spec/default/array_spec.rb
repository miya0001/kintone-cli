# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'
require 'shell'

describe KCLI::Array do

  it "Kintone style array to be key/value style array" do
    before = <<-'JSON'
    [
      {
        "活動履歴": {
          "type": "SUBTABLE",
          "value": [
            {
              "id": "142",
              "value": {
                "文字列__1行__5": {
                  "type": "SINGLE_LINE_TEXT",
                  "value": "導入相談に申し込みあり。電話にて現状・要件のヒアリングを行った。"
                },
                "ドロップダウン_0": {
                  "type": "DROP_DOWN",
                  "value": "導入相談"
                },
                "添付ファイル": {
                  "type": "FILE",
                  "value": []
                },
                "日付_0": {
                  "type": "DATE",
                  "value": "2014-08-01"
                }
              }
            },
            {
              "id": "143",
              "value": {
                "文字列__1行__5": {
                  "type": "SINGLE_LINE_TEXT",
                  "value": "ハンズオンセミナーに来場いただき、実際の画面をみながらご説明。担当者の反応はよく、社内提案のための資料提供などのサポートをしていく。"
                },
                "ドロップダウン_0": {
                  "type": "DROP_DOWN",
                  "value": "セミナー"
                },
                "添付ファイル": {
                  "type": "FILE",
                  "value": []
                },
                "日付_0": {
                  "type": "DATE",
                  "value": "2014-08-06"
                }
              }
            },
            {
              "id": "144",
              "value": {
                "文字列__1行__5": {
                  "type": "SINGLE_LINE_TEXT",
                  "value": "社内提案でのデモを実施。役員含めて先方社内への提案でデモのお手伝い。2週間以内に判断がでるとのこと。"
                },
                "ドロップダウン_0": {
                  "type": "DROP_DOWN",
                  "value": "訪問/来訪"
                },
                "添付ファイル": {
                  "type": "FILE",
                  "value": []
                },
                "日付_0": {
                  "type": "DATE",
                  "value": "2014-08-23"
                }
              }
            }
          ]
        },
        "レコード番号": {
          "type": "RECORD_NUMBER",
          "value": "40"
        },
        "単価": {
          "type": "NUMBER",
          "value": "650"
        },
        "更新者": {
          "type": "MODIFIER",
          "value": {
            "code": "Administrator",
            "name": "Administrator"
          }
        },
        "ユーザー数": {
          "type": "NUMBER",
          "value": "267"
        },
        "作成者": {
          "type": "CREATOR",
          "value": {
            "code": "Administrator",
            "name": "Administrator"
          }
        },
        "文字列__1行_": {
          "type": "SINGLE_LINE_TEXT",
          "value": "戸田ネットソリューションズ"
        },
        "ラジオボタン": {
          "type": "RADIO_BUTTON",
          "value": "C"
        },
        "ドロップダウン": {
          "type": "DROP_DOWN",
          "value": "Office"
        },
        "$revision": {
          "type": "__REVISION__",
          "value": "6"
        },
        "文字列__1行__0": {
          "type": "SINGLE_LINE_TEXT",
          "value": "開発本部"
        },
        "ユーザー選択": {
          "type": "USER_SELECT",
          "value": [
            {
              "code": "Administrator",
              "name": "Administrator"
            }
          ]
        },
        "文字列__1行__1": {
          "type": "SINGLE_LINE_TEXT",
          "value": "浜崎 孝"
        },
        "更新日時": {
          "type": "UPDATED_TIME",
          "value": "2014-03-13T10:53:00Z"
        },
        "文字列__1行__4": {
          "type": "SINGLE_LINE_TEXT",
          "value": "hamasaki@xxx.com"
        },
        "文字列__1行__2": {
          "type": "SINGLE_LINE_TEXT",
          "value": "092-123-XXXX"
        },
        "文字列__1行__3": {
          "type": "SINGLE_LINE_TEXT",
          "value": "092-123-XXXX"
        },
        "作成日時": {
          "type": "CREATED_TIME",
          "value": "2013-04-12T06:22:00Z"
        },
        "計算": {
          "type": "CALC",
          "value": "173550"
        },
        "日付": {
          "type": "DATE",
          "value": "2014-10-10"
        },
        "$id": {
          "type": "__ID__",
          "value": "40"
        }
      }
    ]
    JSON

    after = <<-'ARRAY'
    [
      {
        "活動履歴": [
          {
            "id": "142",
            "文字列__1行__5": "導入相談に申し込みあり。電話にて現状・要件のヒアリングを行った。",
            "ドロップダウン_0": "導入相談",
            "添付ファイル": [],
            "日付_0": "2014-08-01"
          },
          {
            "id": "143",
            "文字列__1行__5": "ハンズオンセミナーに来場いただき、実際の画面をみながらご説明。担当者の反応はよく、社内提案のための資料提供などのサポートをしていく。",
            "ドロップダウン_0": "セミナー",
            "添付ファイル": [],
            "日付_0": "2014-08-06"
          },
          {
            "id": "144",
            "文字列__1行__5": "社内提案でのデモを実施。役員含めて先方社内への提案でデモのお手伝い。2週間以内に判断がでるとのこと。",
            "ドロップダウン_0": "訪問/来訪",
            "添付ファイル": [],
            "日付_0": "2014-08-23"
          }
        ],
        "レコード番号": "40",
        "単価": "650",
        "更新者": {
          "code": "Administrator",
          "name": "Administrator"
        },
        "ユーザー数": "267",
        "作成者": {
          "code": "Administrator",
          "name": "Administrator"
        },
        "文字列__1行_": "戸田ネットソリューションズ",
        "ラジオボタン": "C",
        "ドロップダウン": "Office",
        "$revision": "6",
        "文字列__1行__0": "開発本部",
        "ユーザー選択": [
          {
            "code": "Administrator",
            "name": "Administrator"
          }
        ],
        "文字列__1行__1": "浜崎 孝",
        "更新日時": "2014-03-13T10:53:00Z",
        "文字列__1行__4": "hamasaki@xxx.com",
        "文字列__1行__2": "092-123-XXXX",
        "文字列__1行__3": "092-123-XXXX",
        "作成日時": "2013-04-12T06:22:00Z",
        "計算": "173550",
        "日付": "2014-10-10",
        "$id": "40"
      }
    ]
    ARRAY

    result = KCLI::Array::to_array( JSON.parse( before ) )
    expect( result.count ).to eq JSON.parse( before ).count
    expect( result ).to eq( JSON.parse( after ) )
    expect( result[0].count ).to eq( JSON.parse( before )[0].count )
  end

end
