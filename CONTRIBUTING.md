CONTRIBUTING
==
Maintenance tasks
--
`mix holiday_jp.update`
Update dependencies and regenerate holiday data.

`mix generate.holidays`
Generate `priv/holidays.exs` from the `holiday_jp` dataset. First run
`git submodule update --init holiday_jp`. Maintenance tasks are available in
the `dev` and `test` Mix environments, not `prod`.

Run lint, type checks and tests with coverage:

```sh
mix format --check-formatted
mix credo --strict
mix dialyzer
mix test --cover
```
