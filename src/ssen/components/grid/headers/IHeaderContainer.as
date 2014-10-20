package ssen.components.grid.headers {

import spark.components.Group;

public interface IHeaderContainer extends IHeader {
	function getContainerId(columnIndex:int):int;

	function getContainer(containerId:int):Group;

	function invalidateColumns():void;

	function invalidateColumnLayout():void;

	function invalidateColumnContent():void;

	function invalidateScroll():void;
}
}
