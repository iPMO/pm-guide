
class DocumentController < Sinatra::Base
  include ActionController::Streaming


  ##send_file(
  # "#{Rails.root}/public/#{key}.pdf",
  #  filename: "#{read_attribute('document_name')}.pdf",
  #  type: "application/pdf"
  #)

end
