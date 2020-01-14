defmodule KeyStoreTest do
  use ExUnit.Case

  alias ExampleKeyStore.KeyStore

  test "Set and get value" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "123"}
  end

  test "Delete value" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "123"}
    assert KeyStore.command(store, "DELETE foo") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "key not set"}
  end

  test "Count the number of occurrences of a value" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "SET bar 456") == {:ok, nil}
    assert KeyStore.command(store, "SET baz 123") == {:ok, nil}
    assert KeyStore.command(store, "COUNT 123") == {:ok, 2}
    assert KeyStore.command(store, "COUNT 456") == {:ok, 1}
  end

  test "Commit a transaction" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "BEGIN") == {:ok, nil}
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "COMMIT") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "123"}
  end

  test "Rollback an uncommitted transaction" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "BEGIN") == {:ok, nil}
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "ROLLBACK") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "key not set"}
  end

  test "Rollback a transaction" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "SET bar abc") == {:ok, nil}
    assert KeyStore.command(store, "BEGIN") == {:ok, nil}
    assert KeyStore.command(store, "SET foo 456") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "456"}
    assert KeyStore.command(store, "SET bar def") == {:ok, nil}
    assert KeyStore.command(store, "GET bar") == {:ok, "def"}
    assert KeyStore.command(store, "ROLLBACK") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "123"}
    assert KeyStore.command(store, "GET bar") == {:ok, "abc"}
    assert KeyStore.command(store, "COMMIT") == {:ok, "no transaction"}
  end

  test "Nested transaction" do
    {:ok, store} = KeyStore.start_link()
    assert KeyStore.command(store, "SET foo 123") == {:ok, nil}
    assert KeyStore.command(store, "BEGIN") == {:ok, nil}
    assert KeyStore.command(store, "SET foo 456") == {:ok, nil}
    assert KeyStore.command(store, "BEGIN") == {:ok, nil}
    assert KeyStore.command(store, "SET foo 789") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "789"}
    assert KeyStore.command(store, "ROLLBACK") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "456"}
    assert KeyStore.command(store, "ROLLBACK") == {:ok, nil}
    assert KeyStore.command(store, "GET foo") == {:ok, "123"}
  end
end
