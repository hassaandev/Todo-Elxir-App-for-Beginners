defmodule Todo.Cleanup do
  use GenServer

  import Ecto.Query, warn: false
  alias Todo.Repo
  alias Todo.List
  require Logger

  @schedule_time_value 5 * 60 * 1000 # 5 Minutes

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    Logger.info("#{__MODULE__} worker started")
    cleanup()
    # Schedule work to be performed on start
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Do the desired cleanup here
    cleanup()
    # Reschedule once more
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    # We schedule the cleanup to happen in 5 minutes (written in milliseconds).
    Process.send_after(self(), :work, @schedule_time_value)
  end

  defp cleanup() do
    Logger.debug "Cleanup executing at '#{NaiveDateTime.utc_now()}'..."
    last_24_hours = NaiveDateTime.add(NaiveDateTime.utc_now(), -1 * 86_400) # Last 24 hours

    from(l in List, where: l.updated_at <= ^last_24_hours and l.archived==^false)
      |> Repo.update_all(set: [archived: true])
      |> case do
        {0, _} -> Logger.debug "Cleaup executed. No new unarchived records found that are not updated in last 24 hours."
        {updated_count, _} -> Logger.debug "Cleaup completed. '#{inspect updated_count}' records archived successully."
      end
  end
end
