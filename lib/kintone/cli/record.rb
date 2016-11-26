# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require "thor"
require "json"

module Kintone_Cli

  class Record < Thor
    class_option :app, :desc => "The applicatin ID.",
        :type => :numeric, :required => true

    desc "record get", "Get a list of records."
    method_option :id, :desc => "The record ID."
    method_option :format, :desc => "Out put format. json or yaml."
    def get
      if options[:id]
        url = "/record.json"
        params = { "app" => options[:app], "id" => options[:id] }
        root = "record"
      else
        url = "/records.json"
        params = { "app" => options[:app] }
        root = "records"
      end
      res = Kintone_Cli::Utils.send( url, :get, params )
      if "yaml" == options[:format]
        puts YAML.dump( res[ root ] )
      else
        puts JSON.generate( res[ root ] )
      end
    end # end get

    desc "record post", "Post a list of records."
    def post( yaml )
      records = YAML.load_file( yaml )
      params = {
        "app" => options[:app],
        "records" => records
      }
      res = Kintone_Cli::Utils.send( "/records.json", :post, params )
      puts JSON.generate( res["ids"] )
    end # end get

    desc "record put", "Update a list of records."
    def put( yaml )
      items = YAML.load_file( yaml )

      update = []
      items.each do | item |

        record = {
          "id" => nil,
          "record" => {}
        }
        item.each do | key, value |
          if "id" == key
            record[key] = value
          else
            record["record"][key] = {
              "value" => value
            }
          end
        end
        update.push( record )
      end

      params = {
        "app" => options[:app],
        "records" => update
      }

      res = Kintone_Cli::Utils.send( "/records.json", :put, params )
      puts JSON.generate( res["records"] )
    end # end get

    desc "record delete", "Delete a list of records."
    method_option :ids, :desc => "The IDs. It should be JSON like [12, 32]", :required => true
    def delete()
      params = {
        "app" => options[:app],
        "ids" => JSON.parse( options[:ids] )
      }
      res = Kintone_Cli::Utils.send( "/records.json", :delete, params )
      puts JSON.generate( res )
    end # end get
  end
end
