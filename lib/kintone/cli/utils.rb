# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module KCLI
  class << self

    def json_decode( json )
      begin
        return JSON.parse( json )
      rescue => e
        KCLI.error( "Invalid JSON format." )
      end
    end

    def yaml_decode( yaml )
      begin
        return YAML.load( yaml )
      rescue => e
        KCLI.error( "Invalid YAML format." )
      end
    end

    def readfile( file )
      realpath = File.expand_path( file )
      if File.exists?( realpath )
        return File.read( realpath, :encoding => Encoding::UTF_8 )
      else
        KCLI.error( "\"#{file}\" doesn't exist." )
      end
    end

    def curdir( *args )
      sh = Shell.new
      return File.join( sh.cwd, args )
    end

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
    end # end shared_options

    def parse_args_for_delete_record( ids, options )
      deletes = []
      if "array" == options[:format]
        deletes = ids
      else
        if "json" == options[:format]
          items = json_decode( ids[0] )
        elsif "yaml" == options[:format]
          items = yaml_decode( ids[0] )
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
    end # end parse_args_for_delete_record

    def success( message )
      puts "Success: ".colorize( :green ) + message
    end # end success

    def error( message )
      $stderr.puts "Error: ".colorize( :red ) + message
      exit 1
    end # end error

    def kintone_record_to_array( records )
      items = []
      records.each do | record |
        item = {}
        record.each do | key, value |
          if value["value"].is_a?( Array )
            item[key] = parse_sub_table( value["value"] )
          else
            item[key] = value["value"]
          end
        end
        items.push( item )
      end

      return items
    end

    def parse_sub_table( items )
      unless items[0] && items[0]["id"] && items[0]["value"]
        return items
      end
      records = []
      items.each do | item |
        record = {}
        record["id"] = item["id"]
        item["value"].each do | key, val |
          record[ key ] = val["value"]
        end
        records.push( record )
      end
      return records
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
        return json_decode( response )
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
        return yaml_decode( readfile( kintonefile ) )
      else
        return {}
      end
    end # end load_kintonefile

  end # end self
end # end Pushbullet_CLI
