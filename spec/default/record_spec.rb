# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'kintone/cli'
require "json"

describe KCLI::Command do

  it "Get the record from kintone record api with incorrect json" do
    expect{
      capture( :stderr ) {
        KCLI::Command.start( [
        "record",
        "get",
        "--app=5",
        "--query=./spec/data/post.yml"
        ] )
      }
    }.to raise_error( SystemExit )
  end

  it "Get the record from kintone record api with query" do
    output = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "get",
        "--app=5",
        "--query=./spec/data/query.json"
      ] )
    }
    expect( JSON.parse( output ).count ).to eq 7
  end

  it "Get the record from kintone record api" do
    output = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "get",
        "--app=5",
        "--subdomain=#{ENV['KINTONE_SUBDOMAIN']}",
        "--user=#{ENV['KINTONE_USER']}",
        "--password=#{ENV['KINTONE_PASSWORD']}"
      ] )
    }
    expect( JSON.parse( output ).count ).to be > 0
  end

  it "Get the record from kintone record api with incorrect params" do
    expect{
      capture( :stderr ) {
        KCLI::Command.start( [
          "record",
          "get",
          "--app=5",
          "--subdomain=#{ENV['KINTONE_SUBDOMAIN']}",
          "--user=#{ENV['KINTONE_USER']}",
          "--password=1111"
        ] )
      }
    }.to raise_error( SystemExit )
  end

  it "Get the record from kintone record api with no environment option" do
    output = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "get",
        "--app=5"
      ] )
    }
    expect( JSON.parse( output ).count ).to be > 0
  end

  it "Get the record from kintone record api with Kintonefile" do
    output = capture( :stdout ) {
      KCLI::Command.start( [
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
      capture( :stderr ) {
        KCLI::Command.start( [
          "record",
          "get",
          "--app=5",
          "--environment=staging"
        ] )
      }
    }.to raise_error( SystemExit )
  end

  it "Post two new records then update and delete them" do
    posted = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "post",
        "./spec/data/post.yml",
        "--app=5",
        "--environment=default"
      ] )
    }

    expect( JSON.parse( posted ).count ).to eq 2

    ids = JSON.parse( posted )
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

    updated = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "put",
        "./spec/data/update.yml",
        "--app=5",
        "--environment=default"
      ] )
    }

    expect( JSON.parse( updated ).count ).to eq 2

    output = capture( :stdout ) {
      KCLI::Command.start( [
        "record",
        "delete",
        posted,
        "--app=5",
        "--environment=default",
        "--format=json"
      ] )
    }

    expect( output ).to eq "{}\n"
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
end
