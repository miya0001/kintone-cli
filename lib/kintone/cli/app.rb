# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module Kintone_Cli

  class App < Thor
    Kintone_Cli::Utils.shared_options.each do |option, args|
      class_option option, args
    end

    desc "app list", "Get a list of apps."
    method_option :field, :desc => "Prints the value of a single field for each."
    method_option :fields, :desc => "Limit the output to specific object fields."
    method_option :format, :desc => "Render output in a particular format."
    def list
      p $options
      puts "hello"
    end # end create

    desc "app create <file>", "Create an app."
    def create( yaml )
      puts "hello"
    end # end create

    desc "app update <file>", "Update an app."
    def update( yaml )
      puts "hello"
    end # end create

  end
end
