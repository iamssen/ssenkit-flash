[example](DataConverter__Example.as)

# multipleKeyDatasToTree : 다수의 key 가 달린 data list 를 tree 로 전환

`{cate1:"a", cate2:"b", cate3:"c", value:123}` 과 같은 형태의 데이터를

- a
	- b
		- c
			- `{cate1:"a", cate2:"b", cate3:"c", value:123}`
			
와 같은 tree 형태로 만들어준다.

`Array` 나 `IList` 같은 경우는 문제가 없었지만, `Vector` 에서 타입을 정확히 알기가 어려운고로, `Itr` 인터페이스로 감싸서 사용하기로 결정 

인자의 마지막인 `appendLastNodeWith:Function=null` 은 `function(node:TreeNode, source:Object):void` 형태로 작성되어야 하며, 지정되지 않으면 node 의 하위로 source 가 append 되게 된다. 
