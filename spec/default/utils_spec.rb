# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'
require 'shell'

describe KCLI do

  it "tests for curdir()" do
    res = KCLI.curdir( 'a', 'b' )
    sh = Shell.new
    expected = File.join( sh.cwd, 'a', 'b' )
    expect( res ).to eq expected
  end

  it "parsing args for delete records with yaml" do
    ids = <<-'YAML'
- $id: 1
  name: John
- $id: 2
  name: Mike
- $id: 3
  name: Nancy
    YAML
    options = {}
    options[:format] = "yaml"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with yaml" do
    ids = <<-'YAML'
- id: 1
  name: John
- id: 2
  name: Mike
- id: 3
  name: Nancy
    YAML
    options = {}
    options[:format] = "yaml"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with yaml" do
    ids = YAML.dump( [ 1, 2, 3 ] )
    options = {}
    options[:format] = "yaml"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with json" do
    ids = JSON.generate( [
      { "$id": 1, name: "John" }, { "$id": 2, name: "Mike" }, { "$id": 3, name: "Nancy" }
    ] )
    options = {}
    options[:format] = "json"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with json" do
    ids = JSON.generate( [ { id: 1 }, { id: 2 }, { id: 3 } ] )
    options = {}
    options[:format] = "json"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with json" do
    ids = JSON.generate( [ 1, 2, 3 ] )
    options = {}
    options[:format] = "json"
    res = KCLI.parse_args_for_delete_record( [ ids ], options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "parsing args for delete records with array" do
    ids = [ 1, 2, 3 ]
    options = {}
    options[:format] = "array"
    res = KCLI.parse_args_for_delete_record( ids, options )
    expect( res ).to eq [ 1, 2, 3 ]
  end

  it "tests for sccess()" do
    output = capture(:stdout) {
      KCLI.success( "Hello")
    }
    expect( output ).to eq "\e[0;32;49mSuccess: \e[0mHello\n"
  end

  it "Kintone style array to be key/value style array" do
    json = <<-'JSON'
    [
      {
        "ラジオボタン": {
          "value": "達成"
        },
        "ドロップダウン": {
          "value": "営業"
        },
        "文字列__複数行__0": {
          "value": "1行のデータのテスト"
        },
        "文字列__複数行_": {
          "value": "メール作成"
        },
        "日付": {
          "value": "2016-11-27"
        }
      },
      {
        "ラジオボタン": {
          "value": "達成"
        },
        "ドロップダウン": {
          "value": "営業"
        },
        "文字列__複数行__0": {
          "value": "複数行のテスト\nこんにちは！\nおでんのメニュー"
        },
        "文字列__複数行_": {
          "value": "・たまご\n・だいこん\n・牛すじ"
        },
        "日付": {
          "value": "2016-11-27"
        }
      }
    ]
    JSON

    array = <<-'ARRAY'
    [
      {
        "ラジオボタン": "達成",
        "ドロップダウン": "営業",
        "文字列__複数行__0": "1行のデータのテスト",
        "文字列__複数行_": "メール作成",
        "日付": "2016-11-27"
      },
      {
        "ラジオボタン": "達成",
        "ドロップダウン": "営業",
        "文字列__複数行__0": "複数行のテスト\nこんにちは！\nおでんのメニュー",
        "文字列__複数行_": "・たまご\n・だいこん\n・牛すじ",
        "日付": "2016-11-27"
      }
    ]
    ARRAY

    result = KCLI.kintone_record_to_array( JSON.parse( json ) )
    expect( result.count ).to be > 0
    expect( result ).to eq( JSON.parse( array ) )
  end

  it "Yaml array will be converted to kintone style array" do
    yaml = <<-'YAML'
- レコード番号: '153'
  更新者:
    code: Administrator
    name: Administrator
  作成者:
    code: Administrator
    name: Administrator
  ラジオボタン: 達成
  ドロップダウン: 営業
  "$revision": '38'
  更新日時: '2016-11-26T21:15:00Z'
  文字列__複数行__0: 現在は2016-11-26 21:15:26です。
  文字列__複数行_: 今日は2016-11-26です。
  添付ファイル: []
  作成日時: '2016-11-26T20:51:00Z'
  日付: '2016-11-27'
  "$id": '153'
    YAML

    json = <<-'JSON'
    [
      {
        "record": {
          "レコード番号": {
            "value": "153"
          },
          "更新者": {
            "value": {
              "code": "Administrator",
              "name": "Administrator"
            }
          },
          "作成者": {
            "value": {
              "code": "Administrator",
              "name": "Administrator"
            }
          },
          "ラジオボタン": {
            "value": "達成"
          },
          "ドロップダウン": {
            "value": "営業"
          },
          "$revision": {
            "value": "38"
          },
          "更新日時": {
            "value": "2016-11-26T21:15:00Z"
          },
          "文字列__複数行__0": {
            "value": "現在は2016-11-26 21:15:26です。"
          },
          "文字列__複数行_": {
            "value": "今日は2016-11-26です。"
          },
          "添付ファイル": {
            "value": []
          },
          "作成日時": {
            "value": "2016-11-26T20:51:00Z"
          },
          "日付": {
            "value": "2016-11-27"
          }
        },
        "id": "153"
      }
    ]
    JSON

    items = YAML.load( yaml )
    result = KCLI.parse_yaml( items )
    expect( result ).to eq JSON.parse( json )
  end

  it "Yaml array will be converted to kintone style array" do
    items = YAML.load_file( "spec/data/post.yml" )
    result = KCLI.parse_yaml( items )
    expect( result.count ).to be > 0
    json = <<-'JSON'
    [
      {
        "record": {
          "ラジオボタン": {
            "value": "達成"
          },
          "ドロップダウン": {
            "value": "営業"
          },
          "文字列__複数行__0": {
            "value": "1行のデータのテスト"
          },
          "文字列__複数行_": {
            "value": "メール作成"
          },
          "日付": {
            "value": "2016-11-27"
          }
        }
      },
      {
        "record": {
          "ラジオボタン": {
            "value": "達成"
          },
          "ドロップダウン": {
            "value": "営業"
          },
          "文字列__複数行__0": {
            "value": "複数行のテスト\nこんにちは！\nおでんのメニュー"
          },
          "文字列__複数行_": {
            "value": "・たまご\n・だいこん\n・牛すじ"
          },
          "日付": {
            "value": "2016-11-27"
          }
        }
      }
    ]
    JSON

    expect( result ).to eq JSON.parse( json )
  end

  it "Tests for getting http headers" do
    $env = {
      "user" => "user",
      "password" => "pass",
      "subdomain" => "staging-subdomain"
    }

    result = KCLI.http_headers
    auth = Base64.strict_decode64( result["X-Cybozu-Authorization"] )
    expect( auth ).to eq $env["user"] + ":" + $env["password"]
  end

  it "Tests for getting an environment" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging"
    }

    result = KCLI.get_env( envs, options )
    expect( result ).to eq "user" => "staging-user",
        "password" => "staging-pass", "subdomain" => "staging-subdomain"
  end

  it "Tests for getting an environment with options (1)" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging",
      "user" => "user",
      "password" => "pass",
      "subdomain" => "subdomain"
    }

    result = KCLI.get_env( envs, options )
    expect( result ).to eq "user" => "user",
        "password" => "pass", "subdomain" => "subdomain"
  end

  it "Tests for getting an environment with options (2)" do
    envs = {
      'default' => {
        "user" => "default-user",
        "password" => "default-pass",
        "subdomain" => "default-subdomain"
      },
      'staging' => {
        "user" => "staging-user",
        "password" => "staging-pass",
        "subdomain" => "staging-subdomain"
      }
    }

    options = {
      "environment" => "staging",
      "user" => "user"
    }

    result = KCLI.get_env( envs, options )
    expect( result['user'] ).to eq "user"
    expect( result['password'] ).to eq "staging-pass"
    expect( result['subdomain'] ).to eq "staging-subdomain"
  end

end
