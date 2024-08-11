# HashMap和HashTable的区别

## 1、两者的父类不同

- HashMap 继承自 AbstractMap类
- HashTable 继承自Dictionary类

> 但是两者都实现了Map、CloneAble（可复制）、Serializable（可序列化）三个接口。

## 2、对外提供的接口不同

HashTable 比 HashMap 多提供了 elments()和contains()两个方法

- elments()方法继承自HashTable的父类Dictionary。用于返回此HashTable中的value的枚举。
- contains()方法判断HashTable是否包含传入的values。

## 3、对NULL的支持不同

- HashMap：key可以为NULL,但是这样的key只能有一个，但是可以有多个Key值对应的value为NULL.
- HashTable：key和value都不能为NULL.

## 4、安全性不同

- HashMap是线程不安全的，在多线程并发的环境下，可能会产生死锁等问题

- Hashtable是线程安全的，它的每个方法上都有synchronized 关键字，因此可直接用于多线程中。

> 虽然HashMap是线程不安全的，但是它的效率远远高于Hashtable，这样设计是合理的，因为大部分的 使用场景都是单线程。当需要多线程操作的时候可以使用线程安全的ConcurrentHashMap。 
>
> ConcurrentHashMap是线程安全的，但是它的效率比Hashtable要高好多倍。因为 ConcurrentHashMap使用了分段锁，并不对整个数据进行锁定。

## 5、初始化容量大小和每次扩充容量大小不同

- 在HashTable中，hash数组默认大小是11，增加的方式是old*2+1。

- 在HashMap中，hash数组默认大小是16，增加的方式是2*old而且一定是2的整数.



## 6、计算Hash值的方法不同

- HashTable直接使用对象的hashCode

  ```java
  //hashtable的hash函数   
   private int hash(Object k) {
          // hashSeed will be zero if alternative hashing is disabled.
          return hashSeed ^ k.hashCode();
      }
  ```

- hashmap的hash函数多次进行异或右移操作，目的是将hash值的高位和地位都参与运算，避免桶位聚集现象，让数据分散的更均匀一点。

  ```java
  //hashmap的hash函数
  final int hash(Object k) {
          int h = hashSeed;
          if (0 != h && k instanceof String) {
              return sun.misc.Hashing.stringHash32((String) k);
          }
   
          h ^= k.hashCode();
   
          // This function ensures that hashCodes that differ only by
          // constant multiples at each bit position have a bounded
          // number of collisions (approximately 8 at default load factor).
          h ^= (h >>> 20) ^ (h >>> 12);
          return h ^ (h >>> 7) ^ (h >>> 4);
  }
  ```

  