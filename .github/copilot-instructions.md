We use Elixir and Phoenix LiveView for our web application.

If I prompt you in german, make sure to write all code and especially comments in english.

If possible, use `{:ok, result}` and `{:error, reason}` tuples for error handling in Elixir functions.

Try documenting functions with `@doc` and `@spec` attributes, providing clear descriptions of the function's purpose, parameters, and return values.

When writing tests, name two variables: `actual` and `expected` and compare them using `assert actual == expected`, when appropriate.

If you want to run unit tests or dialyzer, use the `mix check` because it runs all quality checks at once.

In case you encounter formatting issues, try running `mix check --fix` to automatically fix them.

When possible, use "Salad UI" for UI components: https://salad-storybook.fly.dev/, for example for a dropdown menu, use: https://salad-storybook.fly.dev/salad_ui_component/dropdown_menu

Access those Salad UI components directly, like this `SaladUI.DropdownMenu.dropdown_menu`
