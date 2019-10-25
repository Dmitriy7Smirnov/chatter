defmodule Utils do

  def filter(hrefs, min_stars) do
    filter(hrefs, min_stars, [])
  end

  defp filter([head | tail], min_stars, acc) do
    if head.show? do
      filter(tail, min_stars, [head | acc])
    else
      if String.to_integer(head.stars) >= min_stars do
        filter(tail, min_stars, [head | acc])
      else
        filter(tail, min_stars, acc)
      end
    end
  end

  defp filter([], _min_stars, acc) do
    Enum.reverse(acc)
  end


  def empty_titles_filter(hrefs) do
    etf(hrefs, [])
  end

  defp etf([head1, head2, tail,], acc) do
    if head1.show? == true and head2.show? == true do
      etf([head2, tail], acc)
    else
      etf([head2, tail], [head1, acc])
    end
  end

  defp etf([head1, []], acc) do
    if head1.show? do
      etf([], acc)
    else
      etf([], [head1, acc])
    end
  end

  defp etf([], acc) do
    Enum.reverse(acc)
  end

end
