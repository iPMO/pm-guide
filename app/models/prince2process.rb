require 'daru'

 class Prince2process
   attr_accessor :tuples, :docs2be_updated, :docs2be_created, :proc_dataframe, :proc_stepnumber

  # Generic and Default Process initialization
  def initialize

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

    @docs2be_updated = Hash. new
    @docs2be_created = Array. new
    @proc_dataframe = Daru::DataFrame. new
    @proc_stepnumber = 0

    create_dataframe
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

 end
