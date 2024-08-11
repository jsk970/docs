# Spring Data Jpa

| Keyword             | Sample                                                       | JPQL snippet                                                 |
| :------------------ | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `And`               | `findByLastnameAndFirstname`                                 | `… where x.lastname = ?1 and x.firstname = ?2`               |
| `Or`                | `findByLastnameOrFirstname`                                  | `… where x.lastname = ?1 or x.firstname = ?2`                |
| `Is,Equals`         | `findByFirstname`, `findByFirstnameIs`, `findByFirstnameEquals` | `… where x.firstname = ?1`                                   |
| `Between`           | `findByStartDateBetween`                                     | `… where x.startDate between ?1 and ?2`                      |
| `LessThan`          | `findByAgeLessThan`                                          | `… where x.age < ?1`                                         |
| `LessThanEqual`     | `findByAgeLessThanEqual`                                     | `… where x.age <= ?1`                                        |
| `GreaterThan`       | `findByAgeGreaterThan`                                       | `… where x.age > ?1`                                         |
| `GreaterThanEqual`  | `findByAgeGreaterThanEqual`                                  | `… where x.age >= ?1`                                        |
| `After`             | `findByStartDateAfter`                                       | `… where x.startDate > ?1`                                   |
| `Before`            | `findByStartDateBefore`                                      | `… where x.startDate < ?1`                                   |
| `IsNull`            | `findByAgeIsNull`                                            | `… where x.age is null`                                      |
| `IsNotNull,NotNull` | `findByAge(Is)NotNull`                                       | `… where x.age not null`                                     |
| `Like`              | `findByFirstnameLike`                                        | `… where x.firstname like ?1`                                |
| `NotLike`           | `findByFirstnameNotLike`                                     | `… where x.firstname not like ?1`                            |
| `StartingWith`      | `findByFirstnameStartingWith`                                | `… where x.firstname like ?1`(parameter bound with appended `%`) |
| `EndingWith`        | `findByFirstnameEndingWith`                                  | `… where x.firstname like ?1`(parameter bound with prepended `%`) |
| `Containing`        | `findByFirstnameContaining`                                  | `… where x.firstname like ?1`(parameter bound wrapped in `%`) |
| `OrderBy`           | `findByAgeOrderByLastnameDesc`                               | `… where x.age = ?1 order by x.lastname desc`                |
| `Not`               | `findByLastnameNot`                                          | `… where x.lastname <> ?1`                                   |
| `In`                | `findByAgeIn(Collection<Age> ages)`                          | `… where x.age in ?1`                                        |
| `NotIn`             | `findByAgeNotIn(Collection<Age> age)`                        | `… where x.age not in ?1`                                    |
| `True`              | `findByActiveTrue()`                                         | `… where x.active = true`                                    |
| `False`             | `findByActiveFalse()`                                        | `… where x.active = false`                                   |
| `IgnoreCase`        | `findByFirstnameIgnoreCase`                                  | `… where UPPER(x.firstame) = UPPER(?1)`                      |

> Querydsl定义了一种常用的静态类型语法，用于在持久域模型数据之上进行查询。JDO和JPA是Querydsl的主要集成技术。本文旨在介绍如何使用Querydsl与JPA组合使用。JPA的Querydsl是JPQL和Criteria查询的替代方法。QueryDSL仅仅是一个通用的查询框架，专注于通过Java API构建类型安全的SQL查询。

- 要想使用QueryDSL，需要做两个前提操作：

1、pom文件中，加入依赖

```
<!--query dsl -->
<dependency> 
    <groupId>com.querydsl</groupId> 
    <artifactId>querydsl-jpa</artifactId> 
</dependency>
<dependency> 
    <groupId>com.querydsl</groupId> 
    <artifactId>querydsl-apt</artifactId> 
    <scope>provided</scope> 
</dependency> 
```

2、pom文件中，加入编译插件

```xml
<plugin> 
    <groupId>com.mysema.maven</groupId> 
    <artifactId>apt-maven-plugin</artifactId> 
    <version>1.1.3</version> 
    <executions> 
        <execution> 
            <goals> 
                <goal>process</goal> 
            </goals> 
            <configuration> 
                <outputDirectory>target/generated-sources/java</outputDirectory> 
                <processor>com.querydsl.apt.jpa.JPAAnnotationProcessor</processor> 
            </configuration> 
        </execution> 
    </executions> 
</plugin> 
```


> 该插件会查找使用javax.persistence.Entity注解的域类型，并为它们生成对应的查询类型。下面以User实体类来说明，生成的查询类型如下：

```java
package com.chhliu.springboot.jpa.entity; 
import static com.querydsl.core.types.PathMetadataFactory.*; 
import com.querydsl.core.types.dsl.*; 
import com.querydsl.core.types.PathMetadata; 
import javax.annotation.Generated; 
import com.querydsl.core.types.Path; 
/** 
 * QUser is a Querydsl query type for User 
 */
@Generated("com.querydsl.codegen.EntitySerializer") 
public class QUser extends EntityPathBase<User> { 
    private static final long serialVersionUID = 1153899872L; 
    public static final QUser user = new QUser("user"); 
    public final StringPath address = createString("address"); 
    public final NumberPath<Integer> age = createNumber("age", Integer.class); 
    public final NumberPath<Integer> id = createNumber("id", Integer.class); 
    public final StringPath name = createString("name"); 
    public QUser(String variable) { 
        super(User.class, forVariable(variable)); 
    } 

    public QUser(Path<? extends User> path) { 
        super(path.getType(), path.getMetadata()); 
    } 

    public QUser(PathMetadata metadata) { 
        super(User.class, metadata); 
    } 
} 

```

> 我们建立好实体类之后，然后运行mvn clean complie命令，就会在以下目录下生成对应的查询类型。

```xml
<outputDirectory>target/generated-sources/java</outputDirectory>
```

### Spring Data Jpa 实现分页查询示例

> Controller层

```
@ApiOperation(value = "分页查询")
@GetMapping
public ResultVO<AllRecords<AuctionHeaderView>> auctionsQuery(AuctionQueryVo auctionQueryVo) {
    UserInfo operator = currentUserService.currentUserInfo();
    if (null == operator) {
        log.error("currentUserInfo is null");
        throw new PscmAuctionException("currentUserInfo is null");
    }
    AllRecords<AuctionHeaderView> allRecords = auctionService.pageAuction(auctionQueryVo, operator);
    return ResultVOBuilder.success(allRecords);
}
```

> service层

```
public AllRecords<AuctionHeaderView> pageAuction(AuctionQueryVo queryVo, UserInfo userInfo) {
    log.info("start-pageAuction,pageQuery = {}", queryVo);
    BooleanExpression last = Expressions.asBoolean(true).isTrue();

    last = AuctionHeaderRepository.getBooleanExpression(queryVo, last, userInfo);
    log.info("pageAuction-last = {}", last);
    PageRequest pageRequest = new PageRequest(queryVo.getPageIndex() - 1, queryVo.getPageSize(), new Sort(Sort.Direction.DESC, createTime));

    Page<AuctionHeader> result = repository.findAll(last, pageRequest);
    AllRecords<AuctionHeaderView> allRecords = new AllRecords();

    List<AuctionHeader> content = result.getContent();
    List<AuctionHeaderView> list = content.stream().map(AuctionHeaderView::new).collect(Collectors.toList());

    allRecords.setDataList(list);
    allRecords.setTotalPage(result.getTotalPages());
    allRecords.setPageSize(queryVo.getPageSize());
    allRecords.setPageIndex(queryVo.getPageIndex());
    allRecords.setTotalNumber(result.getTotalElements());

    return allRecords;
}
```

> AuctionHeaderRepository

```java

public interface AuctionHeaderRepository extends JpaRepository<AuctionHeader, String>, QuerydslPredicateExecutor<AuctionHeader> {
    AuctionHeader findFirstByCreateUserNameOrderByCreateTimeDesc(String createUserName);


    List<AuctionHeader> findByAuctionTimeBeginBeforeAndAuctionTimeEndAfterAndBidStatus(Date now, Date now2, BidStatusEnum bidStatus);

    List<AuctionHeader> findByAuctionTimeBeginBeforeAndBidStatus(Date now, BidStatusEnum bidStatus);

    List<AuctionHeader> findByLegalPersonCodeAndCreateUserNameAndBidStatus(String legalPersonCode, String currentUserCode, BidStatusEnum bidStatus);

    static BooleanExpression getBooleanExpression(AuctionQueryVo query, BooleanExpression last, UserInfo userInfo) {
        if (StringUtils.isNotBlank(query.getLegalPersonCode())) {
            last = last.and(QAuctionHeader.auctionHeader.legalPersonCode.eq(query.getLegalPersonCode()));
        }
        if (StringUtils.isNotBlank(query.getAuctionCode())) {
            last = last.and(QAuctionHeader.auctionHeader.auctionCode.eq(query.getAuctionCode()));
        }
        if (StringUtils.isNotBlank(query.getAuctionYear())) {
            last = last.and(QAuctionHeader.auctionHeader.auctionYear.eq(AuctionYearEnum.getAuctionYearEnumByValue(query.getAuctionYear())));
        }
        if (null != query.getDisposalMethods()) {
            last = last.and(QAuctionHeader.auctionHeader.disposalMethods.eq(query.getDisposalMethods()));
        }
        if (!CollectionUtils.isEmpty(query.getBusinessAttributes())) {
            last = last.and(QAuctionHeader.auctionHeader.businessAttributes.in(query.getBusinessAttributes()));
        }
        if (StringUtils.isNotBlank(query.getAreaType())) {
            last = last.and(QAuctionHeader.auctionHeader.areaType.eq(AreaTypeEnum.getAreaTypeEnumByValue(query.getAreaType())));
        }
        if (!CollectionUtils.isEmpty(query.getAreaCodeList())) {
            last = last.and(QAuctionHeader.auctionHeader.areaCode.in(query.getAreaCodeList()));
        }
        if (StringUtils.isNotBlank(query.getBondedArea())) {
            if (BondedAreaEnum.Inside.getValue().equals(query.getBondedArea())) {
                last = last.and(QAuctionHeader.auctionHeader.bondedArea.eq(BondedAreaEnum.Inside));
            }
            if (BondedAreaEnum.Outside.getValue().equals(query.getBondedArea())) {
                last = last.and(QAuctionHeader.auctionHeader.bondedArea.eq(BondedAreaEnum.Outside));
            }
        }
        if (null != query.getAuctionTimeEnd()) {
            last = last.and(QAuctionHeader.auctionHeader.auctionTimeEnd.loe(DateUtils.getEndTimeOfDay(query.getAuctionTimeEnd())));
        }
        if (null != query.getAuctionTimeBegin()) {
            last = last.and(QAuctionHeader.auctionHeader.auctionTimeBegin.goe(DateUtils.getStartTimeOfDay(query.getAuctionTimeBegin())));
        }
        if (null != query.getPublicTimeEnd()) {
            last = last.and(QAuctionHeader.auctionHeader.publicTimeEnd.loe(DateUtils.getEndTimeOfDay(query.getPublicTimeEnd())));
        }
        if (null != query.getPublicTimeBegin()) {
            last = last.and(QAuctionHeader.auctionHeader.publicTimeBegin.goe(DateUtils.getStartTimeOfDay(query.getPublicTimeBegin())));
        }
        if (null != query.getCreateTimeEnd()) {
            last = last.and(QAuctionHeader.auctionHeader.createTime.loe(DateUtils.getEndTimeOfDay(query.getCreateTimeEnd())));
        }
        if (null != query.getCreateTimeBegin()) {
            last = last.and(QAuctionHeader.auctionHeader.createTime.goe(DateUtils.getStartTimeOfDay(query.getCreateTimeBegin())));
        }
        if (null != query.getStatus()) {
            last = last.and(QAuctionHeader.auctionHeader.status.eq(query.getStatus()));
        }
        if (null != userInfo) {
            last = last.and(QAuctionHeader.auctionHeader.createUserName.eq(userInfo.getCode()));
        }
        return last;
    }
}
```


