#########################################
#                                       #
# This code should be evaluated (evalr) #
# inside `gdb` after attaching and then #
# it executed you should dettach `gdb`  #
# in order to continue running script   #
# with debugger turned on.              #
#                                       #
#########################################

def load_debugger(new_argv)
  path_to_rdebug = "/home/user/Ruby/ruby-debug-ide/bin/rdebug-ide"

  old_argv = ARGV.clone
  ARGV.reject {|x| true}
  new_argv.each do |x|
    ARGV << x
  end
  
  old_0 = $0.clone
  $0 = path_to_rdebug

  load path_to_rdebug

  $0 = old_0
  ARGV.reject {|x| true}
  old_argv.each do |x|
    ARGV << x
  end
end
