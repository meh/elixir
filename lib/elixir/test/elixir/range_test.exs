Code.require_file "../test_helper.exs", __FILE__

defmodule RangeTest do
  use ExUnit.Case, async: true

  test :first do
    assert Range.new(first: 1, last: 3).first == 1
  end

  test :last do
    assert Range.new(first: 1, last: 3).last == 3
  end

  test :op do
    assert (1..3).first == 1
    assert (1..3).last  == 3
  end

  test :in do
    refute 0 in 1..3, "in range assertion"
    assert 1 in 1..3, "in range assertion"
    assert 2 in 1..3, "in range assertion"
    assert 3 in 1..3, "in range assertion"
    refute 4 in 1..3, "in range assertion"
    assert -3 in -1..-3, "in range assertion"

    refute 3 in 0..4<>2, "in range assertion"
    assert 2 in 0..4<>2, "in range assertion"
  end

  test :is_range do
    assert is_range(1..3)
    refute is_range(not_range)
  end

  test :enum do
    assert Enum.to_list(1..3) == [1,2,3]
    assert Enum.to_list(3..1) == [3,2,1]

    assert Enum.count(1..3) == 3
    assert Enum.count(3..1) == 3

    assert Enum.to_list(0..4<>2) == [0,2,4]
    assert Enum.to_list(4..0<>2) == [4,2,0]

    assert Enum.count(0..4<>2) == 3
    assert Enum.count(4..0<>2) == 3
    assert Enum.count(0..4<>4) == 2
    assert Enum.count(0..4<>5) == 1
  end

  test :inspect do
    assert inspect(1..3) == "1..3"
    assert inspect(3..1) == "3..1"

    assert inspect(1..3<>2) == "1..3<>2"
    assert inspect(3..1<>2) == "3..1<>2"
  end

  defp not_range do
    1
  end
end
