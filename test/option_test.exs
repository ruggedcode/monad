defmodule OptionTest do
  use ExUnit.Case, async: true
  use Option

  test "Option.some wrap the value" do
    option = some("thing")
    refute option == "thing"
    refute option == none
    assert option == some("thing")
    case option do
      some(thing) -> assert thing == "thing"
    end
  end

  test "Option.get unwrap the value" do
    option = some("thing")
    assert option |> get == "thing"
  end

  test "Option.none behave has the absence of a value" do
    option = none
    refute option == some("thing")
    assert option == none
    case option do
      some(thing) -> raise "Must never match, but got '#{thing}'"
      none -> assert option == none
    end
  end

  test "Option.some of nil behave has none (or the absence of a value)" do
    assert some(nil) == none
  end

  test "Option.get_or_else of a value return the unwrapped value" do
    option = some("thing")
    assert get_or_else(option, "not this") == "thing"
    refute get_or_else(option, "not this") == "not this"
  end

  test "Option.get_or_else of none will return the default value" do
    assert get_or_else(none, "default") == "default"
    catch_error(none |> get)
  end

  test "Option.map on a value call the transformation function and wrap the result in an Option" do
    assert "something" == map(some("thing"), fn(value)-> "some#{value}" end) |> get
  end

  test "Option.map on none return none without calling the transformation function" do
    assert map(none, fn(_)-> raise "Must never be executed" end) == none
  end

  test "Option.flat_map on a value some call the transformation funtion an return the result as is (no wrapping)" do
    assert some("something") |> flat_map(fn(value) -> some("#{value} else") end) == some("something else")
  end

  test "Option.flat_map on none return none without calling the transformation function" do
    assert none |> flat_map(fn(_value) -> raise "should not execute" end) == none
  end

  test "Option.flat_map fails when the transformation function does not return the result wrapped in an Option" do
    # catch_error some("something") |> flat_map(fn(value) -> "#{value} else" end)
    assert_raise(
      OptionException,
      "Option.flat_map: Transformation function return type is an Option. '\"something else\"' is not an Option.",
      fn -> some("something") |> flat_map(fn(value) -> "#{value} else" end) end
    )
  end
end
