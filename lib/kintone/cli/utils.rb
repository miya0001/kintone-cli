# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module Kintone_Cli
  class Utils
    class << self
      def shared_options
        {
          environment: {
            aliases: "-e",
            type: :string,
            desc: 'Your environment in the Kintonefile.',
            default: "default"
          },
          subdomain: {
            aliases: "-s",
            type: :string,
            desc: 'The subdomain of the Kintone.'
          },
          user: {
            aliases: "-u",
            type: :string,
            desc: 'The username of the Kintone.'
          },
          password: {
            aliases: "-p",
            type: :string,
            desc: 'The password of the Kintone.'
          }
        }
      end

      def success( message )
        puts "Success: ".colorize( :green ) + message
      end # end success

      def error( message )
        puts "Error: ".colorize( :red ) + message
      end # end success

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

      def parse_yaml( items )
        kintone_array = []
        items.each do | item |
          record = {
            "record" => {}
          }
          item.each do | key, value |
            if "id" == key || '$id' == key
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
