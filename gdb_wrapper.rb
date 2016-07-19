pid = 19743

def check_ruby_process
    begin
        Process.kill 0, pid
        comm_file = File.open("/proc/#{pid}/comm", "r")
        if !(comm_file =~ /ruby/)
            $stderr.puts "Process with pid #{pid} does not seem to be a ruby process. Aborting."
            exit 1
        end
        comm_file.close
    rescue
        $stderr.puts "Process with pid #{pid} does not exist. Aborting."
        exit 1
    end
end

ARGV.insert(1,"-a")
ARGV.insert(2, "#{pid}")

s_argv = "#{ARGV}"

commands_list = []

def commands_list.add_command(command)
	self << "-ex \"#{command}\""
end

# TODO I didn't find easy way to define gdb functions and use them
# I tryed `-ex` and `-ix`. `-ex` can not parse define ..., `-ix` requerse
# some settings from ~/.gdbinit

path_to_debugger_loader = File.expand_path(File.dirname(__FILE__)) + "/debugger_loader"

# rb_finish: wait while excution comes to the next line
commands_list.add_command("call rb_eval_string_protect(\\\"set_trace_func lambda{|event, file, line, id, binding, classname| if /line/ =~ event; sleep 0; set_trace_func(nil); end}\\\", (int*)0)")
commands_list.add_command("tbreak rb_f_sleep")
commands_list.add_command("cont")

# evalr: loading debugger into the process
evalr = "call rb_p(rb_eval_string_protect(%s, (int*)0))"
commands_list.add_command("#{evalr}" % ["(\\\"require_relative '#{path_to_debugger_loader}'; load_debugger(#{s_argv.gsub("\"", "'")})\\\")"])

# q: exit gdb and continue process excution with debugger
commands_list.add_command("q")

#cmd = "gdb $(which ruby) #{pid} -ex \"rb_finish\" -ex \"evalr(\\\"require_relative '/home/user/Ruby/GDB/debugger_loader'; load_debugger(#{s_argv.gsub("\"", "'")})\\\")\" -ex \"evalr(\\\"puts 'continuing'\\\")\" -ex \"q\""

cmd = "gdb $(which ruby) #{pid} -nh #{commands_list.join(" ")}"

$stderr.puts "Fast Debugger "

`#{cmd}`

puts "done. we are in #{__FILE__}" #TODO debug

while true
end
