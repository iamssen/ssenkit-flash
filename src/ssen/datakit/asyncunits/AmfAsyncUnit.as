package ssen.datakit.asyncunits {
import mx.messaging.ChannelSet;
import mx.messaging.channels.AMFChannel;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;


public class AmfAsyncUnit implements IAsyncUnit {
	public var channelId:String;
	public var channelUrl:String;
	public var destination:String;
	private var _fault:Function;
	private var _result:Function;

	public function getRemoteObject():RemoteObject {
		var amfChannel:AMFChannel=new AMFChannel(channelId, channelUrl);
		var channelSet:ChannelSet=new ChannelSet;
		channelSet.addChannel(amfChannel);

		var ro:RemoteObject=new RemoteObject;
		ro.channelSet=channelSet;
		ro.destination=destination;
		ro.addEventListener("result", resultHandler);
		ro.addEventListener("fault", faultHandler);

		return ro;
	}

	public function close():void {
		dispose();
	}

	public function get fault():Function {
		return _fault;
	}

	public function set fault(value:Function):void {
		_fault=value;
	}

	public function get result():Function {
		return _result;
	}

	public function set result(value:Function):void {
		_result=value;
	}

	public function dispose():void {
		_result=null;
		_fault=null;
	}

	private function resultHandler(event:ResultEvent):void {
		if (_result !== null) {
			_result(event.result);
		}
		dispose();
	}

	private function faultHandler(event:FaultEvent):void {
		if (_fault !== null) {
			_fault(event);
		}
		dispose();
	}
}
}
