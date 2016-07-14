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

puts "changing ARGV"

old_argv = ARGV.clone

# NO!!!!
# wtf static? new_argv should be exactly what IDE passed
#new_argv = ["-a", "--disable-int-handler", "--evaluation-timeout", "10", "--rubymine-protocol-extensions", "--port", "35690", "--host", "0.0.0.0", "--dispatcher-port", "40252"]

ARGV.reject {|x| true}
new_argv.each do |x|
    ARGV << x
end

puts "ARGV changed."
print "old ARGV: "; p old_argv; puts ""
print "new ARGV: "; p ARGV; puts "\n"

puts "Changing $0"

old_0 = $0.clone
$0 = path_to_rdebug

puts "$0"
print "old 0: "; print old_0; puts ""
print "new 0: "; print $0; puts "\n"

puts "loading debugger"
load path_to_rdebug

puts "chaging ARGV and $0 back"

$0 = old_0
ARGV.reject {|x| true}
old_argv.each do |x|
    ARGV << x
end

puts "Debugger is working!"
end
