package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import ssen.components.grid.base.TextItemRenderer;

public class HeaderColumnRenderer extends TextItemRenderer implements IHeaderColumnRenderer {

	internal static const factory:IFactory = new ClassFactory(HeaderColumnRenderer);

	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// contentSpacesChoosingOrder
	//---------------------------------------------
	private var _contentSpacesChoosingOrder:Vector.<String> = new <String>["default"];

	/** contentSpacesChoosingOrder */
	public function get contentSpacesChoosingOrder():Vector.<String> {
		return _contentSpacesChoosingOrder;
	}

	public function set contentSpacesChoosingOrder(value:Vector.<String>):void {
		_contentSpacesChoosingOrder = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// fill
	//---------------------------------------------
	private var _fill:IFill = new SolidColor(0xaaaaaa);

	/** fill */
	public function get fill():IFill {
		return _fill;
	}

	public function set fill(value:IFill):void {
		_fill = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// column
	//---------------------------------------------
	private var _column:IHeaderColumn;

	/** column */
	public function get column():IHeaderColumn {
		return _column;
	}

	public function set column(value:IHeaderColumn):void {
		_column = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// bound
	//---------------------------------------------
	private var _bound:Rectangle;

	/** bound */
	public function get bound():Rectangle {
		return _bound;
	}

	public function set bound(value:Rectangle):void {
		_bound = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// path
	//---------------------------------------------
	private var _path:GraphicsPath;

	/** path */
	public function get path():GraphicsPath {
		return _path;
	}

	public function set path(value:GraphicsPath):void {
		_path = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// contentSpaces
	//---------------------------------------------
	private var _contentSpaces:Dictionary;

	/** contentSpaces */
	public function get contentSpaces():Dictionary {
		return _contentSpaces;
	}

	public function set contentSpaces(value:Dictionary):void {
		_contentSpaces = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// isMainContainer
	//---------------------------------------------
	private var _isMainContainer:Boolean;

	/** isMainContainer */
	public function get isMainContainer():Boolean {
		return _isMainContainer;
	}

	public function set isMainContainer(value:Boolean):void {
		_isMainContainer = value;
		invalidateDisplayList();
	}

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function HeaderColumnRenderer() {
		mouseChildren = false;
		tabChildren = false;
	}

	private static function getLineWeight(column:IHeaderColumn):int {
		if (column is HeaderGroupedColumn) {
			return 6;
		} else if (column is HeaderSubTopicColumn) {
			return 10;
		}

		return 4;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics = graphics;

		clear();

		//---------------------------------------------
		// draw background
		//---------------------------------------------
		fill.begin(g, bound, new Point(bound.x, bound.y));
		graphics.drawPath(path.commands, path.data, path.winding);
		fill.end(g);

		//---------------------------------------------
		// draw content
		//---------------------------------------------
		if (column) {
			renderContent(getContentSpace());
		}

		//---------------------------------------------
		// test
		//---------------------------------------------
//		var line:int = getLineWeight(column);
//
//		for each (var space:Rectangle in contentSpaces) {
//			g.beginFill(0, 0.2);
//			g.drawRect(space.x, space.y, space.width, space.height);
//			g.drawRect(space.x + line, space.y + line, space.width - (line * 2), space.height - (line * 2));
//			g.endFill();
//		}
	}

	override protected function getLabelText():String {
		return (formatter) ? formatter.format(column.headerContent) : column.headerContent.toString();
	}

	private function getContentSpace():Rectangle {
		var f:int = -1;
		var fmax:int = _contentSpacesChoosingOrder.length;
		while (++f < fmax) {
			if (_contentSpaces[_contentSpacesChoosingOrder[f]] is Rectangle) return _contentSpaces[_contentSpacesChoosingOrder[f]];
		}

		return _contentSpaces["default"];
	}
}
}
