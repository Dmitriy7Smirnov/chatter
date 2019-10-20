defmodule ChatterWeb.PageView do
  use ChatterWeb, :view

  def test(_conn) do
    "Awesome New Title!"
  end

  def title(_conn) do
    "Hello World!"
  end
end
