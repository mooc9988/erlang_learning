# Notes
从Erlang OTP 21开始，sasl的配置项发生了很大变化，默认不在sasl的配置文件中配置日志的规范，详见[官方说明](https://www.erlang.org/doc/man/sasl_app.html)。

日志规范建议参照[logger模块的规范](https://www.erlang.org/doc/man/logger.html)。
原理以及其他示例可以[参考](https://ferd.ca/erlang-otp-21-s-new-logger.html)
内置的两种handler：logger_std_h和logger_disk_log_h的区别，[参照](https://www.erlang.org/doc/apps/kernel/logger_chapter.html#handlers)

因此，启动本应用的方法可以是：
* 将日志输出到指定日志文件中：
```
erl -boot start_sasl -config elog
```
* 将info级别的日志输出到console，将error级别的日志滚动输出到文件夹内：
```
erl -boot start_sasl -config elog2
```
