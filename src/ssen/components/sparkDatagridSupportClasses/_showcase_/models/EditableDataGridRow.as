package ssen.components.sparkDatagridSupportClasses._showcase_.models {
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.events.PropertyChangeEvent;

import ssen.common.MathUtils;

public class EditableDataGridRow extends EventDispatcher {
	//---------------------------------------------
	// check
	//---------------------------------------------
	/** check */
	public var check:Boolean;

	public function setCheck(value:Boolean):void {
		var oldValue:Boolean=check;
		check=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "check", oldValue, check));
		}
	}

	/** company */
	[Bindable]
	public var company:String;

	private static var _companyList:IList=new ArrayCollection(["Apple", "Samsung", "LG", "HTC", "Nokia"]);
	private static var productList:Vector.<String>=new <String>["iPhone 5", "Galaxy S4", "Optimus G Pro", "HTC One", "Lumia 920"];

	public function get companyList():IList {
		return _companyList;
	}

	/** product */
	[Bindable]
	public var product:String;

	/** stock */
	[Bindable]
	public var stock:int;

	public var stockMinimum:int;
	public var stockMaximum:int;

	/** price */
	[Bindable]
	public var price:Number;

	public var priceMinimum:int;
	public var priceMaximum:int;

	public function EditableDataGridRow() {
		check=MathUtils.rand(0, 1) > 0;
		var index:int=MathUtils.rand(0, companyList.length - 1);
		company=companyList.getItemAt(index) as String;
		product=productList[index];
		stock=MathUtils.rand(0, 100);
		stockMinimum=0;
		stockMaximum=MathUtils.rand(100, 300);
		price=MathUtils.rand(80000, 1000000);
		priceMinimum=0;
		priceMaximum=3000000;
	}
}
}
