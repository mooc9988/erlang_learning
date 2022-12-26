
# How to use
## Before started
Use VSCode Extension **"Erlang LS"** extension for **debugging**.

launch.json for vscode can be :
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Existing Erlang Node",
            "type": "erlang",
            "request": "launch",
            "projectnode": "make_release_example_release",
            "cookie": "make_release_example_release",
            "timeout": 300,
            "cwd": "${workspaceRoot}"
        }
    ]
}
```

Pls ensure that projectnode & cookie **_are the same with_** release name in 'relx.config'!

## Debugging
```
gmake run
```
Set a breakpoint in 'src/hello_handler.erl' and press F5.
```
curl -i http://localhost:8080
```

## Addition
You can generally refer to [this](https://blog.csdn.net/wwwmewww/article/details/104129267) to start a project.

There are some differences from the above ref that you have to know:
* delete 'config' folder used by relx. The folder is generated automatically to support release feature by 
```
gmake -f erlang.mk bootstrap bootstrap-rel
```
* delete "sys_config" and  "vm_args" settings in relx.config
* add "LOCAL_DEPS = debugger" in Makefile according to [offical guide](https://erlang-ls.github.io/articles/tutorial-debugger/)