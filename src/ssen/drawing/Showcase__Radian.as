package ssen.drawing {
import flash.display.Graphics;
import flash.events.Event;

import mx.core.UIComponent;
import mx.utils.StringUtil;

import ssen.common.MathUtils;

public class Showcase__Radian extends UIComponent {
	public function Showcase__Radian() {
		addEventListener(Event.ADDED_TO_STAGE, enter);
	}

	private function enter(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, enter);
		addEventListener(Event.REMOVED_FROM_STAGE, exit);
		start();
	}

	private function exit(event:Event):void {
		end();
		removeEventListener(Event.REMOVED_FROM_STAGE, exit);
	}

	private var deg:Number;
	private const centerX:Number = 200;
	private const centerY:Number = 200;
	private const radius:Number = 80;

	private function start():void {
		deg = 0;
		addEventListener(Event.ENTER_FRAME, enterFrame);
	}

	private function enterFrame(event:Event):void {
		deg++;

		var r:Number;
		var x:Number;
		var y:Number;

		var g:Graphics = graphics;
		g.clear();

		// center
		g.beginFill(0xff0000);
		g.drawCircle(centerX, centerY, 2);
		g.endFill();

		// sec
		r = MathUtils.deg2rad(0);
		x = centerX + radius * Math.cos(r);
		y = centerY + radius * Math.sin(r);

		g.beginFill(0, 0.1);
		g.drawCircle(x, y, 2);
		g.endFill();

		r = MathUtils.deg2rad(90);
		x = centerX + radius * Math.cos(r);
		y = centerY + radius * Math.sin(r);

		g.beginFill(0, 0.1);
		g.drawCircle(x, y, 3);
		g.endFill();

		r = MathUtils.deg2rad(180);
		x = centerX + radius * Math.cos(r);
		y = centerY + radius * Math.sin(r);

		g.beginFill(0, 0.1);
		g.drawCircle(x, y, 4);
		g.endFill();

		r = MathUtils.deg2rad(270);
		x = centerX + radius * Math.cos(r);
		y = centerY + radius * Math.sin(r);

		g.beginFill(0, 0.1);
		g.drawCircle(x, y, 5);
		g.endFill();

		// deg
		r = MathUtils.deg2rad(deg);
		x = centerX + radius * Math.cos(r);
		y = centerY + radius * Math.sin(r);

		g.beginFill(0);
		g.drawCircle(x, y, 3);
		g.endFill();

		trace(StringUtil.substitute('deg {0}\nrad {1}', deg, r));
	}

	private function end():void {
		removeEventListener(Event.ENTER_FRAME, enterFrame);
	}
}
}