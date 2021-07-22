require 'daru'
require 'prince2process.rb'

 class Csprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Csprocess initialization in progress"
  end 

  def get_dataframe(df)
    df = df[:subsequent].row[5..7]
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
