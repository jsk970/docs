# 浅拷贝
> 浅拷贝是按位拷贝对象，它会创建一个新对象，这个对象有着原始对象属性值的一份精确拷贝。如果属性是基本类型，拷贝的就是基本类型的值；如果属性是内存地址（引用类型），拷贝的就是内存地址 ，因此如果其中一个对象改变了这个地址，就会影响到另一个对象。

## 浅拷贝的特点
- (1) 对于基本数据类型的成员对象，因为基础数据类型是值传递的，所以是直接将属性值赋值给新的对象。基础类型的拷贝，其中一个对象修改该值，不会影响另外一个。
- (2) 对于引用类型，比如数组或者类对象，因为引用类型是引用传递，所以浅拷贝只是把内存地址赋值给了成员变量，它们指向了同一内存空间。改变其中一个，会对另外一个也产生影响。

## 浅拷贝的实现
实现对象拷贝的类，需要实现 Cloneable 接口，并覆写 clone() 方法。

## 浅拷贝示例
引用对象
```java
@Data
public class Subject {

    private String name;

    @Override
    public String toString() {
        return "Subject{" + this.hashCode() +",name='" + name + '\'' + '}';
    }
}
```

```java
@Data
public class Student implements Cloneable {
    /**
     * 引用数据类型
     */
    private Subject subject;

    /**
     * 基础数据类型
     */
    private String name;
    private int age;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    @Override
    public String toString() {
        return "Student{" + this.hashCode() +
                ",subject=" + subject +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```
浅拷贝
```java
public class ShallowCopy {

    public static void main(String[] args) throws Exception{
        Subject subject = new Subject();
        subject.setName("mySubject");

        Student student = new Student();
        student.setName("小明");
        student.setAge(10);
        student.setSubject(subject);

        Student student1 = (Student)student.clone();

        Subject subject1 = student.getSubject();
        subject1.setName("MySubject1");
        student1.setAge(20);
        student1.setName("小红");

        /**
         * 输出结果：
         * student:Student{1208542144,subject=Subject{384447148,name='MySubject1'}, name='小明', age=10}
         * student1:Student{1208583246,subject=Subject{384447148,name='MySubject1'}, name='小红', age=20}
         *
         * 由输出的结果可见，通过 studentA.clone() 拷贝对象后得到的 studentB，和 studentA 是两个不同的对象。
         * studentA 和 studentB 的基础数据类型的修改互不影响，而引用类型 subject 修改后是会有影响的。
         *
         */
        System.out.println("student:"+student);
        System.out.println("student1:"+student1);
    }
}
```
对象拷贝
```java
public class ObjectCopy {

    public static void main(String[] args) throws Exception{
        Subject subject = new Subject();
        subject.setName("mySubject");

        Student student = new Student();
        student.setName("小明");
        student.setAge(10);
        student.setSubject(subject);

        Student student1 = student;

        student1.setAge(20);
        student1.setName("小红");
        Subject subject1 = student1.getSubject();
        subject1.setName("MySubject1");

        /**
         *
         * 把 Student studentB = (Student) studentA.clone() 换成了 Student studentB = studentA
         *
         * 输出结果：
         * student:Student{1208583246,subject=Subject{384447148,name='MySubject1'}, name='小红', age=20}
         * student1:Student{1208583246,subject=Subject{384447148,name='MySubject1'}, name='小红', age=20}
         *
         * 由输出的结果可见，对象拷贝后没有生成新的对象，二者的对象地址是一样的；而浅拷贝的对象地址是不一样的。
         *
         */
        System.out.println("student:"+student);
        System.out.println("student1:"+student1);
    }
}
```

# 深拷贝
> 深拷贝，在拷贝引用类型成员变量时，为引用类型的数据成员另辟了一个独立的内存空间，实现真正内容上的拷贝。

## 深拷贝的特点
- 对于基本数据类型的成员对象，因为基础数据类型是值传递的，所以是直接将属性值赋值给新的对象。基础类型的拷贝，其中一个对象修改该值，不会影响另外一个（和浅拷贝一样）。
- 对于引用类型，比如数组或者类对象，深拷贝会新建一个对象空间，然后拷贝里面的内容，所以它们指向了不同的内存空间。改变其中一个，不会对另外一个也产生影响。
- 对于有多层对象的，每个对象都需要实现 Cloneable 并重写 clone() 方法，进而实现了对象的串行层层拷贝。
- 深拷贝相比于浅拷贝速度较慢并且花销较大。

## 深拷贝的实现
### 实现 Cloneable 接口
对于 Student 的引用类型的成员变量 Subject ，需要实现 Cloneable 并重写 clone() 方法。
```Java
@Data
public class SubjectDeep implements Cloneable {

    private String name;
    
    @Override
    protected Object clone() throws CloneNotSupportedException {
        //Subject 如果也有引用类型的成员属性，也应该和 StudentDeep 类一样实现
        return super.clone();
    }

    @Override
    public String toString() {
        return "Subject{" + this.hashCode() +",name='" + name + '\'' + '}';
    }
}
```

```java
@Data
public class StudentDeep implements Cloneable {
    /**
     * 引用数据类型
     */
    private SubjectDeep subject;

    /**
     * 基础数据类型
     */
    private String name;
    private int age;

    @Override
    protected Object clone() throws CloneNotSupportedException {
        StudentDeep studentDeep = (StudentDeep)super.clone();
        studentDeep.subject = (SubjectDeep)this.subject.clone();
        return studentDeep;
    }

    @Override
    public String toString() {
        return "Student{" + this.hashCode() +
                ",subject=" + subject +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

```java
public class DeepCopy {
    public static void main(String[] args) throws Exception{
        SubjectDeep subjectDeep = new SubjectDeep();
        subjectDeep.setName("mySubject");

        StudentDeep studentDeep = new StudentDeep();
        studentDeep.setName("小明");
        studentDeep.setAge(10);
        studentDeep.setSubject(subjectDeep);

        StudentDeep studentDeep1 = (StudentDeep)studentDeep.clone();

        SubjectDeep subjectDeep1 = studentDeep1.getSubject();
        subjectDeep1.setName("MySubject1");

        studentDeep1.setAge(20);
        studentDeep1.setName("小红");

        /**
         * 输出结果：
         * 
         * student:Student{-1260208555,subject=Subject{779380251,name='mySubject'}, name='小明', age=10}
         * student1:Student{1208583246,subject=Subject{384447148,name='MySubject1'}, name='小红', age=20}
         *
         * 由输出的结果可见，深拷贝后，不管是基础数据类型还是引用类型的成员变量，修改其值都不会相互造成影响。
         * 
         */
        System.out.println("student:"+studentDeep);
        System.out.println("student1:"+studentDeep1);
    }
}
```
### 实现Serializable接口
通过字节流序列化实现深拷贝，需要深拷贝的对象必须实现Serializable接口
```java
/**
 * 
 * @author Administrator
 */
public class CloneUtils {
	@SuppressWarnings("unchecked")
	public static <T extends Serializable> T clone(T obj) {
		T cloneObj = null;
		try {
			// 写入字节流
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			ObjectOutputStream obs = new ObjectOutputStream(out);
			obs.writeObject(obj);
			obs.close();
 
			// 分配内存，写入原始对象，生成新对象
			ByteArrayInputStream ios = new ByteArrayInputStream(out.toByteArray());
			ObjectInputStream ois = new ObjectInputStream(ios);
			// 返回生成的新对象
			cloneObj = (T) ois.readObject();
			ois.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cloneObj;
	}
}
```























