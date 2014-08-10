package ssen.flexkit.components.grid {
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;

import ssen.common.StringUtils;

[Event(name="changedColumn", type="ssen.flexkit.components.grid.GridHeaderEvent")]

public class GridHeaderColumn extends EventDispatcher implements IGridHeaderColumnLeaf {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:GridHeader;

	/** header */
	public function get header():GridHeader {
		return _header;
	}

	public function set header(value:GridHeader):void {
		_header=value;
	}

	//---------------------------------------------
	// columnWidth
	//---------------------------------------------
	private var _columnWidth:Number;

	/** columnWidth */
	public function get columnWidth():Number {
		return _columnWidth;
	}

	public function set columnWidth(value:Number):void {
		_columnWidth=value;
		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.CHANGED_COLUMN));
	}

	//---------------------------------------------
	// headerText
	//---------------------------------------------
	private var _headerText:String;

	/** headerText */
	public function get headerText():String {
		return _headerText;
	}

	public function set headerText(value:String):void {
		_headerText=value;
		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.CHANGED_COLUMN));
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	public function draw(container:GridHeader, rowIndex:int, columnIndex:int):int {
		var nextColumnIndex:int=columnIndex + 1;

		var tl:Point=GridHeaderUtils.getPoint(container, rowIndex, columnIndex);
		var br:Point=new Point(container.computedWidthList[columnIndex], container.measuredHeight - tl.y);
		var g:Graphics=container.graphics;
		g.beginFill(0, 0.1);
		g.drawRect(tl.x, tl.y, br.x, br.y);
		g.endFill();

		return nextColumnIndex;
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumn headerText={0} columnWidth={1}]", _headerText, _columnWidth);
	}
}
}
