package ssen.flexkit.components.grid.renderers {
import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.gridClasses.GridColumn;
import spark.components.gridClasses.GridItemRenderer;

public class GraphicsGroupGridRenderer extends GridItemRenderer {
	private var helper:GraphicsGridRendererHelper;

	public function GraphicsGroupGridRenderer() {
		helper=new GraphicsGridRendererHelper;
		helper.draw=draw;
		helper.clear=clear;
	}

	/** @inheritDoc */
	override public function discard(willBeRecycled:Boolean):void {
		helper.discard(willBeRecycled);
	}

	/** @inheritDoc */
	override public function prepare(hasBeenRecycled:Boolean):void {
		helper.prepare(hasBeenRecycled);
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
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

	private var _data:Object=null;

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
	override public function get data():Object {
		return _data;
	}

	/**
	 * @private
	 */
	override public function set data(value:Object):void {
		if (_data == value)
			return;

		_data=value;

		helper.dataChanged=true;

		const eventType:String="dataChange";
		if (hasEventListener(eventType))
			dispatchEvent(new FlexEvent(eventType));
	}

	//==========================================================================================
	// implements IGridItemRenderer
	//==========================================================================================
	//----------------------------------
	//  column
	//----------------------------------

	private var _column:GridColumn=null;

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
	override public function get column():GridColumn {
		return _column;
	}

	/**
	 * @private
	 */
	override public function set column(value:GridColumn):void {
		if (_column == value)
			return;

		_column=value;

		helper.columnChanged=true;

		dispatchChangeEvent("columnChanged");
	}
}
}
