# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"
require "erb"
require "yaml"
require "shell"
require "rest-client"
require "base64"
require "json"
require "colorize"

require "kintone/cli/version"
require "kintone/cli/utils"
require "kintone/cli/app"
require "kintone/cli/record"

module kcli
  class Command < Thor
    kcli.shared_options.each do | option, args |
      class_option option, args
    end

    desc "app <subcommand>", "Manage apps on the Kintone."
    subcommand "app", App

    desc "record <subcommand>", "Manage records on the Kintone."
    subcommand "record", Record

    desc "init", "Generates a new Kintonefile."
    def init
      template = ERB.new File.read( File.join(
        File.dirname(__FILE__),
        '../templates/Kintonefile'
      ) )
      File.open( "./Kintonefile", "w" ) do | file |
        file.puts template.result( binding )
      end
      kcli.success( "Create a Kintonefile." )
    end

    desc "version", "Displays the version of the Kintone CLI."
    def version
      puts kcli::VERSION
    end

    no_commands do
      def invoke_command( command, *args )
        if 'init' != command.name
          envs = kcli.load_kintonefile
          $env = kcli.get_env( envs, options )

          unless $env['user'] && $env['password'] && $env['subdomain']
            kcli.error( "Your account information is not defined. Please run `kt init`" )
          end
        end
        super
      end
    end

  end # end class Command
end # end module kcli
