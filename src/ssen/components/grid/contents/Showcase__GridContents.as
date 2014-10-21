package ssen.components.grid.contents {

import flash.display.Graphics;

import mx.core.UIComponent;

import ssen.components.grid.headers.IHeader;

public class Showcase__GridContents extends UIComponent implements IGridContent {
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:IHeader;

	/** header */
	public function get header():IHeader {
		return _header;
	}

	public function set header(value:IHeader):void {
		_header = value;
		invalidateDisplayList();
	}

	public function invalidateColumnContent():void {
		invalidate_render();
	}

	public function invalidateScroll():void {
	}

	//---------------------------------------------
	// inavalidate render
	//---------------------------------------------
	private var renderChanged:Boolean;

	final protected function invalidate_render():void {
		renderChanged = true;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// commit render
	//---------------------------------------------
	protected function commit_render():void {
		if (header) {
			var widthList:Vector.<Number> = header.computedColumnWidthList;
			var positionList:Vector.<Number> = header.computedColumnPositionList;
			var g:Graphics = graphics;

			g.clear();
			g.beginFill(0, 0.2);

//			var f:int = -1;
//			var fmax:int = widthList.length;
//			while (++f < fmax) {
//				g.drawRect(positionList[f], 0, widthList[f], unscaledHeight);
//			}

			g.endFill();
		}
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (renderChanged) {
			commit_render();
			renderChanged = false;
		}
	}
}
}
