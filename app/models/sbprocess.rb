require 'daru'
require 'prince2process.rb'

 class Sbprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Sbprocess initialization in progress"
  end 

  def get_dataframe(df)
    df = df.at 4..5
    df.delete_row(0)
    df.delete_row(0)
    for i in 0..3 do df.delete_row(3) end

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
