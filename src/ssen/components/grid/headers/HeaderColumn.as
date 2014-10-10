package ssen.components.grid.headers {

import flash.events.EventDispatcher;

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
	private var _computedColumnWidth:Number;

	/** computedColumnWidth */
	[Bindable(event="propertyChange")]
	public function get computedColumnWidth():Number {
		if (sizeChanged) {
			commit_size();
			sizeChanged=false;
		}

		return _computedColumnWidth;
	}

	private function set_computedColumnWidth(value:Number):void {
		var oldValue:Number = _computedColumnWidth;
		_computedColumnWidth = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedColumnWidth", oldValue, _computedColumnWidth));
		}
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

	//---------------------------------------------
	// inavalidate size
	//---------------------------------------------
	private var sizeChanged:Boolean;

	final protected function invalidate_size():void {
		sizeChanged=true;
	}

	//---------------------------------------------
	// commit size
	//---------------------------------------------
	protected function commit_size():void {
		set_computedColumnWidth(_header.computedColumnWidthList[_columnIndex]);
	}

	public function render():void {
		trace(HeaderUtils.getSpace(rowIndex), rowIndex, columnIndex, "HeaderColumn.render()", toString());
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumn headerText={0} columnIndex={1} rowIndex={2}]", headerText, columnIndex, rowIndex);
	}
}
}
