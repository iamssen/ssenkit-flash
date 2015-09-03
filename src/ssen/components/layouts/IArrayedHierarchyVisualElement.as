package ssen.components.layouts {
import mx.core.IVisualElement;

public interface IArrayedHierarchyVisualElement extends IVisualElement {
	//---------------------------------------------
	// treeDepth
	//---------------------------------------------
	/** treeDepth */
	function get treeDepth():int;

	function set treeDepth(value:int):void;
}
}
