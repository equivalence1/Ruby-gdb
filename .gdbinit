define evalr
  call rb_p(rb_eval_string_protect($arg0, (int*)0))
end
document evalr
  Evaluate an arbitrary Ruby expression from current gdb context.
end

define redirect_stdout
  call rb_eval_string("$_old_stdout, $stdout = $stdout, File.open('/tmp/ruby-debug.' + Process.pid.to_s, 'a'); $stdout.sync = true")
end
document redirect_stdout
  Hijack Ruby $stdout and redirect it to /tmp/ruby-debug-<pid>. 
  Useful to redirect ruby macro output to a separate file.
end

define rb_finish
  call rb_eval_string_protect("set_trace_func lambda{|event, file, line, id, binding, classname| if /line/ =~ event; sleep 0; set_trace_func(nil) end}", (int*)0)
  tbreak rb_f_sleep
  cont
end
document rb_finish
  Execute the current Ruby method until it returns and interrupts the 
  process at a safe point (the rb_f_sleep function). You should
  always call this macro before evaling Ruby code in gdb.
end

define load_debugger
    evalr("puts \"loading debugger\"")
    evalr("require_relative \"/home/user/Ruby/GDB/debugger_loader\"")
end
