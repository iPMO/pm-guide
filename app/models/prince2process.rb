require 'daru'

 class Prince2process
   attr_accessor :tuples, :docs2be_updated, :docs2be_created, :proc_dataframe, :proc_stepnumber, :default_dataframe

  # Generic and Default Process initialization
  def initialize
    Rails.logger.info "initiate Prince2process class"

    # initiate and create rows for dataframe
    @tuples = [
     [:corporate,0],
     [:direct,1],
     [:manage,2],
     [:manage,3],
     [:manage,4],
     [:manage,5],
     [:manage,6],
     [:manage,7],
     [:deliver,8]
    ]
    
    @multi_index = @multi_index = Daru::MultiIndex.from_tuples(@tuples)

    # initiate and create values for dataframe
    @vector_pre0 = ['0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7',nil]
    @vector_pre1 = ['1.0','1.1','1.2','1.3','1.4','1.5','1.6','1.7',nil]
    @vector_init2= ['2.0','2.1',nil,'2.3','2.4','2.5',nil,nil,nil]
    @vector_init3= ['3.0','3.1',nil,'3.3','3.4','3.5',nil,nil,nil]
    @vector_sub4 = ['4.0','4.1','4.2','4.3','4.4','4.5','4.6','4.7','4.8']
    @vector_sub5 = ['5.0','5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8']
    @vector_sub6 = ['6.0','6.1',nil,nil,nil,'6.5','6.6','6.7','6.8']
    @vector_fina1= ['7.0','7.1',nil,'7.3','7.4','7.5','7.6','7.7',nil]
    @vector_fina2= ['8.0','8.1','8.2','8.3','8.4','8.5','8.6','8.7',nil]

    # initiate and create columns
    @order_mi = Daru::MultiIndex.from_tuples([
     [:pre,0],
     [:pre,1],
     [:initiation,2],
     [:initiation,3],
     [:subsequent,4],
     [:subsequent,5],
     [:subsequent,6],
     [:final,7],
     [:final,8]
    ])

    @proc_dataframe = Daru::DataFrame. new
    @refproc_dataframe = Daru::DataFrame.new
    @proc_stepnumber = 0

    @default_dataframe = create_dataframe
  end

  def create_dataframe
    @default_dataframe = Daru::DataFrame.new(
     [
      @vector_pre0,
      @vector_pre1,
      @vector_init2,
      @vector_init3,
      @vector_sub4,
      @vector_sub5,
      @vector_sub6,
      @vector_fina1,
      @vector_fina2
     ], 
     order: @order_mi, 
     index: @multi_index
   )
   @default_dataframe
  end

  def get_default_dataframe
    @default_dataframe
  end

  # checks if the process is ready for next stage
  def is_eligable?
    proc_dataframe = get_proc_dataframe
    proj_dataframe = get_refproc_dataframe
    nextstage = false
    Rails.logger.info "proc_dataframe[#{proc_dataframe.nil?}]"
    if proc_dataframe != nil 
    then
      Rails.logger.info "proj_dataframe[#{proj_dataframe.nil?}]"
      if proj_dataframe != nil
       then
        Rails.logger.info "starting comparation"  
        array= []
        ccol = 0
        proj_dataframe.each{|col|
          puts "column: #{ccol}"
          crow = 0
          col.each{|value|
            if value.nil?
              then 
              crow = crow+1
              next
            else
             pvalue = proc_dataframe[ccol][crow]
             arra = value.split("/")
             arr = arra[5].split(" ")
             ar = arr[3].split('.')
             ver = "#{ar[0]}.#{ar[1]}"
             match = "#{arr[2]} #{ver}"
             Rails.logger.info "#{match}"
             Rails.logger.info "proj_dataframe[#{crow}]-->#{match} : proc_dataframe[#{crow}]-->#{pvalue}"
             if pvalue == nil  
               then 
                nextstage = false 
             else 
               nextstage = pvalue.include? "#{match}"
               if match 
                 then 
                   proc_dataframe[ccol][crow] = match 
                   Rails.logger.info "changed proc_datframe[#{ccol}][#{crow}] = #{match}"
               else
                 next 
               end
             end
             crow = crow+1
            end
          }
          ccol = ccol+1
        }
      else
        nextstage = false
      end 
    else
      nextstage = false
    end
    Rails.logger.info  "value are #{nextstage} equal"
    #set_proc_dataframe(proc_dataframe)
    nextstage
  end

  def get_proc_dataframe
    Rails.logger.info "#{@proc_dataframe} available"
    @proc_dataframe
   end

   def set_proc_dataframe(df)
     Rails.logger.info "???????????????? got this #{df} to set as proc_dataframe"
     @proc_dataframe = df
   end

  def get_refproc_dataframe
    Rails.logger.info "#{@refproc_dataframe} available"
    @refproc_dataframe
  end

  def set_refproc_dataframe(df)
    Rails.logger.info "????????????????? got this #{df} to set as refproc_dataframe"
    @refproc_dataframe = df
  end

 end
