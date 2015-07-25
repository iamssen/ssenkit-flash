package ssen.components.sparkDatagridSupportClasses._showcase_.models {
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.IList;

import ssen.common.MathUtils;

public class FooterGraphDataGridRow extends EventDispatcher {
	[Bindable]
	public var product:String;

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

	public var color:uint;

	public static function createDatas():IList {
		var arr:Array=[];
		arr.push(row("Apple iPhone 4s", 0x7AC0A8));
		arr.push(row("Apple iPhone 5", 0xF2E0B1));
		arr.push(row("Samsung Galaxy S3", 0xF09B2D));
		arr.push(row("Samsung Galaxy Note2", 0xF07315));
		arr.push(row("LG Optimus G Pro", 0x5B402F));

		return new ArrayCollection(arr);
	}

	private static function row(product:String, color:uint):FooterGraphDataGridRow {
		var row:FooterGraphDataGridRow=new FooterGraphDataGridRow;
		row.product=product;
		row.q1=MathUtils.rand(1, 10000);
		row.q2=MathUtils.rand(1, 10000);
		row.q3=MathUtils.rand(1, 10000);
		row.q4=MathUtils.rand(1, 10000);
		row.q5=MathUtils.rand(1, 10000);
		row.q6=MathUtils.rand(1, 10000);
		row.q7=MathUtils.rand(1, 10000);
		row.q8=MathUtils.rand(1, 10000);
		row.color=color;
		return row;
	}
}
}
