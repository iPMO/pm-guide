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
    [:manage,4],
    [:manage,5],
    [:manage,6],
    [:manage,7],
    [:deliver,8]
   ]

   @multi_index = Daru::MultiIndex.from_tuples(@tuples)

   @vector_pre0 = ['0.0.2','0.1.2','0.2.z','0.3.1','0.4.z','0.5.1','0.6.z','0.7.z',nil]
   @vector_pre1 = ['1.0.2','1.1.z','1.2.z','1.3.z','1.4.2','1.5.z','1.6.2','1.7.z',nil]
   @vector_init2= ['2.0.2','2.1.z',nil,'2.3.z','2.4.z','2.5.z',nil,nil,nil]
   @vector_init3= ['3.0.2','3.1.z',nil,'3.3.z','3.4.z','3.5.z',nil,nil,nil]
   @vector_sub4 = ['4.0.2','4.1.z','4.2.z','4.3.z','4.4.z','4.5.z','4.6.z','4.7.z','4.8.z']
   @vector_sub5 = ['5.0.2','5.1.z','5.2.z','5.3.z','5.4.z','5.5.z','5.6.z','5.7.z','5.8.z']
   @vector_sub6 = ['6.0.2','6.1.z',nil,nil,nil,'6.5.z','6.6.z','6.7.z','6.8.z']
   @vector_fina1= ['7.0.2','7.1.z',nil,'7.3.z','7.4.z','7.5.z','7.6.z','7.7.z',nil]
   @vector_fina2= ['8.0.2','8.1.z','8.2.z','8.3.z','8.4.z','8.5.z','8.6.z','8.7.z',nil]

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
       if arrY != nil then
        arr = arrY[1].split(/\./) 
        if arr[2] !='z' then
          puts "array = #{arr.to_s}"
        else
         next
        end
       else
        next
       end
       @project_dataframe[arr[0].to_i][arr[1].to_i] = key 
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
    puts "documents are #{@documents}"
   @documents
  end

  def create_default_dataframe_documents
    @one = @vector_pre0+@vector_pre1+@vector_init2+@vector_init3+@vector_sub4+@vector_sub5+@vector_sub6+@vector_fina1+@vector_fina2
    @oHash = Hash.new
    @one.each{|i| @oHash.store(i,i)}
    @oHash
  end

end
