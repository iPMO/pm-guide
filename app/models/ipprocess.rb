require 'daru'

class Ipprocess < Prince2process

  def initialize
   super
   Rails.logger.info "Ipprocess initialization in progress"
  end

  def get_dataframe(df)
   df = df[:initiation].row[3..5] 
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
