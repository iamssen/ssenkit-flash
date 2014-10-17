package ssen.components.grid.headers {

import spark.components.Group;

public interface IHeaderContainer extends IHeader {
	function isDrawLockedContainer(columnIndex:int):Boolean;

	function getLockedContainer():Group;

	function getUnlockedContainer():Group;

	function invalidateColumns():void;

	function invalidateColumnLayout():void;

	function invalidateColumnContent():void;

	function invalidateScroll():void;
}
}
