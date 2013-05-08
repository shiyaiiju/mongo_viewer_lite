# encoding: UTF-8
require 'rubygems'
require 'mongo'

module Mongo
  
  class MongoAdapterLite
    
    attr_accessor :database_name
    attr_accessor :collection_name
    
    def initialize
      @database_name = nil
      @collection_name = nil
    end
    
    def connect
      
      client = MongoClient.new('localhost', 27017)
      
      return client
    end
    
    
    def database_list
      
      client = connect
      
      database_list = []
      client.database_info.each do |info|
        if info[0] != "local"
          database_list.push( {
            :name => info[0],
            :total_size => (info[1] / 1024 / 1024),
          })
        end
      end
      
      return database_list
    end
    
    def collection_list()
      
      client = connect
      
      db_info = client[@database_name]
      
      collection_list = []
      db_info.collection_names.each do |coll_name|
        if /^(?!(system)).*/ =~ coll_name
          
          rows = db_info.collection(coll_name).find().sort([:_id, :desc]).limit(1)
          row = rows.next

          row["time"] = row["time"].getlocal.strftime('%Y-%m-%d %H:%M:%S') rescue "nil"
          collection_list.push({
            :name => coll_name,
            :count => rows.count.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,'),
            :time => row["time"],
            :uri => "/values/#{@database_name}/#{coll_name}",
          })
          
        end
      end
      
      return collection_list
    end

    def exec_find(where, page)
      
      page = page < 1 ? 1 : page
      
      client = connect
      
      db_info = client[@database_name]
      collection = db_info.collection(@collection_name)
      finds = collection
        .find(where)
        .sort([:_id, :desc])
        .limit(100)
        .skip((page-1) * 100)

      return finds
    end
    
    def parse_finds(finds)
      
      #列順を記録
      rows = []
      keys = {}
      finds.each{ |row|
        rows.push row
        row.each{ |val|
          if val[0] != "_id"
            if !keys.key?(val[0])
              keys[val[0]] = nil
            end
          end
        }
      }
      
      #各行を出力開始
      rows.each_with_index do |row, index|
        
        #列順に整列
        keys_tmp = keys.clone()
        row.each do |val|
          if val[0] != "_id"
            keys_tmp[val[0]] = val[1].getlocal.strftime('%Y-%m-%d %H:%M:%S') rescue val[1]
          end
        end
        rows[index] = keys_tmp
      end
      
      return keys, rows
    end

  end
  
end