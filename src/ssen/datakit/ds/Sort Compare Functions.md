`Vector.sort()` 보다 `Array.sortOn()` 이 더 빠르다.

`function(a:int, b:int):int` 의 공식에서 `a > b` 큰 상황. 즉, `a - b` 가 1보다 커지는 상황 이라면 1...10 의 순서로 정렬되게 된다. 

# 숫자형 정렬 1...10

	function func(a:int, b:int):int {
		return a - b;
	}

# 숫자형 정렬 10...1

	function func(a:int, b:int):int {
		return b - a;
	}
	
# 문자형 정렬 a...z

	function func(a:String, b:String):int {
		var a1:int;
		var b1:int;
		var i:int = 0;
		while (true) {
			a1 = a.charCodeAt(i);
			b1 = b.charCodeAt(i);
			if (a1 - b1 != 0) {
				return a1 - b1;
			} else if (a1 + b1 > 0) {
				i++;
			} else {
				return 0;
			}
		}
		return 0;
	}

# 문자형 정렬 z...a

	function func(a:String, b:String):int {
		var a1:int;
		var b1:int;
		var i:int = 0;
		while (true) {
			a1 = a.charCodeAt(i);
			b1 = b.charCodeAt(i);
			if (b1 - a1 != 0) {
				return b1 - a1;
			} else if (a1 + b1 > 0) {
				i++;
			} else {
				return 0;
			}
		}
		return 0;
	}

# 랜덤 정렬

	function func(a:int, b:int):int {
		return MathUtils.rand(-1, 1);
	}	