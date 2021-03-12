# Arraylist扩容机制（基于JDK 1.8）
- 一.ArrayList继承了AbstractList，实现了List接口，底层实现基于数组，因此可以认为是一个可变长度的数组。
- 二.在讲扩容机制之前，我们需要了解一下ArrayList中最主要的几个变量：

```java
//定义一个空数组以供使用
private static final Object[] EMPTY_ELEMENTDATA = {};
//也是一个空数组，跟上边的空数组不同之处在于，这个是在默认构造器时返回的，扩容时需要用到这个作判断，后面会讲到
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};
//存放数组中的元素，注意此变量是transient修饰的，不参与序列化
transient Object[] elementData;
//数组的长度，此参数是数组中实际的参数，区别于elementData.length，后边会说到
private int size;
```

- 三.ArrayList有三个构造函数，不同的构造函数会影响后边的扩容机制判断

1.默认的无参构造

```java
public ArrayList() {
this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
}
```
>可以看到，调用此构造函数，返回了一个空的数组 DEFAULTCAPACITY_EMPTY_ELEMENTDATA，此数组长度为0.

2.给定初始容量的构造函数
```java
public ArrayList(int initialCapacity) {
    if (initialCapacity > 0) {
        this.elementData = new Object[initialCapacity];
    } else if (initialCapacity == 0) {
        this.elementData = EMPTY_ELEMENTDATA;
    } else {
        throw new IllegalArgumentException("Illegal Capacity: "+initialCapacity);
    }
}
```
>逻辑很简单，就是构造一个具有指定长度的空数组，当initialCapacity为0时，返回 EMPTY_ELEMENTDATA

3.包含特定集合元素的构造函数
```java
public ArrayList(Collection<? extends E> c) {
    elementData = c.toArray();
    if ((size = elementData.length) != 0) {
        // c.toArray might (incorrectly) not return Object[] (see 6260652)
        if (elementData.getClass() != Object[].class)
            elementData = Arrays.copyOf(elementData, size, Object[].class);
    } else {
        // replace with empty array.
        this.elementData = EMPTY_ELEMENTDATA;
    }
}
```
>把传入的集合转换为数组，然后通过Arrays.copyOf方法把集合中的元素拷贝到elementData中。同样，若传入的集合长度为0，返回 EMPTY_ELEMENTDATA

- 四.扩容机制
扩容开始于集合添加元素方法，添加元素有两种方法
```java
public boolean add(E e) {
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    elementData[size++] = e;
    return true;
}
public void add(int index, E element) {
    rangeCheckForAdd(index);
    ensureCapacityInternal(size + 1);  // Increments modCount!!
    System.arraycopy(elementData, index, elementData, index + 1,size - index);
    elementData[index] = element;
    size++;
}
```
>可以看到两个方法都调用了ensureCapacityInternal(size + 1)方法，把数组长度加1以确保能存下下一个数据
```java
private void ensureCapacityInternal(int minCapacity) {
    ensureExplicitCapacity(calculateCapacity(elementData, minCapacity));
}
```
>此方法会先调用calculateCapacity方法，此时minCapacity为1，即size+1，因为初始时size为0
```java
private static int calculateCapacity(Object[] elementData, int minCapacity) {
    if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
        return Math.max(DEFAULT_CAPACITY, minCapacity);
    }
    return minCapacity;
}
```

`重点来了`，此方法会判断当前数组是否为DEFAULTCAPACITY_EMPTY_ELEMENTDATA，之前就强调了无参构造时才会返回这个数组。所以，若创建ArrayList时调用的是无参构造，此方法会返回DEFAULT_CAPACITY（值为10）和minCapacity的最大值，因此，最终会返回固定值10；若创建ArrayList时调用了有参构造，则此方法会返回1，注意这个
minCapacity变量只是第一次调用add方法时值为1，此后的调用需要根据实际的数组长度size+1。
然后调用ensureExplicitCapacity方法，
```java
private void ensureExplicitCapacity(int minCapacity) {
    modCount++;
    // overflow-conscious code
    if (minCapacity - elementData.length > 0)
    grow(minCapacity);
}
```
modCount++用到了快速失败机制，此处先不做讨论。
如果minCapacity大于elementData.length,则会调用grow方法，注意，这个elementData.length返回的是当前数组的容量，而不是数组实际的长度size。如果调用了有参构造，例如传入的容量为5，则此时elementData.length值即为5，而此时第一次调用add时，size值为0，因此minCapacity为1，不满足条件，此情况不需要扩容调用grow方法；如果调用了无参构造返回数组DEFAULTCAPACITY_EMPTY_ELEMENTDATA，注意这个数组只是一个空数组，因此此时elementData.length为0，满足条件，需要扩容调用grow方法。
可能说的太啰嗦，通俗来讲，就是如果ArrayList给定了特定初始容量，则此处需要根据实际情况确定是否调用grow方法，即有可能不需要扩容。如果没有指定初始容量，第一次调用add则此处一定需要调用grow方法。
那么，下面就看grow方法都做了哪些处理吧
```java
private void grow(int minCapacity) {
    // overflow-conscious code
    int oldCapacity = elementData.length;
    int newCapacity = oldCapacity + (oldCapacity >> 1);
    if (newCapacity - minCapacity < 0)
    newCapacity = minCapacity;
    if (newCapacity - MAX_ARRAY_SIZE > 0)
    newCapacity = hugeCapacity(minCapacity);
    // minCapacity is usually close to size, so this is a win:
    elementData = Arrays.copyOf(elementData, newCapacity);
}
```
int newCapacity = oldCapacity + (oldCapacity >> 1)此行代码即为扩容的核心，oldCapacity为原来的容量，右移一位，即除以2，因此这句的意思就是新的容量newCapacity=oldCapacity+oldCapacity /2，即原来的1.5倍。
然后判断newCapacity如果小于传入的minCapacity，则直接让newCapacity等于minCapacity，即不需要扩容计算（当无参构造时，elementData.length为0，所以oldCapacity也为0，minCapacity为10，因此最终newCapacity为10）。
然后判断newCapacity是否大于设定的MAX_ARRAY_SIZE，此处
private static final int MAX_ARRAY_SIZE = Integer.MAX_VALUE - 8;
如果大于，则调用hugeCapacity方法
```java
private static int hugeCapacity(int minCapacity) {
    if (minCapacity < 0) // overflow
    throw new OutOfMemoryError();
    return (minCapacity > MAX_ARRAY_SIZE) ?
    Integer.MAX_VALUE :
    MAX_ARRAY_SIZE;
}
```
如果minCapacity大于MAX_ARRAY_SIZE，则返回Integer的最大值，否则返回MAX_ARRAY_SIZE
最后，通过Arrays.copyOf方法把原数组的内容放到更大容量的数组里面

