# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "yaml"
require "shell"

module Kintone_Cli
  class Utils
    class << self

      def get_env( envs, options )
        if options["environment"]
          e = options["environment"]
        else
          e = "default"
        end

        if envs[ e ]
          env = envs[ e ]
        else
          env = {
            "user" => nil,
            "password" => nil,
            "subdomain" => nil
          }
        end

        if options["user"]
          env.merge!( {
            "user" => options["user"],
          } );
        end

        if options["password"]
          env.merge!( {
            "password" => options["password"],
          } );
        end

        if options["subdomain"]
          env.merge!( {
            "subdomain" => options["subdomain"],
          } );
        end

        return env
      end # end auth header

      def load_kintonefile
        sh = Shell.new
        kintonefile = File.join( sh.cwd, "Kintonefile" )
        if File.exist?( kintonefile )
          return YAML.load_file( kintonefile )
        else
          return {}
        end
      end

    end # end self
  end # end Utils
end # end Pushbullet_CLI
