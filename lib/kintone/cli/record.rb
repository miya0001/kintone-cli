# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module kcli

  class Record < Thor
    class_option :app, :desc => "The applicatin ID.", :type => :numeric, :required => true
    kcli.shared_options.each do | option, args |
      class_option option, args
    end

    desc "record get", "Get a list of records."
    method_option :id, :desc => "The record ID."
    method_option :format, :desc => "Out put format. json or yaml."
    def get
      if options[:id]
        url = "/record.json"
        params = { "app" => options[:app], "id" => options[:id] }
        res = kcli.send( url, :get, params )
        records = [ res["record"] ]
      else
        url = "/records.json"
        params = { "app" => options[:app] }
        res = kcli.send( url, :get, params )
        records = res["records"]
      end
      records = kcli.kintone_record_to_array( records )
      if "yaml" == options[:format]
        puts YAML.dump( records )
      else
        puts JSON.generate( records )
      end
    end # end get

    desc "record post", "Post a list of records."
    def post( yaml )
      items = YAML.load_file( yaml )
      records = kcli.parse_yaml( items )
      posts = []
      records.each do | item |
        posts.push( item["record"] )
      end
      params = {
        "app" => options[:app],
        "records" => posts
      }
      res = kcli.send( "/records.json", :post, params )
      puts JSON.generate( res["ids"] )
    end # end get

    desc "record put", "Update a list of records."
    def put( yaml )
      items = YAML.load_file( yaml )
      update = kcli.parse_yaml( items )

      params = {
        "app" => options[:app],
        "records" => update
      }

      res = kcli.send( "/records.json", :put, params )
      puts JSON.generate( res["records"] )
    end # end get

    desc "record delete", "Delete a list of records."
    method_option :ids, :desc => "The IDs. It should be JSON like [12, 32]", :required => true
    def delete()
      params = {
        "app" => options[:app],
        "ids" => JSON.parse( options[:ids] )
      }
      res = kcli.send( "/records.json", :delete, params )
      puts JSON.generate( res )
    end # end get
  end
end
