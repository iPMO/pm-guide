require 'daru'

class Project

  attr_accessor :tuples, :multi_index, :vector_pre, :vector_init, :vector_sub1, :vector_sub2, :vector_final, :default_dataframe

  def initialize(project)
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

   @vector_pre = [0.0,0.1,0.2,0.3,0.4]
   @vector_init =[1.0,1.1,1.2,1.3,1.4]
   @vector_sub1 =[2.0,2.1,2.2,2.3,2.4]
   @vector_sub2 =[3.0,3.1,3.2,3.3,3.4]
   @vector_final=[4.0,4.1,4.2,4.3,4.4]

   @order_mi = Daru::MultiIndex.from_tuples([
    [:pre,0],
    [:initiation,1],
    [:subsequent,2],
    [:subsequent,3],
    [:final,4]
    ])

   create_default_dataframe

    if project != nil 
     @documents = Hash.new
     Document.where(project_name: project).each do |d| 
     @documents.store(d.id,d.read_attribute(:process_step)) 
     end
    else
      @document = nil
    end
  end

  def print_documents_hash
    @documents.each {|key, value| puts "key: #{key} => value: #{value}"} 
  end

  # Thias method is replacing the default_dataframe values
  # in format x.y.z with the link to an document
  def get_project_dataframe
    if @documents != nil
     @project_dataframe = @default_dataframe.clone_structure
     puts "processing #{@documents}"
     @documents.each {|key, value|  
       arr = value.split(/\./) 
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

end
