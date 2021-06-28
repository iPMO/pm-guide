require 'daru'

class Project 
  @documents = nil 
  @default_data_frame = nil 
  @project_data_frame = nil

  def initialize(project)
    @documents = Hash.new
    Document.where(project_name: project).each do |d| 
     @documents.store(d.id,d.read_attribute(:process_step)) 
    end
  end

  def print_documents_hash
    @documents.each {|key, value| puts "key: #{key} => value: #{value}"} 
  end

  def self.get_default_data_frame
    @default_data_frame = Daru::DataFrame.new(
      {
        'Pre' => ['0.0.z','0.1.z','0.2.z','0.3.z','0.4.z'],
        'Initiation' => ['1.0.z','1.1.z','1.2.z','1.3.z','1.4.z'],
        'Subsequent1' => ['2.0.z','2.1.z','2.2.z','2.3.z','2.4.z'],
        'Subsequent2' => ['3.0.z','3.1.z','3.2.z','3.3.z','3.4.z'],
        'Final' => ['4.0.z','4.1.z','4.2.z','4.3.z','4.4.z']
      },
      index: ['Corporate', 'Direction', 'Management1','Management2', 'Delivery']
    )
   @default_data_frame 
  end

  def get_documents_hash
   @documents
  end

  def get_project_data_frame

  end
end
