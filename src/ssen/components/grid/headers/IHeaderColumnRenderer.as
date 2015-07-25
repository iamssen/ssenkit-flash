package ssen.components.grid.headers {
import flash.display.GraphicsPath;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.IVisualElement;

import spark.components.Group;

public interface IHeaderColumnRenderer extends IVisualElement {
	//---------------------------------------------
	// column
	//---------------------------------------------
	/** column */
	function get column() : IHeaderColumn;
	function set column(value : IHeaderColumn):void;

	//---------------------------------------------
	// bound
	//---------------------------------------------
	/** bound */
	function get bound() : Rectangle;
	function set bound(value : Rectangle):void;

	//---------------------------------------------
	// path
	//---------------------------------------------
	/** path */
	function get path() : GraphicsPath;
	function set path(value : GraphicsPath):void;

	//---------------------------------------------
	// contentSpaces
	//---------------------------------------------
	/** contentSpaces */
	function get contentSpaces() : Dictionary;
	function set contentSpaces(value : Dictionary):void;

	//---------------------------------------------
	// isMainContainer
	//---------------------------------------------
	/** isMainContainer */
	function get isMainContainer() : Boolean;
	function set isMainContainer(value : Boolean):void;

//	function draw(column:IHeaderColumn, container:Group, bound:Rectangle, path:GraphicsPath, contentSpaces:Dictionary, isMainContainer:Boolean):void;
}
}
