package ssen.datakit.asyncunits {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLStream;

import ssen.common.IAsyncUnit;

/** URLStream 을 AyncUnit 으로 작동되도록 해주는 기능 */
public class URLStreamAsyncUnit implements IAsyncUnit {
	private var _stream:URLStream;
	private var _result:Function;
	private var _fault:Function;
	
	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function setStream(stream:URLStream):void {
		clearStream();
		
		_stream=stream;
		
		addEvents();
	}
	
	/** Stream 을 다른 형태의 VO 로 편집할 때 상속 구현한다 */
	protected function getResult(stream:URLStream):* {
		return stream;
	}
	
	/** Error 를 다른 형태의 VO 로 편집할 때 상속 구현한다 */
	protected function getError(event:ErrorEvent):* {
		return event;
	}
	
	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	private function addEvents():void {
		_stream.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		_stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
		_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
	}
	
	private function removeEvents():void {
		_stream.removeEventListener(Event.COMPLETE, completeHandler);
		_stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
	}
	
	private function clearStream():void {
		if (_stream) {
			try {
				removeEvents();
				_stream.close();
			} catch (error:Error) {
				trace("URLStreamServiceToken.clearStream()", error);
			} finally {
				_stream=null;
			}
		}
	}
	
	private function errorHandler(event:ErrorEvent):void {
		if (_fault !== null) {
			_fault(getError(event));
		}
		
		dispose();
	}
	
	private function completeHandler(event:Event):void {
		if (_result !== null) {
			_result(getResult(_stream));
		}
		
		dispose();
	}
	
	//----------------------------------------------------------------
	// implements IAsyncUnit
	//----------------------------------------------------------------
	/** @inheritDoc */
	public function get result():Function {
		return _result;
	}
	
	/** @inheritDoc */
	public function set result(value:Function):void {
		_result=result;
	}
	
	/** @inheritDoc */
	public function get fault():Function {
		return _fault;
	}
	
	/** @inheritDoc */
	public function set fault(value:Function):void {
		_fault=value;
	}
	
	/** @inheritDoc */
	public function close():void {
		dispose();
	}
	
	/** @inheritDoc */
	public function dispose():void {
		clearStream();
		_result=null;
		_fault=null;
	}
}
}
