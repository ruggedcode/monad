defmodule OptionException do
  @moduledoc """
  Exception raised by the Option monad
  """

  @doc """
  Generic exception for Option.
  """
  defexception message: "Invalid Option"
end