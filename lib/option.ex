defmodule Option do
  @moduledoc """
  The Option monad is used to represent an Optional value. An Option can either be Some (wrapped value) or None to
  represent the absence of a value.
  """
  @type option :: {:some, any} | :none

  @some :some
  @none :none

  @doc """
  Represent the absence of a value (e.g. often represented by nil).
  """
  @spec none :: :none
  defmacro none, do: quote do: unquote(@none)

  @doc """
  Represent a value, wrapped in an Option.
  """
  @spec some(any) :: option
  defmacro some(nil), do: quote do: unquote(@none)
  defmacro some(value), do: quote do: {unquote(@some), unquote(value)}

  @doc """
  Returns the unwrapped value of the option or if no value (e.g.: none) return the default value
  """
  @spec get_or_else(option, any) :: any
	def get_or_else(@none , default), do: default
  def get_or_else({@some, value}, _default), do: value
end