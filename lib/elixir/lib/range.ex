defrecord Range, [:first, :last, :step] do
  @moduledoc """
  Defines a Range.
  """
end

defprotocol Range.Iterator do
  @doc """
  How to iterate the range, receives the first
  and range as arguments. It needs to return a
  function that receives an item and returns
  a tuple with two elements: the given item
  and the next item in the iteration.
  """
  def iterator(first, range)

  @doc """
  Count how many items are in the range.
  """
  def count(first, range)
end

defimpl Enum.Iterator, for: Range do
  def iterator(Range[first: first] = range) do
    iterator = Range.Iterator.iterator(first, range)
    { iterator, iterator.(first) }
  end

  def count(Range[first: first] = range) do
    Range.Iterator.count(first, range)
  end
end

defimpl Range.Iterator, for: Number do
  def iterator(first, Range[last: last, step: nil]) when is_number(first) and is_number(last) and last >= first do
    fn(current) ->
      if current > last, do: :stop, else: { current, current + 1 }
    end
  end

  def iterator(first, Range[last: last, step: step]) when is_number(first) and is_number(last) and last >= first do
    fn(current) ->
      if current > last, do: :stop, else: { current, current + step }
    end
  end

  def iterator(first, Range[last: last, step: nil]) when is_number(first) and is_number(last) do
    fn(current) ->
      if current < last, do: :stop, else: { current, current - 1 }
    end
  end

  def iterator(first, Range[last: last, step: step]) when is_number(first) and is_number(last) do
    fn(current) ->
      if current < last, do: :stop, else: { current, current - step }
    end
  end

  def count(first, Range[last: last, step: nil]) when is_number(first) and is_number(last) and last >= first do
    last - first + 1
  end

  def count(first, Range[last: last, step: step]) when is_number(first) and is_number(last) and last >= first do
    :erlang.round((last - first) / step) + if(step > last, do: 0, else: 1)
  end

  def count(first, Range[last: last, step: nil]) when is_number(first) and is_number(last) do
    first - last + 1
  end

  def count(first, Range[last: last, step: step]) when is_number(first) and is_number(last) do
    :erlang.round((first - last) / step) + if(step > first, do: 0, else: 1)
  end
end

defimpl Binary.Inspect, for: Range do
  import Kernel, except: [inspect: 2]

  def inspect(Range[first: first, last: last, step: nil], opts) do
    Binary.Inspect.inspect(first, opts) <> ".." <> Binary.Inspect.inspect(last, opts)
  end

  def inspect(Range[first: first, last: last, step: step], opts) do
    Binary.Inspect.inspect(first, opts) <> ".." <> Binary.Inspect.inspect(last, opts) <> "<>" <> Binary.Inspect.inspect(step, opts)
  end
end
