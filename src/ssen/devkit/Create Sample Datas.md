# Sample Datas

	/** 스크롤 테스트에 사용할 장문의 글을 만든다 */
	public static function getLongText(minLines:int=10, maxLines:int=500, minWords:int=10, maxWords:int=300):String {
		var str:String="START\n";
		var rand:int=MathUtils.rand(minLines, maxLines);
		var f:int=-1;
		var a:String;
		var i:int;
		while (++f < rand) {
			i=MathUtils.rand(minWords, maxWords);
			a="";
			while (--i >= 0) {
				a+="A";
			}
			str+=f + a + "X\n";
		}
		str+="END";
		return str;
	}

	/** Random Easing Function */
	public static function getRandomEaseFunction():Function {
		var eases:Vector.<Function>=new <Function>[Linear.easeNone, Back.easeIn, Back.easeInOut, Back.easeOut, Bounce.easeIn, Bounce.easeInOut, Bounce.easeOut, Circ.easeIn,
												   Circ.easeInOut, Circ.easeOut, Cubic.easeIn, Cubic.easeInOut, Cubic.easeOut, Elastic.easeIn, Elastic.easeInOut, Elastic.easeOut,
												   Expo.easeIn, Expo.easeInOut, Expo.easeOut, Quad.easeIn, Quad.easeInOut, Quad.easeOut, Quart.easeIn, Quart.easeInOut,
												   Quart.easeOut, Quint.easeIn, Quint.easeInOut, Quint.easeOut, Sine.easeIn, Sine.easeInOut, Sine.easeOut];
		return eases[MathUtils.rand(0, eases.length - 1)];
	}

	/** 스크롤 테스트에 사용할 큰 박스를 만든다 */
	public static function getLineBox(minWidth:int=600, maxWidth:int=4500, minHeight:int=600, maxHeight:int=4500):DisplayObject {
		var s:Shape=new Shape();
		var g:Graphics=s.graphics;
		var w:int=MathUtils.rand(minWidth, maxWidth);
		var h:int=MathUtils.rand(minHeight, maxHeight);
		g.beginFill(MathUtils.rand(0x000000, 0xffffff));
		g.drawRect(0, 0, w, h);
		g.endFill();
		g.beginFill(0xC5D5FC);
		g.drawRect(0, 0, w, 10);
		g.drawRect(0, 10, 10, h - 20);
		g.drawRect(w - 10, 10, 10, h - 20);
		g.drawRect(0, h - 10, w, 10);
		g.endFill();
		
		return s;
	}
	
	/** 점을 찍을 랜덤한 원을 만든다 */
	public static function getCircle(radius:int):DisplayObject {
		var s:Shape=new Shape;
		s.graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		s.graphics.drawCircle(0, 0, radius);
		s.graphics.endFill();
		return s;
	}