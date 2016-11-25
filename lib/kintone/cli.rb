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

    desc "app <SUBCOMMAND>", "Manage apps on the Kintone."
    subcommand "app", App

    desc "version", "Displays the version of the Kintone CLI"
    def version
      puts Kintone_Cli::VERSION
    end

  end # end class Command
end # end module Kintone_Cli
