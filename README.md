Elixir Monads
=============

## Goals

A simple and naive implementation of the Scala Option and Either monad in Elixir. This implementation tries to adhere to the idiosyncrasy of Elixir while providing the syntaxic sugar of monads.

## Warning

This module is an experimentation and is still in developmnet. The API is not final and the behavior/implemantation has not stabilized yet.

## TODO

* Add support for Collection of Either

## Option usage

```iex
$ iex -S mix
iex(1)> require Option
nil
iex(2)> name = Option.none
:none
iex(3)> IO.puts "Hello #{name |> Option.get_or_else("world")}"
Hello world
:ok
iex(4)> name = Option.some("Bob")
{:some, "Bob"}
iex(5)> IO.puts "Hello #{name |> Option.get_or_else("world")}"
Hello Bob
:ok
```

## Either usage

```iex
$ iex -S mix
iex(1)> require Either
nil
iex(2)> File.read("does_not_exits.json") \
...(2)> |> Either.right_projection \
...(2)> |> Option.get_or_else("{\"version\":\"0.0.1\"}")
"{\"version\":\"0.0.1\"}"
```

```iex
$ iex -S mix
iex(1)> require Either
nil
iex(2)> configuration = File.read("does_not_exits.json")
{:error, :enoent}
iex(3)> case configuration do
...(3)> Either.right(content) -> IO.puts "Configuration file content is '#{content}'"
...(3)> Either.left(reason) -> IO.puts "The reason we fail is '#{inspect reason}'"
...(3)> end
the reason we failed is ':enoent'
:ok
```


```iex
$ iex -S mix
iex(1)> defmodule Test do
...(1)>   def function_that_succeeded do
...(1)>     Either.right("success")
...(1)>   end
...(1)> end
{:module, Test,
 <<70, 79, 82, 49, 0, 0, 4, 204, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 112, 131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115, 95, 118, 49, 108, 0, 0, 0, 2, 104, 2, ...>>,
 {:function_that_succeeded, 0}}
iex(2)> uncertain_result = Test.function_that_succeeded
{:ok, "success"}
iex(3)> Either.right?(uncertain_result)
true
iex(4)> Either.left?(uncertain_result)
false
iex(5)> uncertain_result \
iex(5)> |> Either.right_projection \
iex(5)> |> Monad.each(&IO.puts("The result is #{&1}"))
success
:ok
iex(6)> uncertain_result \
iex(6)> |> Either.left_projection \
iex(6)> |> Monad.each(&IO.puts("NOT called, because #{&1} is not left"))
:none
```

## Dialyzer

To run dialyzer, install [Dialyxir](https://github.com/jeremyjh/dialyxir Dialyxir) 

```bash
mix compile &&  mix dialyzer
```
