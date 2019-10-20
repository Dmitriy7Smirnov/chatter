defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def myindex(conn, _params) do
    #Phoenix.View.render(ChatterWeb.PageView, "myindex.html.eex", %{})
    contents = Parser.get_content()
    stars = conn.query_params["min_stars"]
    IO.puts("Some text")
    IO.inspect(stars)
    IO.puts("Some text")
    #stars = 10
    #aist = [%{stars1: stars}]
    render(conn, "myindex.html",  contents: contents)
  end
end
