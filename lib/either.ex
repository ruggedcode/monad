defmodule Either do
  use Option

  @moduledoc """
  The Either monad represent the possibility of two control flow. Either left or right. When used in the content of
  handling errors, by convention left represent and error and right reprense success.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Option
      import Either
    end
  end

  @doc """
  Create a right value, represented by a tupe {:ok, value}
  """
  defmacro right(value), do: quote do: {:ok, unquote(value)}

  @doc """
  Create a left value, represented by a tupe {:error, reason}
  """
  defmacro left(reason), do: quote do: {:error, unquote(reason)}

  @doc """
  Test if it is a Right value
  """
  def right?({:ok, _}), do: true
  def right?({:error, _}), do: false

  @doc """
  Project an Either to a Right value. If the Either is a Left value Option.none will be returned
  """
  def right_projection({:ok, value}), do: some(value)
  def right_projection({:error, _reason}), do: none

  @doc """
  Transform a Right value to a Left one and vise-versa
  """
	def swap({:ok, value}), do: {:error, value}
  def swap({:error, reason}), do: {:ok, reason}

  @doc """
  Test if it is a Left value
  """
  def left?(either), do: !right?(either)

  @doc """
  Project an Either to a Left value. If the Either is a Right value Option.none will be returned
  """
  def left_projection({:error, reason}), do: some(reason)
  def left_projection({:ok, _value}), do: none
end