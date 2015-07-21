package ssen.animation {
import com.greensock.easing.Quad;

import flash.display.Graphics;

import mx.core.UIComponent;
import mx.utils.StringUtil;

public class Showcase__DataTransition extends UIComponent {
	public function Showcase__DataTransition() {
		var from:Array = [
			{primary: "A", value: 100},
			{primary: "B", value: 100},
			{primary: "C", value: 100},
			{primary: "D", value: 100},
			{primary: "E", value: 100}
		];

		var to:Array = [
			{primary: "B", value: 200},
			{primary: "A", value: 200},
			{primary: "E", value: 200},
			{primary: "D", value: 200},
			{primary: "C", value: 200}
		];

		var transition:ArrayedDataTransition = new ArrayedDataTransition;
		transition.from = from;
		transition.to = to;
		transition.primaryProperty = "primary";
		transition.property = "value";

		//		print(transition);
		draw(transition);
	}

	private function draw(transition:IDataTransition):void {
		var colors:Object = {
			A: 0x000000,
			B: 0xff0000,
			C: 0x00ff00,
			D: 0x0000ff,
			E: 0xcccccc
		}
		var snap:IDataTransitionSnapshot;
		var snaps:Vector.<IDataTransitionSnapshot> = new <IDataTransitionSnapshot>[];

		var ease:Function = Quad.easeOut;

		var f:int = -1;
		var fmax:int = 1000;
		var c:Number;
		while (++f <= fmax) {
			c = ease(f / fmax, 0, 1, 1);
			snap = transition.getSnapshot(c);
			snaps.push(snap);
		}

		var x:int = 10;
		var y:int = 10;
		var w:Number = 700;
		var h:Number = 400;

		var g:Graphics = graphics;
		var color:uint;
		var primaryValues:Vector.<String> = snaps[0].primaryValues;

		f = -1;
		fmax = primaryValues.length;
		var s:int;
		var smax:int;
		while (++f < fmax) {
			color = colors[primaryValues[f]];
			g.beginFill(color);

			s = -1;
			smax = snaps.length;
			while (++s < smax) {
				snap = snaps[s];

				if (s === 0) {
					g.moveTo(
							x,
							y + (snap.startRatios[0] * h)
					);
				} else {
					g.lineTo(
							x + ((s / smax) * w),
							y + (snap.startRatios[f] * h)
					)
				}
			}

			s = snaps.length;
			while (--s >= 0) {
				snap = snaps[s];

				g.lineTo(
						x + ((s / smax) * w),
						y + ((snap.startRatios[f] + snap.ratios[f]) * h)
				)
			}

			g.lineTo(
					x,
					y + (snap.startRatios[0] * h)
			);

			g.endFill();
		}
	}

	private static function print(transition:IDataTransition):void {
		var snap:IDataTransitionSnapshot;

		var f:int = -1;
		var fmax:int = 10;
		var s:int;
		var smax:int;
		while (++f <= fmax) {
			snap = transition.getSnapshot(f / fmax);
			trace("--------------------", snap.t);
			trace(snap.sum);

			s = -1;
			smax = snap.primaryValues.length;
			while (++s < smax) {
				trace(StringUtil.substitute('{0} => {1} ({2}%)'
						, snap.primaryValues[s]
						, snap.values[s]
						, int(snap.ratios[s] * 100)
				));
			}
		}
	}
}
}
