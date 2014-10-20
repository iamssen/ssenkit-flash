package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import mx.core.UIComponent;
import mx.events.PropertyChangeEvent;

import spark.components.Group;

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
		if (_header) _header.invalidateColumnContent();
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
		if (_header) _header.invalidateColumnContent();
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
		if (_header) _header.invalidateColumnLayout();
	}

	//---------------------------------------------
	// computedColumnWidth
	//---------------------------------------------
	/** computedColumnWidth */
	public function get computedColumnWidth():Number {
		return _header.computedColumnWidthList[columnIndex];
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render():void {
		var containerId:int = header.getContainerId(columnIndex);
		var container:Group = header.getContainer(containerId);
		var bound:Rectangle = new Rectangle;
		var surplusRows:int = (header.numRows - rowIndex);
		bound.x = HeaderUtils.columnDrawX(header.computedColumnPositionList, columnIndex, containerId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
		bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
		bound.width = header.computedColumnWidthList[columnIndex];
		bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

		trace(StringUtils.multiply("+", rowIndex + 1), rowIndex, columnIndex, "HeaderColumn.render()", toString(), container.name, bound);

		var g:Graphics = container.graphics;
		g.beginFill(0, 0.5);
		g.drawRect(bound.x, bound.y, bound.width, bound.height);
		g.endFill();
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumn headerText={0} columnIndex={1} rowIndex={2} computedColumnWidth={3}]", headerText, columnIndex, rowIndex, computedColumnWidth);
	}
}
}
