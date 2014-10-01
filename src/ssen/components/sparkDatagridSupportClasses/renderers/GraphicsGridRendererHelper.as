package ssen.components.sparkDatagridSupportClasses.renderers {

public class GraphicsGridRendererHelper {
	private var keepWidth:int = -1;
	private var keepHeight:int = -1;

	public var dataChanged:Boolean;
	public var columnChanged:Boolean;
	public var sizeChanged:Boolean;

	public var draw:Function;
	public var clear:Function;

	public function setSize(width:Number, height:Number):void {
		if (width <= 0 || height <= 0) {
			return;
		}

		if (keepWidth !== width || keepHeight !== height) {
			keepWidth = width;
			keepHeight = height;
			sizeChanged = true;

			prepare(true);
		}
	}

	public function prepare(hasBeenRecycled:Boolean):void {
		draw(hasBeenRecycled, dataChanged, columnChanged, sizeChanged);
		dataChanged = false;
		columnChanged = false;
		sizeChanged = false;
	}

	public function discard(willBeRecycled:Boolean):void {
		clear(willBeRecycled);
	}
}
}

import mx.core.FlexGlobals;

import spark.components.Application;

function callLater(func:Function, ...args):void {
	var app:Application = FlexGlobals.topLevelApplication as Application;
	app.callLater(func, args);
}
