package ssen.components.mxDatagridSupportClasses.datagrid {
import flash.display.Graphics;

import mx.skins.ProgrammaticSkin;

/** Header Sort Renderer 에서 사용하는 화살표 이미지 */
public class ADGSortArrow extends ProgrammaticSkin {
	//--------------------------------------------------------------------------
	//  Overridden properties
	//--------------------------------------------------------------------------
	override public function get measuredWidth():Number {
		return 8;
	}

	override public function get measuredHeight():Number {
		return 5;
	}

	//--------------------------------------------------------------------------
	//  Overridden methods
	//--------------------------------------------------------------------------
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		var g:Graphics=graphics;

		g.clear();
		g.beginFill(name == "sortArrowDisabled" ? getStyle("disabledIconColor") : getStyle("iconColor"), 0.8);
		g.moveTo(0, 0);
		g.lineTo(w, 0);
		g.lineTo(w / 2, h);
		g.lineTo(0, 0);
		g.endFill();
	}
}
}
