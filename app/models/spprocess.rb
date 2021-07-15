require 'daru'
require 'prince2process.rb'

 class Spprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Spprocess initialization in progress"
  end 

  def set_refproc_dataframe(df)
    Rails.logger.info "set_refproc_dataframe = #{df}"
    df = df[:pre].row[1..7]
    super(df)
  end

  def set_proc_dataframe(df)
    df = df[:pre].row[1..7]
    super(df)
  end

 end
