# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'kintone/cli'
require "json"

describe KCLI::Command do

  it "Get the record from kintone record api" do
    output = capture(:stdout) {
      KCLI::Command.start( [
        "init",
        "--environment=default",
        "--subdomain=#{ENV['KINTONE_SUBDOMAIN']}",
        "--user=#{ENV['KINTONE_USER']}",
        "--password=#{ENV['KINTONE_PASSWORD']}"
      ] )
    }
    expect( File ).to exist( "./Kintonefile" )
  end

  it "Get the record from kintone record api" do
    output = capture(:stdout) {
      KCLI::Command.start( [
        "init"
      ] )
    }
    expect( File ).to exist( "./Kintonefile" )
  end

  after( :each ) do
    if File.exists?( "./Kintonefile" )
      File.delete( "./Kintonefile" )
    end
  end
end
