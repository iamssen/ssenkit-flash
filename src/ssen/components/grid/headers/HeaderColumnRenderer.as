package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import spark.components.Group;

import ssen.common.IDisposable;

public class HeaderColumnRenderer extends UIComponent implements IHeaderColumnRenderer, IDisposable {

	internal static const factory:IFactory = new ClassFactory(HeaderColumnRenderer);

	public var fill:IFill = new SolidColor(0xaaaaaa);

	public function HeaderColumnRenderer() {
		mouseChildren = false;
		tabChildren = false;
	}

	public function draw(column:IHeaderColumn, container:Group, bound:Rectangle, path:GraphicsPath, contentSpaces:Dictionary, isMainContainer:Boolean):void {
		var g:Graphics = graphics;
		var line:int = getLineWeight(column);

		fill.begin(g, bound, new Point(bound.x, bound.y));
		graphics.drawPath(path.commands, path.data, path.winding);
		fill.end(g);

		if (column is HeaderSubTopicColumn) {
			trace("HeaderColumnRenderer.draw()", path.commands, path.data);
		}

		for each (var space:Rectangle in contentSpaces) {
			g.beginFill(0, 0.2);
			g.drawRect(space.x, space.y, space.width, space.height);
			g.drawRect(space.x + line, space.y + line, space.width - (line * 2), space.height - (line * 2));
			g.endFill();
		}
	}

	private static function getLineWeight(column:IHeaderColumn):int {
		if (column is HeaderGroupedColumn) {
			return 6;
		} else if (column is HeaderSubTopicColumn) {
			return 10;
		}

		return 4;
	}

	public function dispose():void {
	}
}
}
