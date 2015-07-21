package ssen.animation {
public interface IDataTransition {
	function get from():*;

	function set from(value:*):void;

	function get to():*;

	function set to(value:*):void;

	function get primaryProperty():String;

	function set primaryProperty(value:String):void;

	function get property():String;

	function set property(value:String):void;

	function getSnapshot(t:Number):IDataTransitionSnapshot;
}
}
