require 'daru'

class Project 
  @documents = {}
  @data_frame = Daru::DataFrame.new(
    {
     'Pre' => ['0.0.z','0.1.z','0.2.z','0.3.z'],
     'Initiation' => ['1.0.z','1.1.z','1.2.z','1.3.z'],
     'Subsequent' => ['2.0.z','2.1.z','2.2.z','2.3.z'],
     'Final' => ['3.0.z','3.1.z','3.2.z','3.3.z']
     },
     index: ['Corporate', 'Direction', 'Management', 'Delivery']
  )

  def initialize(project)
   @documents = Document.where(project_name: project).each do |d| 
     @documents.store(d.id,d.process_step) 
    end
    puts "documents hash #{@documents} for project #{project} created" 
    default_data_frame
  end

  def default_data_frame
    @data_frame
  end
end
