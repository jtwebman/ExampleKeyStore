# Example Elixir command line key value store REPL

This is just an example command line tool in elixir that creates a in-memory key value store REPL (Read eval print loop). It has only been tested on Mac OS with Elixir 1.9.3 (latest).

## Docker

I build a docker image that allows you to run this wihtout install if you want. If you have docker install just run this:

```bash
docker run -it --rm jtwebman/example_key_store
```

To build the docker image locally you can run this:

```bash
docker build -t jtwebman/example_key_store .
```

## Installation

You will need to first install elixir on your machine if you don't already have it install. On Mac OS you can run this command if you use brew.

```bash
brew install elixir
```

If you are not on Mac OS refer to here: https://elixir-lang.org/install.html

Once elixir is install, you have cloned the project locally, and are in the root folder for the project run the following command to make the command line tool

```bash
mix escript.build
```

This will create command in the root called `example_key_store`. To run this on Mac OS or Linux you can just run:

```bash
./example_key_store
```

If on windows I would guess you would run:

```bash
example_key_store.bat
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
