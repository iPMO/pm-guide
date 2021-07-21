require 'daru'
require 'prince2process.rb'

class Project

  attr_accessor :tuples, :multi_index, :vector_pre, :vector_init, :vector_sub1, :vector_sub2, :vector_final, :default_dataframe, :documents, :processes

  def initialize(project)
   Rails.logger.info "initializing #{project}"
   @default_dataframe = Prince2process.new.create_dataframe 
   @project_dataframe = nil
   @refproc_dataframe = nil
   @processes = []
   @documents = nil
   @ref_documents = nil

    if project != nil 
      @documents = get_documents_hash(project)
      @project_dataframe = get_dataframe(@documents)
      @ref_documents = get_documents_hash('PRJ')
      @refproc_dataframe = get_dataframe(@ref_documents)
    else
      @documents = create_default_dataframe_documents
    end
    if @processes.size == 0
      then set_processes([Spprocess.new(),Dpprocess.new(),nil,nil,nil,nil,nil]) 
    else
      Rails.logger.info "#{@processes} already set"
    end
  end

  def get_documents_hash(project)
    documents = Hash.new
    Document.where(project_name: project.upcase).each do |d|
    d.document_pdf_download
    content_type = d.document_pdf.blob.content_type
    key = '/show/'.concat(d.document_pdf.key).concat('/').concat(content_type).concat('/').concat(d.read_attribute(:document_name))
    doc_type = d.read_attribute(:document_type)
    ver_number = d.read_attribute(:process_step).to_s
    value = String.new(doc_type).concat(':').concat(ver_number)
    print_documents_hash(documents)
    documents.store(key,value)
   end
   documents
  end

  def print_documents_hash(documents)
    Rails.logger.info "Listing documents hash for project"
    documents.each {|key, value| Rails.logger.info "key: #{key} => value: #{value}"} 
  end

  # Thias method is replacing the default_dataframe values
  # in format x.y.z with the link to an document
  def get_dataframe(documents)
    if documents != nil
     project_dataframe = @default_dataframe.clone_structure
     #Rails.logger.info "processing #{@documents}"
     documents.each {|key, value|  
     arrY = value.split(/:/)
      if arrY != nil then
       version = arrY[1]
       arr = version.split(/\./) 
       #Rails.logger.info "version is #{version}"
        for j in 0..8
         for i in 0..8
           if @default_dataframe[j][i] == version then
             #Rails.logger.info "Default DataFrame >> found version in #{j} : #{i}"
            if project_dataframe[j][i] == nil then
             # Rails.logger.info "Project DataFrame  @ #{j} : #{i} not nil" 
             project_dataframe[j][i] = key 
             #Rails.logger.info "#{key} put to DF[#{j}][#{i}]"
            else 
             next 
            end
           else
             if project_dataframe[j][i] != nil then
             else
              project_dataframe[j][i] = nil
             end
           end
         end
        end
      else
       next
      end
    }
    else
      project_dataframe = @default_dataframe
    end
    project_dataframe
  end

  def create_default_dataframe
   @default_dataframe = Daru::DataFrame.new([@vector_pre0,@vector_pre1,@vector_init2,@vector_init3,@vector_sub4,@vector_sub5,@vector_sub6,@vector_fina1,@vector_fina2], order: @order_mi, index: @multi_index)
  end

  def get_tuples
   @tuples
  end

  def get_documents
    Rails.logger.info "documents are #{@documents}"
   @documents
  end

  def get_default_dataframe
    @default_dataframe
  end

  def get_project_dataframe
    @project_dataframe
  end

  def get_refproc_dataframe
    @refproc_dataframe 
  end

  def create_default_dataframe_documents
    @one = @vector_pre0+@vector_pre1+@vector_init2+@vector_init3+@vector_sub4+@vector_sub5+@vector_sub6+@vector_fina1+@vector_fina2
    @oHash = Hash.new
    @one.each{|i| @oHash.store(i,i)}
    @oHash
  end

  def set_processes(processes)
    for i in 0..processes.size do
      Rails.logger.info "processes[#{i}] = #{processes[i]}"
      process = processes[i]
      if process == nil then
        next
      else
        process.set_proc_dataframe(get_project_dataframe)
        process.set_refproc_dataframe(get_refproc_dataframe)
      end
    end
    @processes = processes
  end

  def get_processes
    @processes
  end

  def get_processes_status
    Rails.logger.info "We have currently #{get_processes.size} for this project"  
  end

end
