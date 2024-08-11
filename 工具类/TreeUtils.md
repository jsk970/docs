```java
package siiri.cloud.sjjf.library.biz.impl;

import lombok.extern.slf4j.Slf4j;
import siiri.cloud.sjjf.library.biz.vo.StandardItemVO;


import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author jiangsk
 * Date: 2021-10-29 13:43
 * Description:
 */

 @Slf4j
public class BuildTreeUtils {

    private List<StandardItemVO> standardItemVOList;

    public BuildTreeUtils(List<StandardItemVO> standardItemVOList){
        this.standardItemVOList = standardItemVOList;
    }

     /**
     * 获取根节点
     * @return
     */
    public List<StandardItemVO> getRootNode(){
        return standardItemVOList.stream()
                .filter(item -> item.getDataLevel().equals(0))
                .sorted(Comparator.comparing(StandardItemVO::getSortOrder))
                .collect(Collectors.toList());
    }

    /**
     * 建立树形结构
     */

     public List<StandardItemVO> buildTree(){
        List<StandardItemVO> treeStandardItem = new ArrayList<>();
        for(StandardItemVO node : getRootNode()) {
            node = buildChildTree(node);
            treeStandardItem.add(node);
        }
        return treeStandardItem
                .stream()
                .sorted(Comparator.comparing(StandardItemVO::getSortOrder))
                .collect(Collectors.toList());
    }

    /**
     * 递归，建立子树形结构
     * @param pNode
     * @return
     */
    private StandardItemVO buildChildTree(StandardItemVO pNode){
        List<StandardItemVO> child = new ArrayList<>();
        for(StandardItemVO node : standardItemVOList) {
            if(node.getParentId().equals(pNode.getId())) {
                child.add(buildChildTree(node));
            }
        }
        List<StandardItemVO> collect = child.stream()
                .sorted(Comparator.comparing(StandardItemVO::getSortOrder))
                .collect(Collectors.toList());
        pNode.setChild(collect);
        return pNode;
    
    }
}

```