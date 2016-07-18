#ruby-debug-ide::bin/rdebug-ide

1. Тупо разбор `opts`
2. Есть модуль `Debugger`. Он живет в `lib` гема (может debase тоже часть этого модуля? Надо проверить). Выставляем ему какие-то значения

```Ruby
Debugger::ARGV = ARGV.clone

Debugger::RDEBUG_SCRIPT = rdebug_path
    
# save script name
Debugger::PROG_SCRIPT = ARGV.shift

# set options
Debugger.keep_frame_binding = options.frame_bind
Debugger.tracing = options.tracing
Debugger.evaluation_timeout = options.evaluation_timeout
Debugger.catchpoint_deleted_event = options.catchpoint_deleted_event || options.rm_protocol_extensions
Debugger.value_as_nested_element = options.value_as_nested_element || options.rm_protocol_extensions
```

3. Затем, собственно, вызывается сам дебаг

```Ruby
Debugger.debug_program(options)
```

#ruby-debug-ide::lib/ruby-debug-ide.rb

Тут лежит `debug_program(options)` модуля `Debugger`

Цепь примерно такая:

```Ruby
debug_program(options)
    prepare_debugger(options)
        # def start_server(host = nil, port = 1234, notify_dispatcher = false)
        start_server(options.host, options.port, options.notify_dispatcher)
            start
            start_control(host, port, notify)
                # возваращает @control_thread, который что-то делает TODO

        # wait for 'start' command
        # тут proceed -- это ConditionalVariable
        @mutex.synchronize do
            @proceed.wait(@mutex) # TODO why do we need this?
        end
    bt = debug_load(abs_prog_script, options.stop, options.load_mode)
    if bt && !bt.is_a?(SystemExit)
        $stderr.print "Uncaught exception: #{bt}\n"
        $stderr.print Debugger.cleanup_backtrace(bt.backtrace).map{|l| "\t#{l}"}.join("\n"), "\n"
    end
end
```

#debase::lib/rbx.rb
```Ruby
def debug_load(file, stop=false, incremental_start=true)
    setup_tracepoints
    prepare_context
    begin
        load file
        nil
    rescue Exception => e
        e
    end
end
```

В этом-то `load`'e все и поисхoдит -- мы запускаем нашу прогу. Мне кажется, что это `load`, который реализован в Rubinius в https://github.com/rubinius/rubinius/blob/master/core/code\_loader.rb

`Rubinius::Channel` -- это просто стек, в который можно сделать `send` и `request`.

`Debase::Context` использует `Debase.heandler`. Он устанавливается в `lib/ruby-debug-ide.rb:123`. Это просто `EventProcessor` (лежит там же)


#Configs
genuine run configuration: `-e $stdout.sync=true;$stderr.sync=true;load($0=ARGV.shift)` (do we need `at_exit{sleep(1)}`?)
run without attaching:     `-e $stdout.sync=true;$stderr.sync=true;ARGV.shift;load($0=\"/home/user/Ruby/ruby-debug-ide/bin/rdebug-ide\")`
my run configuration       `-e $stdout.sync=true;$stderr.sync=true;ARGV.shift;load($0=\"/home/user/Ruby/GDB/gdb_wrapper.rb\")`


#GLOBAL TODO LIST:

1. Stop command

checkout /home/user/IDEA/community/platform/xdebugger-impl/src/com/intellij/xdebugger/impl/XDebugSessionImpl.java:900
(search for `ProcessHandler processHandler = myDebugProcess.getProcessHandler();`)

`destroyProcessImpl` calls `notifyProcessTerminated` 

2. test line event

3. gdb needs sudo

4. test with different ruby versions
