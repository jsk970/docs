# Mysql中时间进位问题
mysql更新到5.6.4 之后 , 新增了一个叫factional seconds的特性 , 可以记录时间的毫秒值。但是目前的数据库是不记录毫秒值的 , 所以会产生一个java中时间的Milliseconds超过500就会四舍五入的问题。

下面是一个例子，演示了时间是如何进位的。首先创建一张表：CREATE TABLE test_time (

time_sec datetime,

time_millis datetime(3),

time_micros datetime(6),

stamp_sec timestamp,

stamp_millis timestamp(3),

stamp_micros timestamp(6)

);

有的小伙伴可能不知道 datetime 和 timestamp 定义时是可以带精度的，精度值为 0~6，表示保留几位小数，默认值为 0。显然保留 3 位可看作精度为毫秒，保留 6 位可看作精度为微秒。


然后我们插入一条记录：INSERT INTO test_time

( time_sec, time_millis, time_micros,

stamp_sec, stamp_millis, stamp_micros )

VALUES(

'2019-11-30 12:34:56.987654',

'2019-11-30 12:34:56.987654',

'2019-11-30 12:34:56.987654',

'2019-11-30 12:34:56.987654',

'2019-11-30 12:34:56.987654',

'2019-11-30 12:34:56.987654'

);

然后再做一次 select * from test_time 查询就能看到下面的结果：time_sec |time_millis |time_micros |stamp_sec |stamp_millis |stamp_micros |

---------------------|-----------------------|--------------------------|---------------------|-----------------------|--------------------------|

2019-11-30 12:34:57.0|2019-11-30 12:34:56.988|2019-11-30 12:34:56.987654|2019-11-30 12:34:57.0|2019-11-30 12:34:56.988|2019-11-30 12:34:56.987654|

可以看到 time_sec 和 stamp_sec 在数据库中的秒值都被进位了，time_millis 和 stamp_millis 的毫秒值都被进位了。

由此可见，要避免这样的误差，有两个手段：

1、定义字段的时候使用 datetime(6) 或 timestamp(6);

2、定义字段时不带精度，但在将时间存入数据库之前，要将毫秒值截取掉。