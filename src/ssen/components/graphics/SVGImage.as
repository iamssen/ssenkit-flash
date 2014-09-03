package ssen.components.graphics {
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;

import mx.core.UIComponent;

public class SVGImage extends UIComponent {

	private var primitive:DisplayObject;
	private var color:Shape;

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	private var _paddingLeft:int;

	/** paddingLeft */
	public function get paddingLeft():int {
		return _paddingLeft;
	}

	public function set paddingLeft(value:int):void {
		_paddingLeft=value;
		invalidateSize();
	}

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	private var _paddingRight:int;

	/** paddingRight */
	public function get paddingRight():int {
		return _paddingRight;
	}

	public function set paddingRight(value:int):void {
		_paddingRight=value;
		invalidateSize();
	}

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	private var _paddingTop:int;

	/** paddingTop */
	public function get paddingTop():int {
		return _paddingTop;
	}

	public function set paddingTop(value:int):void {
		_paddingTop=value;
		invalidateSize();
	}

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	private var _paddingBottom:int;

	/** paddingBottom */
	public function get paddingBottom():int {
		return _paddingBottom;
	}

	public function set paddingBottom(value:int):void {
		_paddingBottom=value;
		invalidateSize();
	}

	//---------------------------------------------
	// colorOverlay
	//---------------------------------------------
	private var _colorOverlay:int=-1;

	/** colorOverlay */
	public function get colorOverlay():int {
		return _colorOverlay;
	}

	public function set colorOverlay(value:int):void {
		_colorOverlay=value;
		invalidateProperties();
	}

	//---------------------------------------------
	// source
	//---------------------------------------------
	private var _source:*;

	/** source */
	public function get source():* {
		return _source;
	}

	public function set source(value:*):void {
		_source=value;

		if (primitive) {
			removeChild(primitive);
			primitive=null;
		}

		if (_source is Class) {
			primitive=new _source();
			addChild(primitive);
		}

		invalidateSize();
	}

	//---------------------------------------------
	// primitiveScale
	//---------------------------------------------
	private var _primitiveScale:Number=1;

	/** primitiveScale */
	public function get primitiveScale():Number {
		return _primitiveScale;
	}

	public function set primitiveScale(value:Number):void {
		_primitiveScale=value;
		invalidateSize();
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (color && _colorOverlay < 0) {
			if (color.mask === primitive) {
				color.mask=null;
			}
			removeChild(color);
			color=null;
		} else if (!color && _colorOverlay >= 0) {
			color=new Shape;
			addChild(color);
			color.mask=primitive;
		}

		invalidateDisplayList();
	}

	override protected function measure():void {
		if (primitive) {
			primitive.scaleX=1;
			primitive.scaleY=1;
			measuredWidth=(primitive.width * _primitiveScale) + _paddingLeft + _paddingRight;
			measuredHeight=(primitive.height * _primitiveScale) + _paddingTop + _paddingBottom;
			primitive.scaleX=_primitiveScale;
			primitive.scaleY=_primitiveScale;
			invalidateDisplayList();
		}
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();

		if (!primitive) {
			return;
		}

		primitive.x=_paddingLeft;
		primitive.y=_paddingTop;

		if (color) {
			var g:Graphics=color.graphics;
			g.clear();
			g.beginFill(_colorOverlay);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
		}
	}
}
}
