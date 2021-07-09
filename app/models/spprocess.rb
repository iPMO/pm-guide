require 'daru'
require 'prince2process.rb'

 class Spprocess < Prince2process
  def initialize
    super
    Rails.logger.info "Spprocess initialization with datafame => #{@default_dataframe}"
    @proc_dataframe = @default_dataframe[:pre].row[1..7]
  end 

  def get_proc_dataframe
    Rails.logger.info "Spprocess #{@proc_dataframe} created"
    @proc_dataframe
  end
 end
