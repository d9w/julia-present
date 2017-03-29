## Types
type Foo
    bar
    baz::Int
    qux::Float64
end

foo = Foo("Hello, world.", 23, 1.5)

# Foo((), 23.5, 1)
# ERROR: InexactError()

foo.qux = 2

foo.bar = 1//2

## Functions

function add(x, y)
  println("x is $x and y is $y")
  x + y
end

f_add(x, y) = x + y

f_tuple(x, y) = x + y, x - y

p1(a...) = +(1,a...)

function printargs(args...)
  @printf("%s\n", typeof(args))
  for (i, arg) in enumerate(args)
    @printf("Arg %d = %s\n", i, arg)
  end
end
# printargs(1, 2, 3)

function threeargs(a, b, c)
  @printf("a = %s::%s\n", a, typeof(a))
  @printf("b = %s::%s\n", b, typeof(b))
  @printf("c = %s::%s\n", c, typeof(c))
end

# vec = [1, 2, 3]
# threeargs(vec...)

# Multiple Dispatch

f(x::Float64, y::Float64) = 2x + y;
# f(2.0, 3.0) vs f(2.0, 3)

f(x::Number, y::Number) = 2x - y;
# f(2.0, 3)

# methods(f)
# methods(+)

abstract AllFoo

type Foo <: AllFoo
  bar
  baz::Int
  qux::Float64
end

type BadFoo <: AllFoo
  bar
end

print_foo(foo::AllFoo) = println(foo.bar)
print_foo(foo::Foo) = println(foo.bar, foo.baz, foo.qux)

## Functions as a type

# help?> map

m1 = "map((x) -> x * 2, [1, 2, 3])"
println(m1)
eval(parse(m1))

m2 = "map(+, [1, 2, 3], [10, 20, 30])"
println(m2)
eval(parse(m2))

double = x -> 2x

zs = map(double, [1:5])

## Expressions

prog = "1 + 1"
println(prog)

ex1 = parse(prog)
println(ex1)
println(typeof(ex1))

ex2 = Expr(:call, :+, 1, 1)

println(ex1 == ex2)

dump(ex2)

@code_llvm +(1,1)

## Macros

macro sayhello()
  return :( println("Hello, world!") )
end

# @sayhello()

macro twostep(arg)
    println("I execute at parse time. The argument is: ", arg)
    return :(println("I execute at runtime. The argument is: ", $arg))
end

ex = macroexpand( :(@twostep :(1, 2, 3)) );

# typeof(ex)
# ex
# eval(ex)

# @twostep 1,2,3

## Shell usage

run(pipeline(`git log`,`grep Date`))

a = split(chomp(readstring(pipeline(`git log`, `grep Date`))), "\n")

println(a)

@time run(`sleep 1` & `sleep 1`)

## Parallelization

@everywhere println(myid())

nheads = @parallel (+) for i=1:200000000
  Int(rand(Bool))
end

a = zeros(Int64, 10)
@parallel for i=1:10
  a[i] = myid()
end

a = SharedArray(Int64, 10)
@parallel for i=1:10
  a[i] = myid()
end
