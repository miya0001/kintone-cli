# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module KCLI
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

    def parse_args_for_delete_record( ids, options )
      deletes = []
      if "array" == options[:format]
        deletes = ids
      else
        if "json" == options[:format]
          items = JSON.parse( ids[0] )
        elsif "yaml" == options[:format]
          items = YAML.load( ids[0] )
        end
        items.each do | item |
          if item.is_a?( Numeric ) || ( item.is_a?( String ) && item.to_i > 0 )
            deletes.push( item )
          else
            if item['id']
              deletes.push( item['id'] )
            elsif item['$id']
              deletes.push( item['$id'] )
            else
              KCLI.error( "The argument looks incorrect format." );
            end
          end
        end
      end
      return deletes
    end

    def success( message )
      puts "Success: ".colorize( :green ) + message
    end # end success

    def error( message )
      $stderr.puts "Error: ".colorize( :red ) + message
      exit 1
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
        error( e.message )
      rescue => e
        error( e.message )
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
      e = options["environment"]

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
end # end Pushbullet_CLI
