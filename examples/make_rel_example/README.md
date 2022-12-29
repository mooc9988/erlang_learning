# What it is
This is a demo project for Erlang OTP application release. The application will return you a message about how many times it has been called by 'bertie:rpc'.
# How to Run
```
gmake run
```
An Erlang shell will be generated, where app has been run. See:
```
application:loaded_applications().
```
# How to call
In the Erlang shell, input:
```
bertie:rpc([]).
```
or 
```
bertie:rpc({user, curtis}).
```
# How to debug in IDE
Pls use VSCode and add following extensions:
* **Erlang LS**
* **Erlang Formatter**

launch.json for vscode can be :
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Existing Erlang Node",
            "type": "erlang",
            "request": "launch",
            "projectnode": "make_rel_example_release",
            "cookie": "make_rel_example_release",
            "timeout": 300,
            "cwd": "${workspaceRoot}"
        }
    ]
}
```
Pls ensure that projectnode & cookie **_are the same with_** release name in 'relx.config'!

After the above procedures, create a breakpoint in some place, like some line in 'bertie:check_times'. Then, press F5.

Call the service as shown in the previous section and you will see the progress just stops at the breakpoint.
# How to trace
## Use 'recon_trace'
[Recon](https://ferd.github.io/recon/recon_trace.html#summary) has been included in the application by dependency. So you can just trace what you care with tool 'recon_trace'.

For example, if you cares about the stack after you input 'bertie:rpc([]).', you can:
```
(make_rel_example_release@tianjiedeMBP)24> recon_trace:calls({bertie,'_', fun(_) -> return_trace() end}, 20, [{scope, local}]).     
13
(make_rel_example_release@tianjiedeMBP)25> bertie:rpc([]).

19:26:57.416907 <0.455.0> bertie:rpc([])

19:26:57.416987 <0.334.0> bertie:handle_call([], {<0.455.0>,[alias|#Ref<0.3196106731.1569783809.92965>]}, {state,"bertie_database"})

19:26:57.417031 <0.334.0> bertie:check_times("bertie_database")

19:26:57.426172 <0.334.0> bertie:fetch(#Ref<0.3196106731.1569718275.93247>)

19:26:57.426649 <0.334.0> bertie:fetch/1 --> 11

19:26:57.426682 <0.334.0> bertie:store(#Ref<0.3196106731.1569718275.93247>, 12)

19:26:57.431728 <0.334.0> bertie:store/2 --> ok
"Bertie has been run 11 times"

19:26:57.435240 <0.334.0> bertie:check_times/1 --> [66,101,114,116,105,101,32,104,97,115,32,98,101,101,110,32,114,117,110,32,
 "11",32,116,105,109,101,115]
                                           
19:26:57.435369 <0.334.0> bertie:handle_call/3 --> {reply,"Bertie has been run 11 times",{state,"bertie_database"}}
                                           
19:26:57.435433 <0.455.0> bertie:rpc/1 --> "Bertie has been run 11 times"
(make_rel_example_release@tianjiedeMBP)26> recon_trace:clear().
ok
```
The whole calling chain has been shown as above. 
## Use redbug
[Redbug](https://github.com/massemanet/redbug) has also been included in this project.

For example, trace the call of 'bertie:store', trace the return value of it, print the stack and print milliseconds on time stamps:

```
(make_rel_example_release@tianjiedeMBP)28> redbug:start("bertie:store/2->return,stack", [{print_msec, true}]).
{76,1}
(make_rel_example_release@tianjiedeMBP)29> bertie:rpc([]).

% 11:59:50.812 <0.347.0>(bertie)
% bertie:store(#Ref<0.3391413722.1447821314.116015>, 18)
%   bertie:check_times/1 
%   bertie:handle_call/3 
%   gen_server:try_handle_call/4 
%   gen_server:handle_msg/6 
%   proc_lib:init_p_do_apply/3 

% 11:59:50.814 <0.347.0>(bertie)
% bertie:store/2 -> ok
"Bertie has been run 17 times"
redbug done, timeout - 1  
```