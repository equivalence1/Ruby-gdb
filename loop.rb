def delay
    x = 1
    while x < 100000000
        x += 1
    end
end

class A
    
    @x = 123
    class << self
        attr_accessor :x
    end

    def initialize
        @a = 1
    end

    def foo(z)
        x = 0
        while A.x == 123
            fff = 123
            puts "#{x}: Hello!. some_strange_variable: #{$some_strange_variable}"
            x += 1
            if x == 10
                raise "Some Exception"
            end
            delay
        end
    end

end

puts Process.pid

ENV['TTT'] = 'ZZZ'

var = 777
a = A.new
a.foo(100) { puts 123 }
