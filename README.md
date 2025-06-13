# Wetterhaecker

## Setup

```bash
mix setup
```

## Start the application

```bash
iex -S mix phx.server
```

👉🏻 http://localhost:4000/

## Start Livebook

```bash
mix escript.install hex livebook
asdf reshim elixir
livebook server livebooks/wetterhaecker.livemd
```

## Start Brightsky API Mock

You can configure `lib/wetterhaecker/brightsky/client.ex`:

- to use the real brightsky API
- to use a mocked endpoint

In case of mock, you need to [install prism mock](https://docs.stoplight.io/docs/prism/f51bcc80a02db-installation) and start the mock server:

```bash
prism mock priv/static/brightsky_openapi.json
```

then, start the application with the appropriate environment variable:

```bash
BRIGHTSKY_BASE_URL=http://127.0.0.1:4010 iex -S mix phx.server
```

## Type Generation for Brightsky Types

If you need to generate types for Brightsky, [install the openapicmd tool](https://openapistack.co/docs/openapicmd/intro/) and run:

```bash
openapi typegen https://api.brightsky.dev/openapi.json > assets/js/types/brightsky.d.ts
```
