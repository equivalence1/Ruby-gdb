pid = 2969

puts "in wrapper with ARGV:"

ARGV.insert(1,"-a")
ARGV.insert(2, "#{pid}")

p ARGV

s_argv = "#{ARGV}"

cmd = "gdb $(which ruby) #{pid} -ex \"evalr(\\\"require_relative '/home/user/Ruby/GDB/debugger_loader'; load_debugger(#{s_argv.gsub("\"", "'")})\\\")\" -ex \"evalr(\\\"puts 'continuing'\\\")\" -ex \"q\""
#cmd = "gdb $(which ruby) #{pid} -ex \"evalr(\\\"puts 'continuing'\\\")\" -ex \"q\""
puts "will execute\n#{cmd}"
`#{cmd}`

puts "done. we are in #{__FILE__}"
while true
end
