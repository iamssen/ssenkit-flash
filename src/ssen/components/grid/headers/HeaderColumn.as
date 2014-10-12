package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;

import ssen.common.StringUtils;

public class HeaderColumn extends EventDispatcher implements IHeaderLeafColumn {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:IHeaderContainer;

	/** header */
	public function get header():IHeaderContainer {
		return _header;
	}

	public function set header(value:IHeaderContainer):void {
		_header = value;
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
		_headerText = value;
	}

	//---------------------------------------------
	// renderer
	//---------------------------------------------
	private var _renderer:IHeaderColumnRenderer;

	/** renderer */
	public function get renderer():IHeaderColumnRenderer {
		return _renderer;
	}

	public function set renderer(value:IHeaderColumnRenderer):void {
		_renderer = value;

	}

	//---------------------------------------------
	// rowIndex
	//---------------------------------------------
	private var _rowIndex:int;

	/** rowIndex */
	[Bindable]
	public function get rowIndex():int {
		return _rowIndex;
	}

	public function set rowIndex(value:int):void {
		var oldValue:int = _rowIndex;
		_rowIndex = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rowIndex", oldValue, _rowIndex));
		}
	}

	//---------------------------------------------
	// columnIndex
	//---------------------------------------------
	private var _columnIndex:int;

	/** columnIndex */
	[Bindable]
	public function get columnIndex():int {
		return _columnIndex;
	}

	public function set columnIndex(value:int):void {
		var oldValue:int = _columnIndex;
		_columnIndex = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnIndex", oldValue, _columnIndex));
		}
	}

	//---------------------------------------------
	// columnWidth
	//---------------------------------------------
	private var _columnWidth:Number;

	/** columnWidth */
	[Bindable]
	public function get columnWidth():Number {
		return _columnWidth;
	}

	public function set columnWidth(value:Number):void {
		var oldValue:Number = _columnWidth;
		_columnWidth = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnWidth", oldValue, _columnWidth));
		}
	}


	//---------------------------------------------
	// computedColumnWidth
	//---------------------------------------------
	/** computedColumnWidth */
	public function get computedColumnWidth():Number {
		return _header.computedColumnWidthList[columnIndex];
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	//	public function draw(container:IHeaderContainer, rowIndex:int, columnIndex:int):int {
	//		var nextColumnIndex:int=columnIndex + 1;
	//
	//		var tl:Point=HeaderUtils.getPoint(container, rowIndex, columnIndex);
	//		var br:Point
	//		//=new Point(weaver.getProperty(), container.computedWidthList[columnIndex], container.measuredHeight - tl.y);
	//		var g:Graphics=container.graphics;
	//		g.beginFill(0, 0.1);
	//		g.drawRect(tl.x, tl.y, br.x, br.y);
	//		g.endFill();
	//
	//		return nextColumnIndex;
	//	}

	public function render():void {
		trace(HeaderUtils.getSpace(rowIndex), rowIndex, columnIndex, "HeaderColumn.render()", toString());

//		var bound:Rectangle=HeaderUtils.getColumnBound(this);
		var bound:Rectangle=new Rectangle;
		var surplusRows:int = (header.numRows - rowIndex);
		bound.x = header.computedColumnPositionList[columnIndex];
		bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
		bound.width = header.computedColumnWidthList[columnIndex];
		bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

		var g:Graphics=header.graphics;
		g.beginFill(0, 0.1);
		g.drawRect(bound.x, bound.y, bound.width, bound.height);
		g.endFill();

//		var tl:Point = HeaderUtils.getPoint(header, rowIndex, columnIndex);
//		var br:Point=new Point(weaver.getProperty(), container.computedWidthList[columnIndex], container.measuredHeight - tl.y);
//		var g:Graphics = container.graphics;
//		g.beginFill(0, 0.1);
//		g.drawRect(tl.x, tl.y, br.x, br.y);
//		g.endFill();
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumn headerText={0} columnIndex={1} rowIndex={2} computedColumnWidth={3}]", headerText, columnIndex, rowIndex, computedColumnWidth);
	}
}
}
