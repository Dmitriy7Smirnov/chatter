defmodule Storage do
  use GenServer
  @ets_table :ets_storage

# Start the server
def start_link(_opts) do
  create_table()
  GenServer.start_link(__MODULE__, :ok, name: :myGenServer)
end


  # Callbacks

  @impl true
  def init(stack) do
    #create_table()
    send(self(), :init)
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

  @impl true
  def handle_info(:init, state) do
    IO.inspect "IT IS HANDLE INFO INIT"
    :observer.start()
    get_and_save()
    # Schedule work to be performed on start
    schedule_work()
    {:noreply, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Do the desired work here
    # ...

    #create_table()
    # Reschedule once more
    get_and_save()
    schedule_work()
    {:noreply, state}
  end

  # @impl true
  # def handle_info({:EXIT, _from_pid, reason}, state) do
  #   IO.inspect reason
  #   add_stars(reason.href, reason.stars)
  #   {:noreply, state}
  # end

  @impl true
  def handle_info({:DOWN, _ref, :process, _from_pid, reason}, state) do
    IO.inspect reason
    add_stars(reason.href, reason.stars)
    {:noreply, state}
  end

  # @impl true
  # def handle_info(msg, state) do
  #   IO.inspect msg
  #   {:noreply, state}
  # end

  def get_and_save do
    hrefs = Parser.get_content()
    keys = %{href: "keys", hrefs: hrefs}
    create_data(keys)

    #Process.flag(:trap_exit, true)
    for href <- hrefs  do
      :timer.sleep(500)
      if not get_data(href).show? do
          #spawn_link(Parser, :get_stars_test, [href])
          spawn_monitor(Parser, :get_stars_floki, [href])
      end
    end
  end

  def get_stars_floki(href) do
    url = to_charlist(href)
    #url = 'https://github.com/erlang/docker-erlang-otp'
    stars = case :httpc.request(:get, {url, []}, [], [{:body_format, :binary}]) do
      {:ok, {{_version, _status, _reasonPhrase}, _headers, body}} -> numAsText = Floki.find(body, "a.social-count.js-social-count") |> Floki.text
                                                                #IO.inspect numAsText
                                                                 get_number_from_text(numAsText)
                                                            _ -> :error1
    end
    #{href, stars}
    #:httpc.request(:get, {url, []}, [], [{:body_format, :binary}])
    #IO.inspect {href, stars}
    #exit(:myreason)
    exit(%{href: href, stars: stars})
    #{:ok, {{_version, 200, _reasonPhrase}, _headers, body}} = :httpc.request(:get, {url, []}, [], [{:body_format, :binary}])
  end

  defp get_number_from_text(text) do
    stars = case Regex.run(~r/(\d+)/, text) do
              [ _, stars] -> stars
              _ -> false
            end
    stars
  end

  defp schedule_work do
    # In 1 day
    Process.send_after(self(), :work, 24 * 60 * 60 * 1000)
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
    # IO.inspect "WTF"
    # IO.inspect key
    # IO.inspect "WTF1"
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
    [{key, map1}] = :ets.lookup(@ets_table, key)
    # IO.inspect "WTF"
    # IO.inspect map1
    # IO.inspect "WTF1"
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
