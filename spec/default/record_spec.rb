# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'kintone/cli'
require "json"

describe Kintone_Cli::Command do

  it "Get the record from kintone record api" do
    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "get",
        "--app=5",
        "--subdomain=" + ENV['KINTONE_SUBDOMAIN'],
        "--user=" + ENV['KINTONE_USER'],
        "--password=" + ENV['KINTONE_PASSWORD']
      ] )
    }
    expect( JSON.parse( output ).count ).to be > 0
  end

  it "Get the record from kintone record api with Kintonefile" do
    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "get",
        "--app=5",
        "--environment=default"
      ] )
    }
    expect( JSON.parse( output ).count ).to be > 0
  end

  it "Get the record from kintone record api with incorrect user" do
    expect{
      capture(:stderr) {
        Kintone_Cli::Command.start( [
          "record",
          "get",
          "--app=5",
          "--environment=staging"
        ] )
      }
    }.to raise_error( SystemExit )
  end

  it "Post two new records" do
    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "post",
        "./spec/data/post.yml",
        "--app=5",
        "--environment=default"
      ] )
    }

    expect( JSON.parse( output ).count ).to eq 2

    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "delete",
        "--app=5",
        "--environment=default",
        "--ids=#{output}"
      ] )
    }

    expect( output ).to eq "{}\n"
  end

  it "Update a record" do
    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "get",
        "--app=5",
        "--environment=default"
      ] )
    }
    before = JSON.parse( output )

    ids = []
    before.each do | item |
      item.each do | key, value |
        if '$id' == key
          ids.push( value["value"] )
        end
      end
    end

    update = []
    ids.each do | item |
      update.push(
        {
          "id" => item,
          "文字列__複数行_" => "今日は#{Time.now.strftime("%Y-%m-%d")}です。",
          "文字列__複数行__0" => "現在は#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}です。"
        }
      )
    end

    File.open( "./spec/data/update.yml", "w" ) do | file |
      file.puts YAML.dump( update )
    end

    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "record",
        "put",
        "./spec/data/update.yml",
        "--app=5",
        "--environment=default"
      ] )
    }

    expect( JSON.parse( output ).count ).to eq before.count
  end

  before( :all ) do
    File.open( "./Kintonefile", "w" ) do | file |
      file.puts <<EOL
default:
  subdomain: #{ENV['KINTONE_SUBDOMAIN']}
  user: #{ENV['KINTONE_USER']}
  password: #{ENV['KINTONE_PASSWORD']}
staging:
  subdomain: xxxx
  user: yyyy
  password: zzzz
EOL
    end
  end

  after( :all ) do
    File.delete( "./Kintonefile" )
  end

end
