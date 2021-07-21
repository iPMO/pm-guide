require 'daru'

class Dpprocess < Prince2process

  def initialize
   super
   Rails.logger.info "Spprocess initialization in progress"
  end

  def get_dataframe(df)
   df = df.at 2..8
   for i in 0..7 do 
     Rails.logger.info "---->get_dataframe:delete.row(#{i})" 
    if i !=0 
     then 
      df.delete_row(1) 
    else 
      df.delete_row(i) 
    end 
   end
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
