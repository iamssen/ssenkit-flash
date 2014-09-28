package ssen.common {
/** 비동기 작업 유닛 인터페이스 */
public interface IAsyncUnit extends IDisposable {

	/** 응답을 받을 result callback */
	function get result():Function;

	function set result(value:Function):void;

	/** 응답을 받을 fault callback */
	function get fault():Function;

	function set fault(value:Function):void;

	/** 작업을 취소함 */
	function close():void;
}
}
