{application, 'make_release_example', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['hello_handler','make_release_example_app','make_release_example_sup']},
	{registered, [make_release_example_sup]},
	{applications, [kernel,stdlib,debugger,cowboy]},
	{mod, {make_release_example_app, []}},
	{env, []}
]}.