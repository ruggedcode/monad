defmodule MonadTest do
  use ExUnit.Case
  require Monad

  test "Create a Monadic value" do
    monadic_value = Monad.unit("something")
    refute "something" === monadic_value
    assert "something" === monadic_value |> Monad.get
    case monadic_value do
      Monad.unit(value) -> assert "something" === value
    end
  end

  # Monad laws from http://en.wikipedia.org/wiki/Monad_(functional_programming)

  # Haskell 'return' is the equivalent of Scala 'unit'
  # (return x) >>= f   ≡   f x
  test "Monad left identity" do
    x = 7
    f = fn (x) -> x * x end

    assert Monad.unit(x) |> Monad.bind(f) === f.(x)
  end

  # m >>= return   ≡   m
  test "Monad right identity" do
    m = Monad.unit(42)

    assert m |> Monad.bind(&Monad.unit/1) === m
  end

  test "Monad associativity" do
    f = fn (x) -> x * x end
    g = fn (x) -> x - 1 end
    m = Monad.unit(2)

    assert m |> Monad.bind(f) |> Monad.unit() |> Monad.bind(g) === Monad.bind(m, &Monad.bind(Monad.unit(f.(&1)), g))
  end

  test "iterate a Monad" do
    Monad.unit("something") |> Monad.each(fn value -> assert value === "something" end)
  end

  test "map a Monad" do
    assert Monad.unit("something else") === Monad.unit("something") |> Monad.map(fn(value) -> "#{value} else" end)
  end

  test "flat_map a Monad" do
    assert "something else" === Monad.unit("something") |> Monad.flat_map(fn(value) -> "#{value} else" end)
  end

  test "iterate a List of Monad" do
    result = [Monad.unit("hello"), Monad.unit("mister"), Monad.unit("johns")]
    |> Monad.each(fn word -> assert String.length(word) > 4 end)
    assert result === :ok
  end

  test "map a List of Monad" do
    list = [Monad.unit("hello"), Monad.unit("mister"), Monad.unit("johns")] |> Monad.map(&String.capitalize(&1))
    assert list === [Monad.unit("Hello"), Monad.unit("Mister"), Monad.unit("Johns")]
  end

  test "flat_map a List of Monad" do
    list = [Monad.unit("hello"), Monad.unit("mister"), Monad.unit("johns")] |> Monad.flat_map(&String.capitalize(&1))
    assert list |> Enum.join(" ") === "Hello Mister Johns"
  end
end
