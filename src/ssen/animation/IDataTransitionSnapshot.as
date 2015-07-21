package ssen.animation {
public interface IDataTransitionSnapshot {
	/** snapshot time (0 ~ 1) */
	function get t():Number;

	/** sum */
	function get sum():Number;

	function get primaryValues():Vector.<String>;

	function get ratios():Vector.<Number>;

	function get values():Vector.<Number>;

	function get startRatios():Vector.<Number>;
}
}
