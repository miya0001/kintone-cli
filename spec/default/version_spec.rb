# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'

describe kcli::Command do

  it "Get the record from kintone record api" do
    output = capture(:stdout) {
      kcli::Command.start( [
        "version"
      ] )
    }
    expect( output ).to eq kcli::VERSION + "\n"
  end

end
