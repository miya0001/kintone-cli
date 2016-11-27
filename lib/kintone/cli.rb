# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "kintone/cli/version"
require "kintone/cli/utils"
require "kintone/cli/app"
require "kintone/cli/record"
require "thor"

module Kintone_Cli
  class Command < Thor
    class_option :environment, aliases: "-e", type: :string, desc: 'Your environment in the Kintonefile.'
    class_option :subdomain, aliases: "-s", type: :string, desc: 'The subdomain of the Kintone.'
    class_option :user, aliases: "-u", type: :string, desc: 'The username of the Kintone.'
    class_option :password, aliases: "-p", type: :string, desc: 'The password of the Kintone.'

    desc "app <subcommand>", "Manage apps on the Kintone."
    subcommand "app", App

    desc "record <subcommand>", "Manage records on the Kintone."
    subcommand "record", Record

    desc "init", "Generates a new Kintonefile."
    def init
      puts options
    end

    desc "version", "Displays the version of the Kintone CLI."
    def version
      puts Kintone_Cli::VERSION
    end

    no_commands do
      def invoke_command( command, *args )
        if 'init' != command.name
          envs = Kintone_Cli::Utils.load_kintonefile
          $env = Kintone_Cli::Utils.get_env( envs, options )

          unless $env['user'] && $env['password'] && $env['subdomain']
            $stderr.puts "Your account information is not defined."
            exit 1
          end
        end
        super
      end
    end

  end # end class Command
end # end module Kintone_Cli
