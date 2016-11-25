# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'spec_helper'
require 'shellwords'
require 'kintone/cli'

describe Kintone_Cli::Command do

  specify{ expect{
    Kintone_Cli::Command.new.invoke( :version, [], {} )
  }.to output( Kintone_Cli::VERSION + "\n" ).to_stdout }

end
