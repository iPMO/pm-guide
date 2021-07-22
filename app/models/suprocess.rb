require 'daru'
require 'prince2process.rb'

 class Suprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Suprocess initialization in progress"
  end 

  def get_dataframe(df)
    df = df[:pre].row[1..7]
    df
  end

  def set_refproc_dataframe(df)
    Rails.logger.info "set_refproc_dataframe = #{df}"
    df = get_dataframe(df)
    super(df)
  end

  def set_proc_dataframe(df)
    df = get_dataframe(df)
    super(df)
  end

 end
