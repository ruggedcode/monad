defmodule Either do
  require Option

  @type left :: {:error, any}
  @type right :: {:ok, any}
  @type either :: left | right
  @type option :: {:some, any} | :none

  @right :ok
  @left  :error


  @moduledoc """
  The Either monad represent the possibility of two control flow. Either left or right. When used in the content of
  handling errors, by convention left represent and error and right reprense success.
  """

  @doc """
  Create a right value, represented by a tupe {:ok, value}
  By convention the successful control flow is "Right".
  """
  @spec right(any) :: right
  defmacro right(value), do: quote do: {unquote(@right), unquote(value)}

  @doc """
  Create a left value, represented by a tupe {:error, reason}
  By convention the unsuccessful control flow is "Left" (e.g. "not right").
  """
  @spec left(any) :: left
  defmacro left(reason), do: quote do: {unquote(@left), unquote(reason)}

  @doc """
  Test if it is a Right value
  """
  @spec right?(either) :: boolean
  def right?({@right, _value}), do: true
  def right?({@left, _value}), do: false

  @doc """
  Project an Either to a Right value. If the Either is a Left value Option.none will be returned
  """
  @spec right_projection(either) :: option
  def right_projection({@right, value}), do: Option.some(value)
  def right_projection({@left, _reason}), do: Option.none

  @doc """
  Transform a Right value to a Left one and vise-versa
  """
  @spec swap(either) :: either
	def swap({@right, value}), do: {@left, value}
  def swap({@left, reason}), do: {@right, reason}

  @doc """
  Test if it is a Left value
  """
  @spec left?(either) :: boolean
  def left?(either), do: !right?(either)

  @doc """
  Project an Either to a Left value. If the Either is a Right value Option.none will be returned
  """
  @spec left_projection(either) :: option
  def left_projection({@left, reason}), do: Option.some(reason)
  def left_projection({@right, _value}), do: Option.none
end