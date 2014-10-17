package ssen.components.grid.headers {

public interface IHeaderRowLayout {
	function getSeparatorSize(index:int):int;

	function getHeight(rowCount:int):Number;

	function getRowY(index:int):Number;

	function getRowHeight(index:int):Number;
}
}
