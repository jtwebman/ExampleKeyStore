defmodule ExampleKeyStore.KeyStore do
  @moduledoc """
  The key value store process to ahndle commands and responses
  """
  use GenServer

  @doc """
  Start the key value store
  """
  def start_link(), do: GenServer.start_link(__MODULE__, [])

  @doc """
  Runs the command, reporting back the response or error.
  """
  def command(pid, command) do
    GenServer.call(pid, {:command, command |> String.trim() |> String.split(~r/\s+/)})
  end

  @impl true
  def init(_) do
    {:ok, {%{}, []}}
  end

  # Handle GET command
  @impl true
  def handle_call({:command, ["GET", key]}, _from, {store, transactions}) do
    {:reply, {:ok, Map.get(store, key, "key not set")}, {store, transactions}}
  end

  # Handle GET command
  @impl true
  def handle_call({:command, ["SET", key, value]}, _from, {store, transactions}) do
    {:reply, {:ok, nil}, {Map.put(store, key, value), transactions}}
  end

  # Handle DELETE command
  @impl true
  def handle_call({:command, ["DELETE", key]}, _from, {store, transactions}) do
    {:reply, {:ok, nil}, {Map.delete(store, key), transactions}}
  end

  # Handle COUNT command
  @impl true
  def handle_call({:command, ["COUNT", lookup]}, _from, {store, transactions}) do
    count =
      Enum.reduce(store, 0, fn {_key, value}, acc ->
        case value == lookup do
          true -> acc + 1
          _ -> acc
        end
      end)

    {:reply, {:ok, count}, {store, transactions}}
  end

  # Handle BEGIN command
  @impl true
  def handle_call({:command, ["BEGIN"]}, _from, {store, transactions}) do
    {:reply, {:ok, nil}, {store, [store] ++ transactions}}
  end

  # Handle COMMIT command when no transactions
  @impl true
  def handle_call({:command, ["COMMIT"]}, _from, {store, []}) do
    {:reply, {:ok, "no transaction"}, {store, []}}
  end

  # Handle COMMIT command
  @impl true
  def handle_call({:command, ["COMMIT"]}, _from, {store, [_commiting | remaining]}) do
    {:reply, {:ok, nil}, {store, remaining}}
  end

  # Handle ROLLBACK command when no transactions
  @impl true
  def handle_call({:command, ["ROLLBACK"]}, _from, {store, []}) do
    {:reply, {:ok, "no transaction"}, {store, []}}
  end

  # Handle ROLLBACK command
  @impl true
  def handle_call({:command, ["ROLLBACK"]}, _from, {_store, [rollback | remaining]}) do
    {:reply, {:ok, nil}, {rollback, remaining}}
  end

  # Handle catch all command
  @impl true
  def handle_call({:command, command}, _from, {store, transactions}) do
    full_command = Enum.join(command, " ")
    {:reply, {:error, "unknown command: #{full_command}"}, {store, transactions}}
  end
end
