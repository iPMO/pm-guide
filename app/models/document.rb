
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

end
