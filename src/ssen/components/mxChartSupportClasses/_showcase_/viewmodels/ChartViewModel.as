package ssen.components.mxChartSupportClasses._showcase_.viewmodels {
import flash.events.EventDispatcher;

import mx.collections.ArrayList;
import mx.collections.IList;

import ssen.common.MathUtils;

public class ChartViewModel extends EventDispatcher {

	//----------------------------------------------------------------
	// list
	//----------------------------------------------------------------
	[Bindable]
	public var leftChartDatas:IList;

	//----------------------------------------------------------------
	// line
	//----------------------------------------------------------------
	[Bindable]
	public var leftChartUseHorizontalLine:Boolean=true;

	[Bindable]
	public var leftChartHorizontalLineValue:Number;

	[Bindable]
	public var leftChartUseVerticalLine:Boolean=true;

	[Bindable]
	public var leftChartVerticalLineValue:Number;

	//----------------------------------------------------------------
	// sub line
	//----------------------------------------------------------------
	[Bindable]
	public var leftChartUseHorizontalSubLine:Boolean=true;

	[Bindable]
	public var leftChartHorizontalSubLineValue:Number;

	[Bindable]
	public var leftChartUseVerticalSubLine:Boolean=true;

	[Bindable]
	public var leftChartVerticalSubLineValue:Number;

	public function setSelectedLeftDatas(selectedDatas:Array):void {
		trace("ChartViewModel.setSelectedLeftDatas(", selectedDatas, ")");
	}


	//==========================================================================================
	// 
	//==========================================================================================
	public function ChartViewModel() {
		var arr:Array=[];

		var total:ChartVO=new ChartVO;
		var apple:ChartVO=new ChartVO;

		var vo:ChartVO;

		var f:int=-1;
		var fmax:int=MathUtils.rand(30, 100);
		while (++f < fmax) {
			vo=new ChartVO;
			vo.setRandom();

			total.price+=vo.price;
			total.sales+=vo.sales;
			total.stock++;

			if (vo.company.toLowerCase() == "apple") {
				apple.price+=vo.price;
				apple.sales+=vo.sales;
				apple.stock++;
			}

			arr.push(vo);
		}

		leftChartDatas=new ArrayList(arr);

		leftChartHorizontalLineValue=total.sales / total.stock;
		leftChartVerticalLineValue=total.price / total.stock;

		leftChartHorizontalSubLineValue=apple.sales / apple.stock;
		leftChartVerticalSubLineValue=apple.price / apple.stock;
	}
}
}
