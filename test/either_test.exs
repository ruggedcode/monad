defmodule EitherTest do
  use ExUnit.Case, async: true
  use Either
  use Option

  test "A tuple {:ok, _} is equivalent to an Either.right" do
    assert {:ok, "I am right"} |> right? == true
  end

  test "Either.right? on a Right value is true" do
    result = right("always right")
    assert right?(result) == true
    assert left?(result) == false
  end

  test "Either.right_projection on a Right value return Option.some" do
    result = right("always right")
    assert right_projection(result) == Option.some("always right")
  end

  test "Either.right_projection.get on a Right value return the unwrapped value" do
    result = right("always right")
    assert (result |> right_projection |> get) == "always right"
  end

  test "Either.right_projection on a Left value return an Option.none" do
    result = left("a lefty")
    assert result |> right_projection == Option.none
  end

  test "Either.right_projection.get on a Left value raise an exception" do
    result = left("a lefty")
    catch_error(result |> right_projection |> get)
  end

  test "Either.right_projection.map on a Right value, call the transformation function on the unwrapped value" do
    result = right("always right")
    assert result |> right_projection |> map(fn (value) ->
      case value do
        "always right" -> true
        _ -> false
      end
    end) == Option.some(true)
  end

  test "Either.right_projection.map on a Left value does not execute the function and return an Option.none" do
    result = left("a lefty")
    assert result |> right_projection |> map(fn (_value) -> raise "should not be called" end) == Option.none
  end

  test "Either.right case successful match on the Right" do
    result = right("always right")
    case result do
      right(string) -> assert string == "always right"
      left(string) -> raise "should never match #{inspect string}"
      other -> raise "should never match #{inspect other}"
    end
  end


  ######################################################################################################################

  test "A tuple {:error, _} is equivalent to an Either.left" do
    assert {:error, "I was wrong"} |> left? == true
  end

  test "Either.left? on a Left value is true" do
    result = left("a lefty")
    assert left?(result) == true
    assert right?(result) == false
  end

  test "Either.left_projection on a Left value return Option.some" do
    result = left("a lefty")
    assert result |> left_projection == Option.some("a lefty")
  end

  test "Either.left_projection.get on a Left value return the unwrapped value" do
    result = left("a lefty")
    assert (result |> left_projection |> get) == "a lefty"
  end

  test "Either.left_projection on a Right value return an Option.none" do
    result = right("always right")
    assert result |> left_projection == Option.none
  end

  test "Either.left_projection.get on a Right value raise an exception" do
    result = right("always right")
    catch_error(result |> left_projection |> get)
  end

  test "Either.left_projection.map on a Left value, call the transformation function on the unwrapped value" do
    result = left("a lefty")
    assert result |> left_projection |> map(fn (value) ->
      case value do
        "a lefty" -> true
        _ -> false
      end
    end) == Option.some(true)
  end

  test "Either.left_projection.map on a Right value does not execute the function and return an Option.none" do
    result = right("always right")
    assert result |> left_projection |> map(fn (_value) -> raise "should not be called" end) == Option.none
  end

  test "Either.left case successful match on the Left" do
    result = left("a lefty")
    case result do
      left(string) -> assert string == "a lefty"
      right(string) -> raise "should never match #{inspect string}"
      other -> raise "should never match #{inspect other}"
    end
  end
end
