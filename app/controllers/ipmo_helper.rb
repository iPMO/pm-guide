require 'zip'

class IpmoHelper

  def initialize 
    Rails.logger.info "loading Ipmo Helper class"
    Rails.logger.info "Following Helper Methods are available: "
    Rails.logger.info "\t get_zip_file(Array::file_names, String:file_path, String:zip_name) - Creating temporary zip file for download or attachment"
  end

  def get_zip_file(file_names, file_path, zip_name)
    zip_file = Tempfile.new(zip_name)
    Rails.logger.info "zip_file #{zip_name} from #{file_path}/#{file_names} created in #{zip_file.path}"

    begin
      Zip::File.open(zip_file.path, Zip::File::CREATE) do |zipfile|
        file_names.each do |filename| 
          zipfile.add(filename,File.join(file_path, filename))
        end
      end
      src = "#{zip_file.path}"
      dest = "#{file_path}/#{zip_name}"
      sFilename = File.basename(dest)
      Rails.logger.info "copying #{zip_file} from #{src} to #{dest}"
      FileUtils.cp(src,dest)
    rescue => e
      Rails.logger.error "ERROR_IpmoHelper.get_zip_data: #{e.class} #{e.message}"
    ensure
      zip_file.close unless zip_file.nil?
      zip_file.unlink unless zip_file.nil?
    end
    sFilename
  end

end
