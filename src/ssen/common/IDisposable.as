package ssen.common {

/** 내부 리소스가 제거될 필요가 있는 instance 를 공통화 시키는 interface */
public interface IDisposable {
	/** 내부 리소스를 제거한다 */
	function dispose():void;
}
}
