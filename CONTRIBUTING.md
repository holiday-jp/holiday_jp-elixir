CONTRIBUTING
==
Maintenace tasks
--
`mix update`
Update all dependencies.

`mix generate.holidays`
Generate holidays.ets from holiday_jp dataset.

Run lint, type checks and tests with coverage:

```sh
mix format --check-formatted
mix credo --strict
mix dialyzer
mix test --cover
```
