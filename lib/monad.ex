defmodule Monad do
  @type monad :: {:some, any}
  @type optional_monad :: monad | :none
  @some :some

  @moduledoc """
  A monad is a construction that, given an underlying type system, embeds a corresponding type system
  (called the monadic type system) into it (that is, each monadic type acts as the underlying type).
  This monadic type system preserves all significant aspects of the underlying type system, while adding
  features particular to the monad.

  See: http://en.wikipedia.org/wiki/Monad_(functional_programming)
  """

  @doc """
  The 'unit' operation takes a value from a plain type and puts it into a monadic container.
  """
  @spec unit(any) :: monad
  defmacro unit(value), do: quote do: {unquote(@some), unquote(value)}

  @doc """
  The 'bind' operation takes as its arguments a monadic container and a function from a plain type to a monadic
  container, and returns a new monadic container.
  """
  @spec bind(optional_monad, (any -> optional_monad)) :: optional_monad
  def bind(monad, func)
  def bind(monad, _func) when is_atom(monad), do: monad
  def bind({@some, value}, func), do: func.(value)

  @doc """
  Return the unwrapped value contained in the monad.
  """
  @spec get(monad) :: any
  def get(monad)
  def get({@some, value}), do: value
  def get(monad) when is_atom(monad) do
    raise(OptionException, message: "Monad.get on #{inspect monad} is not permitted.")
  end

  @doc """
  Apply the function 'func' to the content of the monad.
  """
  @spec each(optional_monad, (any -> no_return)) :: :ok
  def each(monad, func)
  def each(monad, _func) when is_atom(monad), do: monad
  def each(monad, func) do
    _ = map(monad, func)
    :ok
  end
  
  @doc """
  map works applying a function that returns a sequence for each element in the list, and returning 
  the results into a new list
  """
  @spec map(optional_monad, (any -> any)) :: optional_monad
  def map(monad, func)
  def map(monad, _func) when is_atom(monad), do: monad
  def map([], _func), do: []

  def map([monad], _func) when is_atom(monad), do: [monad]
  def map([monad = {@some, _value}], func) do
    [{elem(monad, 0), List.first(Enum.map(monad, func))}]
  end

  def map([monad | tail], func) when is_atom(monad), do: [monad | map(tail, func)]
  def map([monad = {@some, _value} | tail], func) do
    [{elem(monad, 0), List.first(Enum.map(monad, func))} | map(tail, func)]
  end

  def map(monad = {@some, _value}, func) do
    {elem(monad, 0), List.first(Enum.map(monad, func))}
  end

  @doc """
  flatMap works applying a function that returns a sequence for each element in the list, and flattening 
  the results into a new list
  """
  @spec flat_map(optional_monad, (any -> any)) :: any
  def flat_map(monad, func)
  def flat_map(monad, _func) when is_atom(monad), do: monad
  def flat_map([], _func), do: []

  def flat_map([monad], _func) when is_atom(monad), do: []
  def flat_map([monad], func) do
    [Enum.map(monad, func) |> List.first]
  end

  def flat_map([monad | tail], func) when is_atom(monad), do: flat_map(tail, func)
  def flat_map([monad | tail], func) do
    [Enum.map(monad, func) |> List.first | flat_map(tail, func)]
  end

  def flat_map(monad = {@some, _value}, func) do
    Enum.map(monad, func) |> List.first
  end
end

defimpl Enumerable, for: Tuple do
  def member?({_atom, monad_value}, value), do: {:ok, monad_value == value}
  def count({_atom, _value}), do: {:ok, 1}

  def reduce({_atom, value}, acc, fun) do
    do_reduce(value, acc, fun, fn
      {:suspend, acc} -> {:suspended, acc, &{:done, elem(&1, 1)}}
      {:halt, acc}    -> {:halted, acc}
      {:cont, acc}    -> {:done, acc}
    end)
  end

  defp do_reduce(_value, {:halt, acc}, _fun, _next), do: {:halted, acc}
  defp do_reduce(value, {:suspend, acc}, fun, next), do: {:suspended, acc, &do_reduce(value, &1, fun, next)}
  defp do_reduce(value, {:cont, acc}, fun, next), do: next.(fun.(value, acc))
end

defimpl Enumerable, for: Atom do
  def member?(atom, value), do: {:ok, atom == value}
  def count(_atom), do: {:ok, 0}

  def reduce(atom, acc, fun) do
    do_reduce(atom, acc, fun, fn
      {:suspend, acc} -> {:suspended, acc, &{:done, elem(&1, 1)}}
      {:halt, acc}    -> {:halted, acc}
      {:cont, acc}    -> {:done, acc}
    end)
  end

  defp do_reduce(_atom, {:halt, acc}, _fun, _next), do: {:halted, acc}
  defp do_reduce(atom, {:suspend, acc}, fun, next), do: {:suspended, acc, &do_reduce(atom, &1, fun, next)}
  defp do_reduce(atom, {:cont, acc}, fun, next), do: next.(fun.(atom, acc))
end
