package ssen.flexkit.components.dropdown {
import flash.geom.Point;

import spark.components.PopUpAnchor;

public class DropDownPopupAnchor extends PopUpAnchor {
	override protected function calculatePopUpPosition():Point {
		var p:Point=super.calculatePopUpPosition();
		var gp:Point=parent.localToGlobal(new Point(x, y));

		if (gp.x > p.x) {
			p.x=gp.x + width - popUp.width;
		}

		return p;
	}
}
}
