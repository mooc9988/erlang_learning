mkfile_path := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))  #获取当前正在执行的makefile的绝对目录
project_name ?= $(shell echo $(mkfile_path) | awk -F '/' '{print $$(NF-1)}')  #获取上级目录名
all:
	@rebar3 compile
	@erl -noshell -pa './_build/default/lib/bitcask/ebin' -pa "./_build/default/lib/joe_test/ebin" -s $(project_name) start