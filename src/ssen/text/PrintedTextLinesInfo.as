package ssen.text {
import mx.utils.StringUtil;

import ssen.common.IDisposable;

public class PrintedTextLinesInfo {
	public var width:Number;
	public var height:Number;
	public var disposer:IDisposable;

	public function toString():String {
		return StringUtil.substitute('[PrintedTextLinesInfo width={0} height={1}]', width, height);
	}
}
}
