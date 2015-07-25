package ssen.components.grid.headers {

import ssen.common.StringUtils;

[ExcludeClass]
public class HeaderBrancheDrawCommand {
	public var block:int;
	public var start:int;
	public var end:int;
	public var begin:Boolean;

	public function toString():String {
		return StringUtils.formatToString("[HeaderBrancheDrawCommand block={0} start={1} end={2} begin={3}]", block, start, end, begin);
	}
}
}
