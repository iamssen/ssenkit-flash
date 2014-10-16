package ssen.components.grid.headers {
import spark.components.Group;

public interface IHeaderContainer extends IHeader {
	//==========================================================================================
	// 외부로 줘야 하는 정보들
	//==========================================================================================
	function getContainer(columnIndex:int):Group;

	function invalidateColumns():void;
	function invalidateColumnLayout():void;
	function invalidateColumnContent():void;
	function invalidateScroll():void;
}
}
