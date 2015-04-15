package ssen.components.grid.headers {
import flash.display.GraphicsPath;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.IVisualElement;

import spark.components.Group;

public interface IHeaderColumnRenderer extends IVisualElement {
	function draw(column:IHeaderColumn, container:Group, bound:Rectangle, path:GraphicsPath, contentSpaces:Dictionary, isMainContainer:Boolean):void;
}
}
