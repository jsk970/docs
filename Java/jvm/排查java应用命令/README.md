# Java 应用排障

1.查看当前系统有哪些 java 进程的,不加参数会列出所有的进程 id（但这个列表可能会不准确，如果查不到，还是要以 ps -ef 为准）
```shell
jps
```

2.查看 jvm 的 gc 情况，可以看到gc 次数，gc 停顿的时间等

```shell
 jstat -gc  pid
 ```

3.查看 当前 jvm 进程的内存分配和使用情况，尤其可以看到老年代的分配大小及使用率。

```shell
jmap -heap pid
```

4.查看当前jvm 中所有对象的大小和数量，用来分析 jvm 内存占用。

```shell
jmap -histo pid
```

5.查看当前 jvm 中的所有线程，用来分析线程堆栈。

```shell
jstack pid
```

如果查当前的总线程数， 可以用 
```shell
jstack pid > thread.log 
```
输出到 thread.log 文件中，然后用 grep  'prio='来进行过滤统计；也可以查看某组线程的数据量、线程 Runnable 等情况。