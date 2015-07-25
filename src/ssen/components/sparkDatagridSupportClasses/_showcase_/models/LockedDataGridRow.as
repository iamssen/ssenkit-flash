package ssen.components.sparkDatagridSupportClasses._showcase_.models {
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.IList;

import ssen.common.MathUtils;
import ssen.datakit.ds.RandomDataCollection;

public class LockedDataGridRow extends EventDispatcher {
	[Bindable]
	public var product:String;
	[Bindable]
	public var total:int;

	[Bindable]
	public var q1:int;
	[Bindable]
	public var q2:int;
	[Bindable]
	public var q3:int;
	[Bindable]
	public var q4:int;
	[Bindable]
	public var q5:int;
	[Bindable]
	public var q6:int;
	[Bindable]
	public var q7:int;
	[Bindable]
	public var q8:int;
	[Bindable]
	public var q9:int;
	[Bindable]
	public var q10:int;
	[Bindable]
	public var q11:int;
	[Bindable]
	public var q12:int;
	[Bindable]
	public var q13:int;
	[Bindable]
	public var q14:int;
	[Bindable]
	public var q15:int;
	[Bindable]
	public var q16:int;
	[Bindable]
	public var q17:int;
	[Bindable]
	public var q18:int;
	[Bindable]
	public var q19:int;
	[Bindable]
	public var q20:int;

	public static function createData():IList {
		var arr:Array=[];
		arr.push(row("Apple iPhone 4s"));
		arr.push(row("Apple iPhone 5"));

		var products:RandomDataCollection=new RandomDataCollection(["Samsung Galaxy S", "LG Optimus G", "Google Nexus"]);
		var f:int=2;
		var fmax:int=MathUtils.rand(40, 100);
		while (++f < fmax) {
			arr.push(row(products.get() + f));
		}

		return new ArrayCollection(arr);
	}

	private static function row(product:String):LockedDataGridRow {
		var row:LockedDataGridRow=new LockedDataGridRow;
		row.product=product;
		row.total=0;

		var f:int=0;
		var fmax:int=21;
		var total:int=0;
		var value:int;
		while (++f < fmax) {
			value=MathUtils.rand(100, 1600);
			row["q" + f]=value;
			row.total+=value;
		}

		return row;
	}
}
}
