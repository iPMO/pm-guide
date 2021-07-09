require 'daru'

class Project

  attr_accessor :tuples, :multi_index, :vector_pre, :vector_init, :vector_sub1, :vector_sub2, :vector_final, :default_dataframe, :documents

  def initialize(project)
   Rails.logger.info "initializing #{project}"
   @default_dataframe = nil 
   @project_dataframe = nil

   # Variables for creating data frame structure
   @tuples = [
    [:corporate,0],
    [:direct,1],
    [:manage,2],
    [:manage,3],
    [:manage,4],
    [:manage,5],
    [:manage,6],
    [:manage,7],
    [:deliver,8]
   ]

   @multi_index = Daru::MultiIndex.from_tuples(@tuples)

   @vector_pre0 = ['0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7',nil]
   @vector_pre1 = ['1.0','1.1','1.2','1.3','1.4','1.5','1.6','1.7',nil]
   @vector_init2= ['2.0','2.1',nil,'2.3','2.4','2.5',nil,nil,nil]
   @vector_init3= ['3.0','3.1',nil,'3.3','3.4','3.5',nil,nil,nil]
   @vector_sub4 = ['4.0','4.1','4.2','4.3','4.4','4.5','4.6','4.7','4.8']
   @vector_sub5 = ['5.0','5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8']
   @vector_sub6 = ['6.0','6.1',nil,nil,nil,'6.5','6.6','6.7','6.8']
   @vector_fina1= ['7.0','7.1',nil,'7.3','7.4','7.5','7.6','7.7',nil]
   @vector_fina2= ['8.0','8.1','8.2','8.3','8.4','8.5','8.6','8.7',nil]

   @order_mi = Daru::MultiIndex.from_tuples([
    [:pre,0],
    [:pre,1],
    [:initiation,2],
    [:initiation,3],
    [:subsequent,4],
    [:subsequent,5],
    [:subsequent,6],
    [:final,7],
    [:final,8]
    ])

   create_default_dataframe


    if project != nil 
     @documents = Hash.new
     Document.where(project_name: project.upcase).each do |d| 
      d.document_pdf_download 
      content_type = d.document_pdf.blob.content_type
      key = '/show/'.concat(d.document_pdf.key).concat('/').concat(content_type).concat('/').concat(d.read_attribute(:document_name))
      doc_type = d.read_attribute(:document_type)
      ver_number = d.read_attribute(:process_step).to_s
      value = String.new(doc_type).concat(':').concat(ver_number)
      print_documents_hash
      @documents.store(key,value) 
     end
    else
      @documents = create_default_dataframe_documents
    end
  end

  def print_documents_hash
    Rails.logger.info "Listing documents hash for project"
    @documents.each {|key, value| Rails.logger.info "key: #{key} => value: #{value}"} 
  end

  # Thias method is replacing the default_dataframe values
  # in format x.y.z with the link to an document
  def get_project_dataframe
    if @documents != nil
     @project_dataframe = @default_dataframe.clone_structure
     Rails.logger.info "processing #{@documents}"
     @documents.each {|key, value|  
     arrY = value.split(/:/)
      if arrY != nil then
       version = arrY[1]
       arr = version.split(/\./) 
       Rails.logger.info "version is #{version}"
        for j in 0..8
         for i in 0..8
           if @default_dataframe[j][i] == version then
             Rails.logger.info "Default DataFrame >> found version in #{j} : #{i}"
            if @project_dataframe[j][i] == nil then
              Rails.logger.info "Project DataFrame  @ #{j} : #{i} not nil" 
             @project_dataframe[j][i] = key 
             Rails.logger.info "#{key} put to DF[#{j}][#{i}]"
            else 
             next 
            end
           else
             if @project_dataframe[j][i] != nil then
             else
              @project_dataframe[j][i] = nil
             end
           end
         end
        end
      else
       next
      end
    }
    else
      @project_dataframe = @default_dataframe
    end
    @project_dataframe
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

  def create_default_dataframe_documents
    @one = @vector_pre0+@vector_pre1+@vector_init2+@vector_init3+@vector_sub4+@vector_sub5+@vector_sub6+@vector_fina1+@vector_fina2
    @oHash = Hash.new
    @one.each{|i| @oHash.store(i,i)}
    @oHash
  end

end
