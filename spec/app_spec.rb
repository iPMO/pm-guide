require_relative '../app.rb'
require 'rack/test'
require 'rails_helper'

RSpec.describe 'Sinatra App' do
    include Rack::Test::Methods

      def app
       IpMO.new
      end

      it "displays home page" do 
          get '/'
      end

      it "displays download page" do 
          get '/download'
      end

      it "displays upload page" do 
          get '/upload'
      end

      it "displays list page" do 
          get '/list'
      end

      it "lists the documents for a project on a page" do
        get '/list/', :project_name => "TEST"
        expect(last_response.body).to include("List of documents")
      end

      it "shows the document loaded as a blob on a page" do
        get '/list/show/', :key => "nil"

        expect(last_response.body).to include('.pdf')
      end 
end
