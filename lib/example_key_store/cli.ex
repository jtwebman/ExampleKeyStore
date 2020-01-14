defmodule ExampleKeyStore.Cli do
  @help """
  Valid Commands:

  SET <key> <value> // store the value for key
  GET <key>         // return the current value for key
  DELETE <key>      // remove the entry for key
  COUNT <value>     // return the number of keys that have the given value
  BEGIN             // start a new transaction
  COMMIT            // complete the current transaction
  ROLLBACK          // revert to state prior to BEGIN call

  Control-C         // exit program
  """

  @doc """
  The main function called when the commandline starts
  """
  def main(_) do
    {:ok, store} = ExampleKeyStore.KeyStore.start_link()
    repl(store)
  end

  @doc """
  The repl loop
  """
  def repl(store) do
    command = IO.gets("")

    case ExampleKeyStore.KeyStore.command(store, command) do
      {:ok, nil} ->
        nil

      {:ok, message} ->
        IO.puts("=> #{message}")

      {:error, reason} ->
        IO.puts(:stderr, "=> #{reason}")
        IO.puts(@help)
    end

    repl(store)
  end
end
