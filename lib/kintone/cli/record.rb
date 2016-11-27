# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module KCLI
  class Record < Thor

    class_option :app, :desc => "The applicatin ID.", :type => :numeric, :required => true
    KCLI.shared_options.each do | option, args |
      class_option option, args
    end

    desc "record get", "Get a list of records."
    method_option :id, :desc => "The record ID."
    method_option :format, :desc => "Output format.", :enum => [ "yaml", "json" ]
    method_option :query, :desc => "Path to the JSON file that filters the data from the Kintone."
    def get
      if options[:id]
        url = "/record.json"
        params = { "app" => options[:app], "id" => options[:id] }
        res = KCLI.send( url, :get, params )
        records = [ res["record"] ]
      else
        url = "/records.json"
        if options[:query]
          json = KCLI.readfile( options[:query] )
          params = KCLI.json_decode( json )
          params["app"] = options[:app]
        else
          params = { "app" => options[:app] }
        end
        res = KCLI.send( url, :get, params )
        records = res["records"]
      end
      records = KCLI.kintone_record_to_array( records )
      if "yaml" == options[:format]
        puts YAML.dump( records )
      else
        puts JSON.generate( records )
      end
    end # end get

    desc "record post", "Post a list of records."
    method_option :format, :desc => "Input format.", :enum => [ "yaml", "json" ]
    def post( yaml )
      items = KCLI.yaml_decode( KCLI.readfile( yaml ) )
      records = KCLI.parse_yaml( items )
      posts = []
      records.each do | item |
        posts.push( item["record"] )
      end
      params = {
        "app" => options[:app],
        "records" => posts
      }
      res = KCLI.send( "/records.json", :post, params )
      puts JSON.generate( res["ids"] )
    end # end get

    desc "record put", "Update a list of records."
    method_option :format, :desc => "Input format.", :enum => [ "yaml", "json" ]
    def put( yaml )
      items = KCLI.yaml_decode( KCLI.readfile( yaml ) )
      update = KCLI.parse_yaml( items )
      params = {
        "app" => options[:app],
        "records" => update
      }
      res = KCLI.send( "/records.json", :put, params )
      puts JSON.generate( res["records"] )
    end # end get

    desc "record delete <id> ...", "Delete a list of records."
    method_option :format, :desc => "Input format of IDs.",
        :enum => [ "yaml", "json", "array" ], :default => "array"
    def delete( *ids )
      deletes = KCLI.parse_args_for_delete_record( ids, options )
      params = {
        "app" => options[:app],
        "ids" => deletes
      }
      res = KCLI.send( "/records.json", :delete, params )
      puts JSON.generate( res )
    end # end get

  end
end
