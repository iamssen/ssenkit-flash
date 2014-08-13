package ssen.flexkit.components.renderers {
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.MouseEvent;

import mx.events.PropertyChangeEvent;

import spark.components.IItemRenderer;
import spark.components.RichText;

[Style(name="backgroundHoverColor", inherit="no", type="uint")]
[Style(name="backgroundHoverAlpha", inherit="no", type="Number")]
[Style(name="lineColor", inherit="no", type="uint")]

public class RichTextItemRenderer extends RichText implements IItemRenderer {

	//---------------------------------------------
	// data
	//---------------------------------------------
	private var _data:Object;

	/** data */
	[Bindable]
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		var oldValue:Object=_data;
		_data=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "data", oldValue, _data));
		}
	}

	//---------------------------------------------
	// dragging
	//---------------------------------------------
	private var _dragging:Boolean;

	/** dragging */
	public function get dragging():Boolean {
		return _dragging;
	}

	public function set dragging(value:Boolean):void {
		_dragging=value;
	}

	//---------------------------------------------
	// itemIndex
	//---------------------------------------------
	private var _itemIndex:int;

	/** itemIndex */
	[Bindable]
	public function get itemIndex():int {
		return _itemIndex;
	}

	public function set itemIndex(value:int):void {
		var oldValue:int=_itemIndex;
		_itemIndex=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "itemIndex", oldValue, _itemIndex));
		}
	}

	//---------------------------------------------
	// label
	//---------------------------------------------
	private var _label:String;

	/** label */
	[Bindable]
	public function get label():String {
		return _label;
	}

	public function set label(value:String):void {
		var oldValue:String=_label;
		_label=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "label", oldValue, _label));
		}
	}

	//---------------------------------------------
	// selected
	//---------------------------------------------
	private var _selected:Boolean;

	/** selected */
	[Bindable]
	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(value:Boolean):void {
		var oldValue:Boolean=_selected;
		_selected=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, _selected));
		}
	}

	//---------------------------------------------
	// showsCaret
	//---------------------------------------------
	private var _showsCaret:Boolean;

	/** showsCaret */
	[Bindable]
	public function get showsCaret():Boolean {
		return _showsCaret;
	}

	public function set showsCaret(value:Boolean):void {
		var oldValue:Boolean=_showsCaret;
		_showsCaret=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showsCaret", oldValue, _showsCaret));
		}
	}

	public function RichTextItemRenderer() {
		super();

		addEventListener(MouseEvent.ROLL_OVER, rolloverHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OUT, rolloutHandler, false, 0, true);
	}

	private var hovered:Boolean;

	private function rolloutHandler(event:MouseEvent):void {
		hovered=false;
		invalidateDisplayList();
	}

	private function rolloverHandler(event:MouseEvent):void {
		hovered=true;
		invalidateDisplayList();
	}

	//==========================================================================================
	// update display list
	//==========================================================================================
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var key:String=hovered ? "backgroundHover" : "background";

		var backgroundColor:uint=getStyle(key + "Color") || 0xffffff;
		var backgroundAlpha:Number=getStyle(key + "Alpha") || 1;
		var lineColor:uint=getStyle("lineColor") || 0x444444;

		var g:Graphics=getBackgroundShape().graphics;

		g.clear();

		g.beginFill(backgroundColor, backgroundAlpha);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();

		g.beginFill(lineColor);
		g.drawRect(0, unscaledHeight - 1, unscaledWidth, 1);
		g.endFill();
	}

	private var backgroundShape:Shape;

	protected function getBackgroundShape():Shape {
		if (!backgroundShape) {
			var f:int=numChildren;
			var display:DisplayObject;

			while (--f >= 0) {
				display=getChildAt(f);

				if (display is Shape) {
					backgroundShape=display as Shape;
				}
			}
		}

		return backgroundShape;
	}

}
}
