package ssen.components.base {
import ssen.common.IDisposable;

public interface IRenderProvider {
	//----------------------------------------------------------------
	// handler
	//----------------------------------------------------------------
	/**
	 * register render hanlder
	 * @param handler = (renderTime:Number, enabledInteraction:boolean):void
	 * @return
	 */
	function addRenderHandler(handler:Function):IDisposable;

	function currentTime():Number;

	function start():void;

	function stop():void;

	function clear():void;
}
}
