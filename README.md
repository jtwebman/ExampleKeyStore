# Exmaple Elixir Commandline Key Store

This is just an example commandline tool in elixir that creates a in-memory key value store. It has only been tested on Mac OS.

## Installation

You will need to first have to have elixir install on your machine. On Mac OS you can run this command if you use brew.

```bash
brew install elixir
```

Once elixir is install and you have cloned the project locally and are in the root folder for the project run the following command to make the commandline tool

```bash
mix escript.build
```

This will create command in the root called `example_key_store`. To run this on Mac OS you can just run:

```bash
./example_key_store
```

## Tests

In the root of the project you can run the following command to run all the tests

```bash
mix test
```

## Commands

```
SET <key> <value> // store the value for key
GET <key>         // return the current value for key
DELETE <key>      // remove the entry for key
COUNT <value>     // return the number of keys that have the given value
BEGIN             // start a new transaction
COMMIT            // complete the current transaction
ROLLBACK          // revert to state prior to BEGIN call

Control-C         // exit program
```
