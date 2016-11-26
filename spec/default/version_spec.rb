# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'

describe Kintone_Cli::Command do

  it "Get the record from kintone record api" do
    output = capture(:stdout) {
      Kintone_Cli::Command.start( [
        "version"
      ] )
    }
    expect( output ).to eq Kintone_Cli::VERSION + "\n"
  end

end
