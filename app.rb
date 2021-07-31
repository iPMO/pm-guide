require 'rubygems'
require 'sinatra/base'
require 'pg'
require 'mustermann'


class IpMO < Sinatra::Base
  include ActionController::Streaming

  set :views, settings.root + '/app/views/'
  set :static, :true
  set :raise_errors, :true
  logger = Rails.logger

  before '*' do
   path = request.path 
   begin
    conn = PG::Connection.new(:dbname => "ipmo_#{Rails.env}")
    logger.info "DB CONNECTED ????? #{conn}"
    logger.info "#################### redirection to #{path}"
   rescue 
     halt 401,"<h1><font size='48px' color='red'>POSTGRES NOT RUNNING</h1>"
   end
  end

  get '/error' do
    erb :dbconnerror, :layout => :application 
    halt
  end

  # get the index page
  get '/' do
    redirect 'details/PRJ'
    #erb :prince2pmguide_main, :layout => :application
  end

  get '/themes' do
    erb :themes, :layout => :application
  end

  get '/themes/:theme' do
    @theme = params['theme']
    params['fixcontent'] = "#{@theme}_theme"
    erb :themes, :layout => :application
  end

  # show the upload document view 
  get '/upload' do
    erb :upload, :layout => :application
  end

  post '/upload' do
    check(params)
    get_pdf_file(params)
    doc = new_document(params)
    if doc.nil? then
      code = "<% Error uploading document %>"
      erb code
    else
     erb :done, :layout => :application
    end
  end

  # route to list all projects
  get '/list' do
    puts 'going to list all projects'
    check_document_pdf
    erb :list, :layout => :application
  end
  
  # route for listing the project with name :project
  get '/list/:project_name' do
    check(params)
    @params = params
    erb :list, :layout => :application
  end

  get '/show/:key/application/:content_type/:filename' do
  #get '/show/:slug(.:ext)?' do
   #logger.info "show slug(#{params[:slug]}"
   key = params['key']
   filename = params['filename']
   content_type = params['content_type']
   if content_type == 'pdf' 
    then extension = '.pdf'
    else 
      extension = ".docx"
    #  copykey2filename(key,extension,filename) 
   end
   params['extension'] = extension
   logger.info "showing doc with #{params}"
   file_name = 'public/'.concat(key)
   link_file(params)
   @params = params
   erb  :show, :layout => :application 
  end

  get '/show/:slug(.:ext)?' do
    logger.info "** slugged with #{params} is a Hash #{params.is_a? Hash}"
    params.each{|k,v| logger.info "#{k} => #{v}"}

    opsHash = {"key" => {},"file_name" => {},"content_type" => {}}
    
    params.each{|k,v| 
      logger.info "#{k} => #{v}"
      arr = k.split('.')
      hKey = arr[0]
      hCount = arr[1]
      logger.info "ppppppppppppppppppp going to process opsHash[#{hKey}] => #{hCount}"
      if opsHash.has_key? hKey 
        then
          opsHash["#{hKey}"].store("#{hCount}",v)
      else
        next
      end
    }
    logger.info "oooooooooooooo opsHash[ #{opsHash} ]"

    opsHash.each{|k,v| 
      logger.info "+++++++++ opsHash[#{k}] {"
      logger.info "------------- #{v} { "
      v.each{|k,v| 
        logger.info " ----------------- #{k} : #{v}"
      }
      logger.info " .............. }"

      logger.info "+++++++++ } "
    }
    
    @params = link_file(opsHash)
    Rails.logger.info "************************************************************************* Showing document with params[#{@params}]"
    erb :show, :layout => :application 
  end

  # route for details of a certain project
  get '/details/:project_name' do
    params['fixcontent'] = "prince2pmguide_main"
    check(params)
    project = params['project_name']
    logger.info "------- loading details/#{project}"

    if project != nil 
      then 
      @project = Project.new(project)
    else
      code = "<% <h1>Error!!! Unknown project as parameter</h1> %>"
      erb code
    end
    logger.info "#{@project} created"
    @params = params
    erb :details, :layout => :application
  end

  get '/details/:project_name/:process' do
    logger.info "############################# do it get here?"
    process = params['process']
    project = params['project_name']
    logger.info "loading process #{process} for #{project}"
    @project = Project.new(project)
    params['fixcontent'] = "#{@project.get_proc_abbr(process.to_i).downcase}_process"
    erb :details, :layout => :application
  end

  get '/home/sinatra/code/pm-guide/public/pdf_logo.jpeg' do
    File.read(File.join('public', 'pdf_logo.jpeg'))
  end

  get '/home/sinatra/code/pm-guide/public/letter.jpeg' do
    File.read(File.join('public', 'letter.jpeg'))
  end

  get '/home/sinatra/code/pm-guide/public/word_logo.jpeg' do
    File.read(File.join('public', 'word_logo.jpeg'))
  end

  get '/home/sinatra/code/pm-guide/public/doc_logo.jpeg' do
    File.read(File.join('public', 'doc_logo.jpeg'))
  end

  get '/app/assets/stylesheets/application.css'  do
    File.read(File.join('app','assets','stylesheets','application.css'))
  end
  
  get '/home/sinatra/code/pm-guide/public/application.css' do
    File.read(File.join('public','application.css'))
  end

  get /\d\.\d/ do
    erb :details,  :layout => :application
  end

  get %r{.*/stylesheets/application.css} do
        redirect('app/assets/stylesheets/application.css')
  end

  get '/public/BC_BRP.png' do
    File.read(File.join('public', 'BC_BRP.png'))
  end

  get '/public/upload.png' do
    File.read(File.join('public', 'upload.png'))
  end

  get '/public/PDMC.png' do
    File.read(File.join('public', 'PDMC.png'))
  end

  get '/public/LEVELS_OF_PLAN.png' do
    File.read(File.join('public', 'LEVELS_OF_PLAN.png'))
  end

  get '/public/PLAN_ANALYSE_THE_RISKS.png' do
    File.read(File.join('public', 'PLAN_ANALYSE_THE_RISKS.png'))
  end

  get '/public/PBS.png' do
    File.read(File.join('public', 'PBS.png'))
  end
  
  get '/public/PLANS_PURPOSE.png' do
    File.read(File.join('public', 'PLANS_PURPOSE.png'))
  end

  # ROUTES are OVER, here comes the HELPES
  # method to list the parameter
  def check(params)
    params.each do |p|
      logger.info "++++++++++++++++ found param[#{p}]"
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
     document.write_attribute(:project_name, chunks[0].upcase)
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
      logger.info "#{doc} is attached #{doc.document_pdf.attached?}"
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
    logger.info "~~~~~~ going to split file=> #{filename.to_s}"
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
 
  def link_file(opsHash) 
    logger.info "+++++++ link_file for opsHash.size(#{opsHash.size})"

    for i in 0..opsHash["key"].size-1 do 
      key = opsHash["key"][i.to_s] 
      type = opsHash["content_type"][i.to_s] 
      filename = opsHash["file_name"][i.to_s]
      extension = filename.split('.')[1]
      tmpfile_name = key.concat(extension)
      file_name_path = "#{Rails.root}/public/#{tmpfile_name}"
      sendfile2show(file_name_path, filename, extension)
      params[:key] = key
      params['extension'] = extension
      params['type'] = type
    end
    params
  end

  def copykey2filename(tmpfile_name,tmpfile_extension,filename)
    logger.info "copying #{tmpfile_name}.#{tmpfile_extension} 2 #{filename}"
    file_name_path = "#{Rails.root}".concat('/public/').concat(filename)
    file2copy = "#{Rails.root}/public/#{tmpfile_name}#{tmpfile_extension}"
    sendfile2show(file_name_path, "#{tmpfile_name}.#{tmpflie_extension}", tmpfile_extension)
  end

  def sendfile2show(file_name_path, name, extension)
    send_file(
      file_name_path,
      filename: "#{name}",
      disposition: 'inline',
      type: "#{extension}"
     )
    FileUtils.chmod 0755, file_name_path.to_s
  end

end
