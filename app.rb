# encoding: UTF-8
require 'rubygems'
require "sinatra/base"
require 'mongo'
require 'slim'
require './lib/mongo_adapter_lite'

include Mongo


module MongoView
  class App < Sinatra::Base
    
    set :public_folder, File.dirname(__FILE__) + '/public'
    
    
    get '/' do
      
      adapter = MongoAdapterLite.new
      @database_list = adapter.database_list
      
      p @database_list
    
      slim :index
      #erb :index
    end
    
    get '/collections/:dbname' do
      
      @database_name = params[:dbname]
      
      adapter = MongoAdapterLite.new
      adapter.database_name = @database_name
      @collection_list = adapter.collection_list()
      
      
      slim :collections
      #erb :collections
    end


    get '/values/:dbname/:collection_name?*' do

      @database_name = params[:dbname]
      @collection_name = params[:collection_name]

      @page = params["page"].to_s.to_i rescue 1
      @f_key = params["f_key"].to_s rescue ""
      @f_val = params["f_val"].to_s rescue ""

      p @page

      where = nil
      if @f_key != ""
        where = {:filter_key => Regexp.new(@f_val)}
      end


      adapter = MongoAdapterLite.new
      adapter.database_name = @database_name
      adapter.collection_name = @collection_name
      finds = adapter.exec_find(where, @page)
      @keys, @rows = adapter.parse_finds(finds)


      @base_uri = "./values/#{@database_name}/#{@collection_name}"

      @filter_presets = get_filter_presets

      slim :values
      #erb :values
    end
    
    get "/css/application.css" do
      scss :application
    end
    
    
    def get_filter_presets
      return [
        { :key => "status", :val => "^50[0-9]|40[0-9]$", :comment => "Apacheステータスエラー系"},
        { :key => "tag", :val => "^ERR|CRIT|WARN$", :comment => "アプリケーションエラー系"},
      ]
    end
  end
end
