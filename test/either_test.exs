defmodule EitherTest do
  use ExUnit.Case, async: true
  require Monad
  require Either
  require Option

  test "A tuple {:ok, _} is equivalent to an Either.right" do
    assert {:ok, "I am right"} |> Either.right? == true
  end

  test "Either.right? on a Right value is true" do
    result = Either.right("always right")
    assert Either.right?(result) == true
    assert Either.left?(result) == false
  end

  test "Either.right_projection on a Right value return Option.some" do
    result = Either.right("always right")
    assert Either.right_projection(result) == Option.some("always right")
  end

  test "Either.right_projection.get on a Right value return the unwrapped value" do
    result = Either.right("always right")
    assert (result |> Either.right_projection |> Monad.get) == "always right"
  end

  test "Either.right_projection on a Left value return an Option.none" do
    result = Either.left("a lefty")
    assert result |> Either.right_projection == Option.none
  end

  test "Either.right_projection.get on a Left value raise an exception" do
    result = Either.left("a lefty")
    catch_error(result |> Either.right_projection |> Monad.get)
  end

  test "Either.right_projection.map on a Right value, call the transformation function on the unwrapped value" do
    result = Either.right("always right")
    assert result |> Either.right_projection |> Monad.map(fn (value) ->
      case value do
        "always right" -> true
        _ -> false
      end
    end) == Option.some(true)
  end

  test "Either.right_projection.map on a Left value does not execute the function and return an Option.none" do
    result = Either.left("a lefty")
    assert result |> Either.right_projection |> Monad.map(fn (_value) -> raise "should not be called" end) == Option.none
  end

  test "Either.right case successful match on the Right" do
    result = Either.right("always right")
    case result do
      Either.right(string) -> assert string == "always right"
      Either.left(string) -> raise "should never match #{inspect string}"
      other -> raise "should never match #{inspect other}"
    end
  end

  ######################################################################################################################

  test "A tuple {:error, _} is equivalent to an Either.left" do
    assert {:error, "I was wrong"} |> Either.left? == true
  end

  test "Either.left? on a Left value is true" do
    result = Either.left("a lefty")
    assert Either.left?(result) == true
    assert Either.right?(result) == false
  end

  test "Either.left_projection on a Left value return Option.some" do
    result = Either.left("a lefty")
    assert result |> Either.left_projection == Option.some("a lefty")
  end

  test "Either.left_projection.get on a Left value return the unwrapped value" do
    result = Either.left("a lefty")
    assert (result |> Either.left_projection |> Monad.get) == "a lefty"
  end

  test "Either.left_projection on a Right value return an Option.none" do
    result = Either.right("always right")
    assert result |> Either.left_projection == Option.none
  end

  test "Either.left_projection.get on a Right value raise an exception" do
    result = Either.right("always right")
    catch_error(result |> Either.left_projection |> Monad.get)
  end

  test "Either.left_projection.map on a Left value, call the transformation function on the unwrapped value" do
    result = Either.left("a lefty")
    assert result |> Either.left_projection |> Monad.map(fn (value) ->
      case value do
        "a lefty" -> true
        _ -> false
      end
    end) == Option.some(true)
  end

  test "Either.left_projection.map on a Right value does not execute the function and return an Option.none" do
    result = Either.right("always right")
    assert result |> Either.left_projection |> Monad.map(fn (_value) -> raise "should not be called" end) == Option.none
  end

  test "Either.left case successful match on the Left" do
    result = Either.left("a lefty")
    case result do
      Either.left(string) -> assert string == "a lefty"
      Either.right(string) -> raise "should never match #{inspect string}"
      other -> raise "should never match #{inspect other}"
    end
  end

  ######################################################################################################################

  test "Either.swap swaping twice is equivalent to the original value" do
    undecided = Either.right("undecided")
    assert undecided == undecided |> Either.swap |> Either.swap
  end

  test "Either.swap a right value becomes left" do
    right = Either.right("not always right")
    assert right |> Either.swap |> Either.left? == true
    assert right |> Either.swap |> Either.left_projection |> Monad.get == right |> Either.right_projection |> Monad.get
  end

  test "Either.swap a left value becomes right" do
    wrong = Either.left("not always wrong")
    assert wrong |> Either.swap |> Either.right? == true
    assert wrong |> Either.swap |> Either.right_projection |> Monad.get == wrong |> Either.left_projection |> Monad.get
  end
end
