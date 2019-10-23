defmodule Storage do
  use GenServer
  @ets_table :ets_storage

# Start the server
def start_link(opts) do
  create_table()
  GenServer.start_link(__MODULE__, :ok, opts)
end


  # Callbacks

  @impl true
  def init(stack) do
    #create_table()
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  def create_table do
    :ets.new(@ets_table, [:set, :public, :named_table])
    #:ets.new(:cool_table, [:bag, :public, :named_table])
  end

  def create_data(new_data) do
    #:ets.insert(@ets_table, {new_data.href, new_data})
    #new_data = %{topic: "topic", show?: false, name: "name", href: "href", stars: 777, description: "description"}
    #:ets.new(@ets_table, [:set, :named_table])
    :ets.insert_new(@ets_table, {new_data.href, new_data})
    #{"Actors", %{href: "Actors", show?: true, topic: "Actors"}}
  end

  def get_data(key) do
    IO.inspect "WTF"
    IO.inspect key
    IO.inspect "WTF1"
    case :ets.lookup(@ets_table, key) do
      [tuple] -> {_head, tail} = tuple
                  tail
            _ -> %{topic: "topic", show?: false, name: "name", href: "href", stars: 777, description: "description"}
    end

  end

  def get_all_data(hrefs) do
    for href <- hrefs do
      get_data(href)
    end
  end

  def add_stars(key, stars) do
    map1 = :ets.lookup(@ets_table, key)
    if is_map(map1) do
      map2 = Map.put(map1, :stars, stars)
      :ets.insert(@ets_table, {key, map2})
    end
  end


  def add_time(key, time) do
    map1 = :ets.lookup(@ets_table, key)
    if is_map(map1) do
      map2 = Map.put(map1, :time, time)
      :ets.insert(@ets_table, {key, map2})
    end
  end

end
