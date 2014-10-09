package ssen.components.sparkDatagridSupportClasses._showcase_.models {
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

import ssen.common.MathUtils;

public class FooterDataGridRow extends EventDispatcher {
	//---------------------------------------------
	// check
	//---------------------------------------------
	/** check */
	public var check:Boolean;

	public function setcheck(value:Boolean):void {
		var oldValue:Boolean=check;
		check=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "check", oldValue, check));
		}
	}

	[Bindable]
	public var company:String;

	[Bindable]
	public var mobile:int;

	[Bindable]
	public var tablet:int;

	[Bindable]
	public var labtop:int;

	[Bindable]
	public var desktop:int;

	private static var companyList:Vector.<String>=new <String>["Apple", "Samsung", "LG", "HTC", "Nokia"];

	public function FooterDataGridRow() {
		check=MathUtils.rand(0, 1) > 0;
		company=companyList[MathUtils.rand(0, companyList.length - 1)];
		mobile=MathUtils.rand(10000, 10000000);
		tablet=MathUtils.rand(10000, 10000000);
		labtop=MathUtils.rand(10000, 10000000);
		desktop=MathUtils.rand(10000, 10000000);
	}
}
}
