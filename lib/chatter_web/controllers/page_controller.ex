defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def myindex(conn, _params) do
    #Phoenix.View.render(ChatterWeb.PageView, "myindex.html.eex", %{})
    hrefs = Storage.get_data("keys")
    IO.inspect "WTFpc"
    IO.inspect hrefs
    IO.inspect "WTFpc1"
    contents = Storage.get_all_data(hrefs.hrefs)
    min_stars = conn.query_params["min_stars"]
    IO.puts("Some text")
    IO.inspect(min_stars)
    if min_stars != nil do
      IO.inspect String.to_integer(min_stars)
    end
    IO.puts("Some text")
    filtred_contents = if min_stars != nil do
      data = Utils.filter(contents, String.to_integer(min_stars))
      Utils.empty_titles_filter(data)
    else
      contents
    end
    #stars = 10
    #aist = [%{stars1: stars}]
    render(conn, "myindex.html",  contents: filtred_contents)
  end
end
