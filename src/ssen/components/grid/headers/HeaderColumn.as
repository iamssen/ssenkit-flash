package ssen.components.grid.headers {

import flash.display.GraphicsPath;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.IFactory;
import mx.events.PropertyChangeEvent;

import spark.components.Group;

import ssen.common.StringUtils;
import ssen.components.grid.GridUtils;
import ssen.drawing.PathMaker;

public class HeaderColumn extends EventDispatcher implements IHeaderLeafColumn {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// header
	//---------------------------------------------
	private var _header:IHeaderElement;

	/** header */
	public function get header():IHeaderElement {
		return _header;
	}

	public function set header(value:IHeaderElement):void {
		_header = value;
	}

	//---------------------------------------------
	// headerContent
	//---------------------------------------------
	private var _headerContent:Object;

	/** headerContent */
	public function get headerContent():Object {
		return _headerContent;
	}

	public function set headerContent(value:Object):void {
		_headerContent = value;
		if (_header) _header.invalidateColumnContent();
	}

	//---------------------------------------------
	// renderer
	//---------------------------------------------
	private var _renderer:IFactory;

	/** renderer */
	public function get renderer():IFactory {
		return _renderer || HeaderColumnRenderer.factory;
	}

	public function set renderer(value:IFactory):void {
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
	private var _columnWidth:Number = 100;

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
	private static var bound:Rectangle = new Rectangle;

	public function render():void {
		var header:IHeaderElement = this.header;

		var containerId:int;
		var container:Group;

		var path:GraphicsPath;
		var contentSpaces:Dictionary;
		var renderer:IHeaderColumnRenderer;

		//---------------------------------------------
		// calculate
		//---------------------------------------------
		containerId = GridUtils.getContainerId(header, columnIndex); // column lock 등을 고려한 container id를 가져온다
		container = header.getBlock(containerId); // 그릴 container를 가져온다

		var surplusRows:int = (header.numRows - rowIndex); // 그릴 (잔여) row
		bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, columnIndex, containerId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
		bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
		bound.width = header.computedColumnWidthList[columnIndex];
		bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

		//		trace(StringUtils.multiply("+", rowIndex + 1), rowIndex, columnIndex, "HeaderColumn.render()", toString(), container.name, bound);

		//---------------------------------------------
		// export
		//---------------------------------------------
		path = PathMaker.rect(0, 0, bound.width, bound.height);
		contentSpaces = new Dictionary;
		contentSpaces["default"] = new Rectangle(0, 0, bound.width, bound.height);

		renderer = this.renderer.newInstance();
		renderer.column = this;
		renderer.bound = bound.clone();
		renderer.path = path;
		renderer.contentSpaces = contentSpaces;
		renderer.isMainContainer = true;
		//		renderer.draw(this, container, bound.clone(), path, contentSpaces, true);
		renderer.x = bound.x;
		renderer.y = bound.y;
		container.addElement(renderer);
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumn headerContent={0} columnIndex={1} rowIndex={2} computedColumnWidth={3}]", headerContent, columnIndex, rowIndex, computedColumnWidth);
	}
}
}
