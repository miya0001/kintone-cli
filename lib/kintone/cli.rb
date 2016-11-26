# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "kintone/cli/version"
require "kintone/cli/utils"
require "kintone/cli/app"
require "thor"
require "rest-client"
require "yaml"

module Kintone_Cli

  class Command < Thor

    class_option :environment, aliases: "-e", type: :string, desc: 'Your environment.'
    class_option :subdomain, type: :string, desc: 'The subdomain of the Kintone.'
    class_option :user, type: :string, desc: 'The username of the Kintone.'
    class_option :password, type: :string, desc: 'The password of the Kintone.'

    desc "app <SUBCOMMAND>", "Manage apps on the Kintone."
    subcommand "app", App

    desc "init", "Generates a new Kintonefile."
    def init
      puts Kintone_Cli::VERSION
    end

    desc "version", "Displays the version of the Kintone CLI."
    def version
      puts Kintone_Cli::VERSION
    end

    no_commands do
      def invoke_command( command, *args )
        envs = Kintone_Cli::Utils.load_kintonefile
        $env = Kintone_Cli::Utils.get_env( envs, options )
        super
      end
    end

  end # end class Command
end # end module Kintone_Cli
