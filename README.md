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
iex(1)> use Option
nil
iex(2)> name = Option.none
:none
iex(3)> IO.puts "Hello #{name |> get_or_else("world")}"
Hello world
:ok
iex(4)> name = Option.some("Bob")
{:some, "Bob"}
iex(5)> IO.puts "Hello #{name |> get_or_else("world")}"
Hello Bob
:ok
```

## Either usage

```iex
iex(1)> use Either
nil
iex(2)> File.read("does_exits.json") \
...(2)> |> right_projection \
...(2)> |> get_or_else("{\"version\":\"0.0.1\"}")
"{\"version\":\"0.0.1\"}"
```

```iex
iex(1)> use Either
nil
iex(2)> configuration = File.read("does_exits.json")
{:error, :enoent}
iex(3)> case configuration do
...(3)> right(content) -> IO.puts "Configuration file content is '#{content}'"
...(3)> left(reason) -> IO.puts "The reason we fail is '#{inspect reason}'"
...(3)> end
the reason we failed is ':enoent'
:ok
```
