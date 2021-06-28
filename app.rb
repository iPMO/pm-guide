require 'rubygems'
require 'sinatra/base'
require_relative 'app/controllers/document_controller'


class IpMO < Sinatra::Base
  include ActionController::Streaming

  set :views, settings.root + '/app/views/'
  set :static, :true
 
  # get the index page
  get '/' do
    puts 'going home'
    erb :details, :layout => :application
  end

  # show the upload document view 
  get '/upload' do
    puts 'going to upload' 
    erb :upload, :layout => :application
  end

  post '/upload' do
    check(params)
    get_pdf_file(params)
    doc = new_document(params)
    if doc.nil? 
      code = "<% Error uploading document %>"
      erb code
    end
    erb :done, :layout => :application
  end

  # route to list all projects
  get '/list' do
    puts 'going to list all projects'
    check_document_pdf
    erb :list, :layout => :application
  end
  
  # route for listing the project with name :project
  get '/list/:project_name' do
    puts 'goint to list the projects'
    "listing details for project #{params['project_name']}"
    check(params)
    @params = params
    erb :list, :layout => :application
  end

  get '/show/:key' do
    key = params['key']
    puts "showing file with #{key}"
    file_name = 'public/'.concat(key).concat('.pdf')
    file_name_static = "public/sample.pdf"
    link_file(params)
    @params = params
    erb  :show, :layout => :application 
  end

  # route for the download page
  get '/download' do
    puts 'going to create an download bundle for templates'
    erb :download, :layout => :application
  end

  # route for details of a certain project
  get '/details/:project_name' do
    @params = params
    project = params['project_name']
    puts "loading details/#{project}"
    erb :details, :layout => :application
  end

  # ROUTES are OVER, here comes the HELPES
  # method to list the parameter
  def check(params)
    @params.each do |param|
     puts param
    end
  end

  # method to save a new document
  def new_document(params)
    filename = params[:document_pdf][:filename]
    if is_filename_valid(filename) 
     chunks = split_filename(filename)
     document = Document.new
     document.write_attribute(:document_name, filename)
     document.write_attribute(:document_type, chunks[2])
     document.write_attribute(:project_name, chunks[0].upcase!)
     document.write_attribute(:pm_standard, chunks[1])
     document.write_attribute(:process_step, get_version(filename))
     document.write_attribute(:document_version, 1000)
     document = attach_pdf(params, document)
     document.write_attribute(:j_document, (JSON.parse(params.to_json)))
     document.save!
    end
    document
  end 

  def get_pdf_file(params)
    tempfile = params['document_pdf'][:tempfile]
    filename = params['document_pdf'][:filename]
    FileUtils.copy(tempfile.path, "./storage/#{filename}")
  end

  def check_document_pdf
    Document.find_each do |doc|
      puts doc.document_pdf.attached? 
     end
  end

  def attach_pdf(params, document)
    pdf = params[:document_pdf][:filename]
    newpdfname = ""
    newpdfname.concat(document.read_attribute(:document_name))
    newpdfname.concat("-")
    newpdfname.concat(Time.now.to_s)
    document.document_pdf.attach(io: File.open('./storage/'+pdf), filename: newpdfname) if !document.document_pdf.attached?
    document
  end

  def split_filename(filename)
    chunks = filename.split
    chunks 
  end

  def get_version(filename)
    m = /(?<version>(\d?\.\d)+)/.match(filename)
    puts m[:version]
    m[:version]
  end

  def is_filename_valid(filename)
    m = /(?<version>(\d?\.\d)+)/.match(filename)
    !m.nil?
  end
 
  def link_file(params) 
    name = params['key'].concat('.pdf')
    file_name_path = "#{Rails.root}/public/#{name}"
    puts "link_file is #{name}"
    send_file(
      file_name_path,
         filename: "#{name}",
         disposition: 'inline',
         type: "application/pdf"
     )
    FileUtils.chmod 0755, file_name_path.to_s
  end

end
