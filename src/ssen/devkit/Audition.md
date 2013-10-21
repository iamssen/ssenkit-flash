# 간단한 사용법



- 동기 처리 `[test] function(assert:Assert):void { assert.equal(a, b) }`
- 비동기 처리 `[test] function(done:Function):void { done(err) }`
- UI 비동기 처리 `[test] function(ui:DisplayObject, done:Function):void { done(err) }`
	- ui 의 type 에 따라서 IVisualElementContainer 또는 SpriteVisualElement 에 add 된다
	- 일단 너무 커지니깐 차후에 정리하자...

describeType 으로 봐서 function 에 들어오는 type 을 봐서 처리...

- `[before] function([done:Function]):void`
- `[beforeEach] function([done:Function]):void`
- `[after] function([done:Function]):void`
- `[afterEach] function([done:Function]):void`

기본 테스트 클래스를 작성

	class Test {
	
		[before]
		public function before():void {
		}
		
		[act]
		public function sampleLogin(done:Function):void {
		}
		
		[act]
		public function sampleUi(ui:DisplayObject, done:Function):void {
		}
	}
	
Audition 이라는 Player 를 통해서 실행

	class TestPlay extends Sprite {
		public function TestPlay() {
			Audition.add(Test);
			Audition.add(Test2);
			// start 시에 flex 인지 sprite 인지 구분해서 기준을 만들어냄 (차후 추가)
			Audition.start(this);			
		}
	}