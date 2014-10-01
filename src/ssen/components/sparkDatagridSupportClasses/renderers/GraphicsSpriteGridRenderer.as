package ssen.components.sparkDatagridSupportClasses.renderers {

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.Grid;
import spark.components.gridClasses.GridColumn;
import spark.components.gridClasses.IGridItemRenderer;

public class GraphicsSpriteGridRenderer extends UIComponent implements IGridItemRenderer {
	private var helper:GraphicsGridRendererHelper;

	public function GraphicsSpriteGridRenderer() {
		helper = new GraphicsGridRendererHelper;
		helper.draw = draw;
		helper.clear = clear;
	}

	/** @inheritDoc */
	public function discard(willBeRecycled:Boolean):void {
		helper.discard(willBeRecycled);
	}

	/** @inheritDoc */
	public function prepare(hasBeenRecycled:Boolean):void {
		helper.prepare(hasBeenRecycled);
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		helper.setSize(unscaledWidth, unscaledHeight);
	}

	protected function clear(willBeRecycled:Boolean):void {

	}

	protected function draw(hasBeenRecycled:Boolean, dataChanged:Boolean, columnChanged:Boolean, sizeChanged:Boolean):void {

	}

	//==========================================================================================
	// utils
	//==========================================================================================
	private function dispatchChangeEvent(type:String):void {
		if (hasEventListener(type))
			dispatchEvent(new Event(type));
	}

	//==========================================================================================
	// implements IItemRenderer
	//==========================================================================================
	//----------------------------------
	//  data
	//----------------------------------

	private var _data:Object = null;

	[Bindable("dataChange")]  // compatible with FlexEvent.DATA_CHANGE

	/**
	 * The value of the data provider item for the grid row
	 * corresponding to the item renderer.
	 * This value corresponds to the object returned by a call to the
	 * <code>dataProvider.getItemAt(rowIndex)</code> method.
	 *
	 * <p>Item renderers can override this property definition to access
	 * the data for the entire row of the grid. </p>
	 *
	 * @default null
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get data():Object {
		return _data;
	}

	/**
	 * @private
	 */
	public function set data(value:Object):void {
		if (_data == value)
			return;

		_data = value;
		helper.dataChanged = true;

		const eventType:String = "dataChange";
		if (hasEventListener(eventType))
			dispatchEvent(new FlexEvent(eventType));
	}

	//==========================================================================================
	// implements IGridItemRenderer
	//==========================================================================================
	//----------------------------------
	//  column
	//----------------------------------

	private var _column:GridColumn = null;

	[Bindable("columnChanged")]

	/**
	 * @inheritDoc
	 *
	 * <p>The Grid's <code>updateDisplayList()</code> method sets this property
	 * before calling <code>preprare()</code></p>.
	 *
	 * @default null
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get column():GridColumn {
		return _column;
	}

	/**
	 * @private
	 */
	public function set column(value:GridColumn):void {
		if (_column == value)
			return;

		_column = value;
		helper.columnChanged = true;

		dispatchChangeEvent("columnChanged");
	}

	//----------------------------------
	//  columnIndex
	//----------------------------------

	/**
	 * @inheritDoc
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get columnIndex():int {
		return (column) ? column.columnIndex : -1;
	}


	//----------------------------------
	//  down
	//----------------------------------

	/**
	 * @private
	 * storage for the down property
	 */
	private var _down:Boolean = false;

	/**
	 * @inheritDoc
	 *
	 * @default false
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get down():Boolean {
		return _down;
	}

	/**
	 * @private
	 */
	public function set down(value:Boolean):void {
		if (value == _down)
			return;

		_down = value;
	}

	//----------------------------------
	//  dragging
	//----------------------------------

	private var _dragging:Boolean = false;

	[Bindable("draggingChanged")]

	/**
	 * @inheritDoc
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get dragging():Boolean {
		return _dragging;
	}

	/**
	 * @private
	 */
	public function set dragging(value:Boolean):void {
		if (_dragging == value)
			return;

		_dragging = value;
		dispatchChangeEvent("draggingChanged");
	}

	//----------------------------------
	//  grid
	//----------------------------------

	/**
	 * Returns the Grid associated with this item renderer.
	 * This is the same value as <code>column.grid</code>.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get grid():Grid {
		return (column) ? column.grid : null;
	}


	//----------------------------------
	//  hovered
	//----------------------------------

	private var _hovered:Boolean = false;

	/**
	 * @inheritDoc
	 *
	 * @default false
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get hovered():Boolean {
		return _hovered;
	}

	/**
	 * @private
	 */
	public function set hovered(value:Boolean):void {
		if (value == _hovered)
			return;

		_hovered = value;
	}

	//----------------------------------
	//  label
	//----------------------------------
	/** @private */
	public function get label():String {
		return null;
	}

	/** @private */
	public function set label(value:String):void {
	}

	//----------------------------------
	//  rowIndex
	//----------------------------------
	private var _rowIndex:int = -1;

	[Bindable("rowIndexChanged")]

	/**
	 * @inheritDoc
	 *
	 * <p>The Grid's <code>updateDisplayList()</code> method sets this property
	 * before calling <code>prepare()</code></p>.
	 *
	 * @default -1
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get rowIndex():int {
		return _rowIndex;
	}

	/**
	 * @private
	 */
	public function set rowIndex(value:int):void {
		if (_rowIndex == value)
			return;

		_rowIndex = value;
		dispatchChangeEvent("rowIndexChanged");
	}

	//----------------------------------
	//  selected
	//----------------------------------

	private var _selected:Boolean = false;

	[Bindable("selectedChanged")]

	/**
	 * @inheritDoc
	 *
	 * <p>The Grid's <code>updateDisplayList()</code> method sets this property
	 * before calling <code>preprare()</code></p>.
	 *
	 * @default false
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 2.5
	 * @productversion Flex 4.5
	 */
	public function get selected():Boolean {
		return _selected;
	}

	/**
	 * @private
	 */
	public function set selected(value:Boolean):void {
		if (_selected == value)
			return;

		_selected = value;
		dispatchChangeEvent("selectedChanged");
	}

	//----------------------------------
	//  showsCaret
	//----------------------------------
	/** @private */
	public function get showsCaret():Boolean {
		return false;
	}

	/** @private */
	public function set showsCaret(value:Boolean):void {
	}
}
}
