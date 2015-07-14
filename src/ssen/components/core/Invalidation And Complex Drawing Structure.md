# List and Items Transition (비율적 움직임)

- list side information
	- total (item 들의 합)
- item side information
	- ratio (item 들의 total 에 대한 비율)

작동

1. from list 와 to list 를 비교해서 item 갯수 맞추기
2. 시간 당 total 및 비율들 계산 (process 파워가 애매...)

이게 Tree가 되면?



# 렌더링에 필요한 기능들

- data --> render data --> renderer element 로 이어지는 체인을 관리할 기능
	- data
		- listen item value change event
		- listen item added / removed event
- animation state 관리
	- list change --> enter
	- list to null --> exit
	- list item value changed --> change
	- list item added --> add
	- list item removed --> remove
	- change / add / remove 는 한꺼번에 일어난다



# animation flag

- all start
- all end
- list change start (add, remove)
	- change / add | remove
	- add, remove 할 대상에 flag를 찍고 가야 할듯...
	- 하위에도 flag를 전달해줘야만 뭐 죽이되던 밥이 되던 할듯...
- focus
	- focus on / focus out

element 구조는 최상위에서 최대한 가지고 있는 것으로 하는게 좋을듯
어차피 data의 구조와 element의 구조는 다를 수 밖에 없다.

# animation track

|-------------------------------------| animation (duration)
|-------|===============|-------------| animation track (from, to, ease)
|OFF----|OFF===========O|N------------| interaction flag (필요한가?)

commit properties 에서 rendering 에 필요한 모든 정보는 전달해주고
이후 animation track에 의한 control 만을 연속한다

- commitProperties : 렌더링에 필요한 모든 정보들을 넣고, element 들을 생성 혹은 보정
- renderBegin(flag:string):void
- render(flag:string, animate:number):void
- renderEnd(flag:string):void

# commit properties 의 중요성

어쨌든 산만하게 흩어져있던 제어권들을 취합해서
중앙화 할 것들은 중앙화 시키고, 지역화 할 것들은 지역화 시키는 작업이 될 것 같다.

element 의 생성/삭제와 애니메이션 타이머의 제어는 중앙화
그리기, 애니메이션 타이밍의 변조는 지역화...가 될 것 같다.

- commit properties에서 지역화 될 항목들을 생성
- animation trigger는 update display list가 되어야 하나? (이게 약간 애매...)

# 내가 만들려고 하는게 뭐지?

- [기능] grid layout
- [범용] 사이즈 처리에 대한 적절한 template (rendering over head 방지)
	- commitProperties, measure 에 대한 적절한 providing
	- content size 에 대한 정보를 넣어서 새로운 연산 구조를 만든다
	- animation 처리

# Resize Types

정확히 이야기 하자면
외부에서 넘어오는 사이즈들에 대한 정책이 된다
외부에서 넘어오는 것들이 없으면 그냥 content size로 처리하면 된다
(commit properties에서 자체 계산)

commit properties 에서 content size 계산은 공통

케이스 지정
- content size 보다 작을때 설정 : resize | scroll | ignore
	- resize
		- measure 필요 없음
		- content size 대비 ratio 가 어떻게 되는지 계산해줌
	- scroll
		- measure 필요 없음
		- commit properties 에서 최소한의 min size 지정이 필요
			- grid 와 같은 경우 min visible row 와 같은걸 사용해서
	- ignore
		- measure 필요 없음
		- 정렬 위치를 알려줄 필요 있음
- content size 보다 클때 설정 : resize | cut | ignore
	- resize
		- measure 필요 없음
		- content size 대비 ratio 가 어떻게 되는지 계산해줌
	- cut (바깥으로 나가는 size에 영향을 미치게 된다)
		- measure 필요 없음
		- commit properties 에서 content size를 max size로 지정 필요
		- max / explicitMax 를 덮어쓸 필요가 있음
			- 그래야 더 작게 만들 수 있으니...
			- 요게 골치아픔...
	- ignore
		- measure 필요 없음
		- 정렬 위치를 알려줄 필요 있음


- Fit
	- rw minSize:Number
	- rw sizeRatios:Number[]
	- calculateSize(canvasSize:Number):Number[]
	- rw userExplicitMinSize : Number
	- r- skipMeasurement : Boolean


## content size가 고정적이면서, content size보다 커질 수 없는 경우 (정렬에 영향)
- content size : commit properties
- explicit min / max : 사용 불가 (내부 사이즈 로직에서 덮어쓰기 시킴)
	- explicit min : 최소한 보여야 되는 영역을 지정 (with visible min row와 같은 정보와 함께)
	- explicit max : content size가 최대한의 영역이 됨 (더이상 늘어날 수 없음)
	- commit properties 에서 지정해주면 됨
- 아싸리 measure 과정 자체를 거칠 필요가 없을듯...
- update display list 에서 scroll 의 visible 처리를 해줌
- 의도된 max size 역시 keep 하고 있어야 한다
	- set max size override 해서 입력을 읽어들인다
	- invalidate properties 를 통해서 explicit max 를 다시 over write 한다
	- content size > user max size 이면 user max size 를 사용하고, 아니면 content size로 지정한다

## content size가 고정적이면서, content size를 넘는 경우 여백 처리를 하는 경우 (정렬에 무영향)
- content size : commit properties
- update display list 에서 scroll 처리만 해줌

## content size가 비율적이기에 꽉 채워지는 경우


사이즈가 정해지는 시점들
- content size
	- commit properties 에서 정해야 함
- explicit size / min / max
	- 상시 입력됨
	- invalidateSize() 와 invalidateParentSizeAndDisplayList() 를 호출시킴
	- 내부적으로 can skip measurment, measure 에서 사이즈를 결정하길 요구함
- percent size
	- 상시 입력됨

특징
- content size 자체가 min / max 가 되기 때문에
- explicit / min / max 가 취소될 수 있다

작동 순서
- commit properties 에서 content size를 계산해 놓는다
- explicit = NaN | 0
- explicit min = NaN | 0
- explicit max = NaN | 0
- content size / explicit / min / max 를 통해 계산을 해놓는다
	- canSkipMeasurement 처리 여부
		- 활성화가 자주 일어나도 상관없을듯? (스크롤 처리 여부가 되는지라...)
	- scroll bar 사용 여부
	-
- can skip measurment 에서 explicit / min / max 가 있다해도 수치가 벗어나면 measure를 실행시킨다
- measure 에서 explicit / min / max 를 통해 size 계산을 한다

그 외

- scroll bar 의 활성화 여부를 알린다
- 중요 properties
	- content size
	- explicit / min / max size

## content size가 비율적일 수 있기 때문에 꽉 채워지는 경우


----

- size를 직접 입력해서 explicit 가 선언된 경우 (절대 외부에 의한 resize를 먹지 않는다)
	- commitProperties 에서 content size가 만들어짐
	- canSkipMeasurment 에서 넘어간다
- percent 를 입력해서 외부의 resize를 먹는 경우
	- commitProperties
- 아무것도 입력하지 않아서 자체적인 content의 size를 먹는 경우


# 구조

- commitProperties()
	- `refreshChildrenElements()` 하위 항목들의 변경이 있을 경우 Element들을 새로 작성한다
	- contentWidth / contentHeight 를 작성해 놓는다 (하위 항목들의 크기)
	- data에 의한 drawing 조건들은 모두 여기서 작성해놓는다 (가능하면 pooling을 사용하는게 좋을듯)
- canSkipMeasurement()
- measure()
- updateDisplayList()
	- commitProperties()에서 작성된 data에 의한 drawing 조건들과
	- event loop에 의한 state 조건들을 취합해서 실제 그리기를 한다