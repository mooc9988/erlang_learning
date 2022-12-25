{application, 'make_hello_world_example', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['hello_handler','make_hello_world_example_app','make_hello_world_example_sup']},
	{registered, [make_hello_world_example_sup]},
	{applications, [kernel,stdlib,debugger,cowboy]},
	{mod, {make_hello_world_example_app, []}},
	{env, []}
]}.