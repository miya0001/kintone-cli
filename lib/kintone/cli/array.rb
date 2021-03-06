# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

module KCLI
  class Array
    class << self

      def to_kintone
      end

      def to_array( records )
        items = []
        records.each do | record |
          item = {}
          record.each do | key, value |
            if "SUBTABLE" == value["type"]
              item[key] = sub_table_to_array( value["value"] )
            else
              item[key] = value["value"]
            end
          end
          items.push( item )
        end
        return items
      end

      def sub_table_to_array( items )
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

    end
  end
end
