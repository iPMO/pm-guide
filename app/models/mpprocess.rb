require 'daru'
require 'prince2process.rb'

 class Mpprocess < Prince2process

  def initialize
    super
    Rails.logger.info "Mpprocess initialization in progress"
  end 

  def get_dataframe(df)
    df = df.at 4..6
    for i in 0..7 do df.delete_row(0) end
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
