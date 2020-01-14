FROM elixir:1.9.4-slim

WORKDIR /app

COPY lib/ lib/
COPY mix.exs mix.exs

RUN MIX_ENV=prod mix escript.build

CMD ./example_key_store