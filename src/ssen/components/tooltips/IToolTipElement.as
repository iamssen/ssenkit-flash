package ssen.components.tooltips {
import mx.core.IFlexDisplayObject;

import ssen.common.IDisposable;

public interface IToolTipElement extends IFlexDisplayObject, IDisposable {
	function render(host:IToolTipHostElement):void;
}
}
