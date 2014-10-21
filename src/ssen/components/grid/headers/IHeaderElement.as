package ssen.components.grid.headers {

import spark.components.Group;

public interface IHeaderElement extends IHeader {
	function getBlock(block:int):Group;

	function invalidateColumns():void;

	function invalidateColumnLayout():void;

	function invalidateColumnContent():void;

	function invalidateScroll():void;
}
}
