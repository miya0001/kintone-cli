# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"

module Kintone_Cli

  class App < Thor
    desc "app create <MESSAGE>", "Send a push to devices or another persons."
    method_option :title, :desc => "Title of the notification."
    method_option :device, :desc => "Iden of the target device to push."
    method_option :url, :desc => "The url to open."
    # method_option :person, :aliases => "-p", :desc => "Delete the file after parsing it"
    def create( message = "" )
      puts "hello"
    end # end create

  end
end
