class Test
  def test
    a = 1
    b = 2
  end
end

printf "%8s | %s | %15s | %8s\n", "event", "file:line", "id", "classname"
set_trace_func proc { |event, file, line, id, binding, classname|
  printf "%8s | %s:%-2d | %15s | %8s\n", event, file, line, id, classname
}
t = Test.new
t.test
