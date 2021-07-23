require 'daru'
require 'prince2process.rb'

 class Cpprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Cpprocess initialization in progress"
  end 

  def get_dataframe(df)
    df = df.at 7..8
    df.delete_row(0)
    df.delete_row(0)
    df.delete_row(0)
    df.delete_row(5)
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
