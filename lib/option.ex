defmodule Option do
   @moduledoc """
   The Option monad is used to represent an Optional value. An Option can either be Some (wrapped value) or None to
   represent the absence of a value.
   """

  @type option :: Tuple | :none

  @doc false
  defmacro __using__(_opts), do: quote do: import Option

  @doc """
  Represent the absence of a value.
  """
  @spec none :: option
  defmacro none, do: quote do: :none

  @doc """
  Represent a value, wrapped in an Option.
  """
  @spec some(any) :: option
  defmacro some(nil), do: quote do: :none
  defmacro some(value), do: quote do: {:some, unquote(value)}

  @doc """
  Execute the transformation function on the content of the Option
  """
  @spec bind(option, (any -> option)) :: option
  def bind(:none, _func), do: :none
  def bind({:some, value}, func), do: func.(value)

  @doc """
  Unwrap the content of an Option (e.g.: return the value)
  """
  @spec get(option) :: any
	def get({:some, value}), do: value

  @doc """
  Either return the unwrapped value of the option or if no value (e.g.: none) return the default value
  """
  @spec get_or_else(option, any) :: any
	def get_or_else(:none , default), do: default
  def get_or_else({:some, value}, _default), do: value

  @doc """
  Execute the transformation function on the Option
  """
  @spec map(option, (any -> any)) :: option
	def map(option, func) do
		case option do
			{:some, _value} -> option |> bind(func) |> some
			:none -> :none
		end
	end

  @doc """
  Execute the transformation function on the unwrapped value of the Option
  """
  @spec flat_map(option, (any -> option)) :: option
	def flat_map(option, func) do
		case option do
			{:some, _value} -> 
        case option |> bind(func) do
          {:some, value} -> {:some, value}
          :none -> :none
          otherwise -> raise(OptionException,
                             message: "Option.flat_map: Transformation function return type is an Option. " <>
                                      "'#{inspect otherwise}' is not an Option."
                            )
        end
			:none -> :none
		end
	end
end