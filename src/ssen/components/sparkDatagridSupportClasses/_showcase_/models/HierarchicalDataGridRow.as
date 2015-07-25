package ssen.components.sparkDatagridSupportClasses._showcase_.models {
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.IList;

import ssen.common.MathUtils;
import ssen.common.StringUtils;

public dynamic class HierarchicalDataGridRow extends EventDispatcher {
	[Bindable]
	public var company:String;

	[Bindable]
	public var category:String;

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

	override public function toString():String {
		return StringUtils.formatToString('[TreeDataGridRow company="{0}" category="{1}" product="{2}" q1="{3}" q2="{4}" q3="{5}" q4="{6}"]', company, category, product, q1, q2,
										  q3, q4);
	}

	public static function createTestData():IList {
		var arr:Array=[];
		arr.push(row("Apple", "Mobile", "iPhone 3gs"));
		arr.push(row("Apple", "Mobile", "iPhone 4"));
		arr.push(row("Apple", "Mobile", "iPhone 4s"));
		arr.push(row("Apple", "Mobile", "iPhone 5"));
		arr.push(row("Apple", "Tablet", "iPad 2"));
		arr.push(row("Apple", "Tablet", "iPad 3"));
		arr.push(row("Apple", "Tablet", "iPad Mini"));
		arr.push(row("Apple", "Labtop", "Macbook Air 11"));
		arr.push(row("Apple", "Labtop", "Macbook Air 13"));
		arr.push(row("Apple", "Labtop", "Macbook Pro 13"));
		arr.push(row("Apple", "Labtop", "Macbook Pro 15"));
		arr.push(row("Apple", "Desktop", "Mac Mini"));
		arr.push(row("Apple", "Desktop", "iMac"));
		arr.push(row("Apple", "Desktop", "Mac Pro"));
		arr.push(row("Samsung", "Mobile", "Galaxy S2"));
		arr.push(row("Samsung", "Mobile", "Galaxy Note2"));
		arr.push(row("Samsung", "Mobile", "Galaxy S3"));
		arr.push(row("Samsung", "Mobile", "Galaxy Note3"));
		arr.push(row("Samsung", "Mobile", "Galaxy S4"));
		arr.push(row("Samsung", "Tablet", "Galaxy Tab1"));
		arr.push(row("Samsung", "Tablet", "Galaxy Tab2"));
		arr.push(row("Samsung", "Tablet", "Galaxy Note 10.1"));
		arr.push(row("Samsung", "Labtop", "Ative Book1"));
		arr.push(row("Samsung", "Labtop", "Ative Book2"));
		arr.push(row("Samsung", "Labtop", "Ative Smart PC Pro"));
		arr.push(row("Samsung", "Desktop", "Magic Station Series3"));
		arr.push(row("Samsung", "Desktop", "Magic Station Series5"));
		arr.push(row("Samsung", "Desktop", "Magic Station Ative One7"));
		arr.push(row("Google", "Mobile", "Nexus 2"));
		arr.push(row("Google", "Mobile", "Nuxus 3"));
		arr.push(row("Google", "Mobile", "Nexus 4"));
		arr.push(row("Google", "Tablet", "Nexus10"));
		arr.push(row("Google", "Tablet", "Nexus10"));
		arr.push(row("Google", "Tablet", "Nexus10 2"));
		arr.push(row("Google", "Tablet", "Nexus7"));
		arr.push(row("Google", "Tablet", "Nexus7 2"));
		return new ArrayCollection(arr);
	}

	private static function row(company:String, category:String, product:String):HierarchicalDataGridRow {
		var row:HierarchicalDataGridRow=new HierarchicalDataGridRow;
		row.company=company;
		row.category=category;
		row.product=product;
		row.q1=MathUtils.rand(100, 1000);
		row.q2=MathUtils.rand(100, 1000);
		row.q3=MathUtils.rand(100, 1000);
		row.q4=MathUtils.rand(100, 1000);
		return row;
	}
}
}
