# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "yaml"
require "shell"
require "rest-client"
require "base64"
require "json"

module Kintone_Cli
  class Utils
    class << self

      def print( options )
        if "json" == options[:format]
          puts JSON.generate( options[:rows] )
        else
          table = options[:rows].map.with_index{ | row | parse_row( options[:cols], row ) }
          Utils::print_table( options[:cols], table )
        end
      end # end print

      def kintone_record_to_array( records )
        items = []
        records.each do | record |
          item = {}
          record.each do | key, value |
            item[key] = value["value"]
          end
          items.push( item )
        end

        return items
      end

      def parse_yaml(yaml)
        items = YAML.load_file( yaml )

        kintone_array = []
        items.each do | item |
          record = {
            "record" => {}
          }
          item.each do | key, value |
            if "id" == key
              record["id"] = value
            else
              record["record"][key] = {
                "value" => value
              }
            end
          end
          kintone_array.push( record )
        end

        return kintone_array
      end

      def send( url, method, params = {} )
        if nil == $env || ! $env["subdomain"]
          $stderr.puts "Subdomain is not defined."
          exit 1
        end

        api = sprintf( "https://%s.cybozu.com/k/v1", $env["subdomain"] ) + url;

        begin
          response = RestClient::Request.execute(
            :method => method,
            :url => api,
            :payload => JSON.generate( params ),
            :headers => http_headers
          )
          return JSON.parse( response )
        rescue RestClient::ExceptionWithResponse => e
          $stderr.puts e.message
          exit 1
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end # end send

      def http_headers
        if nil == $env
          raise "Kintonefile not found"
        end

        headers = {
          :content_type => :json,
          :accept => :json
        }

        if $env["user"] && $env["password"]
          auth = Base64.strict_encode64( $env["user"] + ':' + $env["password"] )
          headers.merge!( {
            "X-Cybozu-Authorization" => auth
          } )
        end

        return headers
      end

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
