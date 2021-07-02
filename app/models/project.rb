require 'daru'

class Project

  attr_accessor :tuples, :multi_index, :vector_pre, :vector_init, :vector_sub1, :vector_sub2, :vector_final, :default_dataframe, :documents

  def initialize(project)
    puts "###### initialize reached for #{project}"
   @default_dataframe = nil 
   @project_dataframe = nil

   # Variables for creating data frame structure
   @tuples = [
    [:corporate,0],
    [:direct,1],
    [:manage,2],
    [:manage,3],
    [:deliver,4]
   ]

   @multi_index = Daru::MultiIndex.from_tuples(@tuples)

   @vector_pre = [0.0,0.1,0.2,0.3,nil]
   @vector_init =[1.0,1.1,1.2,1.3,nil]
   @vector_sub1 =[2.0,2.1,2.2,2.3,2.4]
   @vector_sub2 =[3.0,3.1,nil,3.3,3.4]
   @vector_final=[4.0,4.1,4.2,4.3,nil]

   @order_mi = Daru::MultiIndex.from_tuples([
    [:pre,0],
    [:initiation,1],
    [:subsequent,2],
    [:subsequent,3],
    [:final,4]
    ])

   create_default_dataframe

   puts "++++ details to be loaded for #{project}"

    if project != nil 
     @documents = Hash.new
     Document.where(project_name: project.upcase).each do |d| 
      d.document_pdf_download 
      content_type = d.document_pdf.blob.content_type
      key = '/show/'.concat(d.document_pdf.key).concat('/').concat(content_type)
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
    puts "********* Listing documents hash for project"
    @documents.each {|key, value| puts "key: #{key} => value: #{value}"} 
  end

  # Thias method is replacing the default_dataframe values
  # in format x.y.z with the link to an document
  def get_project_dataframe
    if @documents != nil
     @project_dataframe = @default_dataframe.clone_structure
     puts "processing #{@documents}"
     @documents.each {|key, value|  
       arrY = value.split(/:/)
       arr = arrY[1].split(/\./) 
       puts "array = #{arr.to_s}"
       @project_dataframe[arr[0].to_i][arr[1].to_i] = key 
    }
    else
      @project_dataframe = @default_dataframe
    end
    @project_dataframe
  end

  def create_default_dataframe
    puts "tuples are #{get_tuples}"
    puts "vector_pre = #{get_vector_pre}"
   @default_dataframe = Daru::DataFrame.new([@vector_pre, @vector_init, @vector_sub1, @vector_sub2, @vector_final], order: @order_mi, index: @multi_index)
  end

  def get_tuples
   @tuples
  end

  def get_vector_pre
   @vector_pre
  end

  def get_documents
    puts "documents are #{@documents}"
   @documents
  end

  def create_default_dataframe_documents
    @one = @vector_pre+@vector_init+@vector_sub1+@vector_sub2+@vector_final
    @oHash = Hash.new
    @one.each{|i| @oHash.store(i,i)}
    @oHash
  end

end
