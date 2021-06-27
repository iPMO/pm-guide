
class Document < ApplicationRecord
  include ActionController::Streaming

 # getter and setter for attributes
 attr_accessor :document_id
 attr_accessor :document_name
 attr_accessor :project_name
 attr_accessor :pm_standard
 attr_accessor :document_type
 attr_accessor :process_step
 attr_accessor :document_version
 attr_accessor :document_timestamp
 attr_accessor :document_blob
 attr_accessor :j_document

 # create ActiveStorage link
 has_one_attached :document_pdf
  
  
  def done?
    !document_pdf.nil?
  end

  def document_pdf_download
    key = document_pdf.key
    puts "downloading document with key : #{key}"
    document_pdf.open(tmpdir: 'storage/') do |file| FileUtils.cp(file,'public/'.concat(key).concat('.pdf')) 
    end

    #send_file(
    # "#{Rails.root}/public/#{key}.pdf",
    # filename: "#{read_attribute('document_name')}.pdf",
    # type: "application/pdf"
    #)

  end

  def default_data_frame
    data_frame = Daru::DataFrame.new(
        {
          'Pre' => ['0.0.z','0.1.z','0.2.z','0.3.z'],
          'Initiation' => ['1.0.z','1.1.z','1.2.z','1.3.z'],
          'Subsequent' => ['2.0.z','2.1.z','2.2.z','2.3.z'],
          'Final' => ['3.0.z','3.1.z','3.2.z','3.3.z']
           },
           index: ['Corporate', 'Direction', 'Management', 'Delivery']
    )
    data_frame
  end

end
