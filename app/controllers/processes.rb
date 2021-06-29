
class Processes 
  @mandatory_versions = Hash.new()
 
  # Constructor for the process instances with 2 arrays 
  # as parameter of necessary document with there versions number 
  # the arrays will be then translated to an hash
  def initialize(documents, versions)
    @mandoatory_versions = Hash[versions.zip(documents)] 
  end

  def is_eligable
    return false
  end


end
