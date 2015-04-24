package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.display.DisplayObject;
import flash.events.Event;

import mx.charts.ColumnChart;
import mx.charts.LinearAxis;
import mx.collections.IList;
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.IVisualElement;
import mx.core.ScrollPolicy;
import mx.events.AdvancedDataGridEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ScrollEvent;

import spark.components.SkinnableContainer;

import ssen.ssen_internal;

use namespace ssen_internal;

[SkinState("error")]

public class GridAndChartWeaver extends SkinnableContainer {

	private var grid:AdvancedDataGrid;
	private var chart:ColumnChart;

	[Bindable]
	ssen_internal var error:Error;

	[Bindable]
	ssen_internal var disableMessage:String="LOADING";

	private var clear:Boolean;

	//==========================================================================================
	// properties
	//==========================================================================================
	/** chart rendering을 빠르게 진행한다 (속도 문제가 있으면 false로 돌린다) */
	public var renderDirect:Boolean=true;

	//==========================================================================================
	// 내부 Chart와 Grid 수집
	//==========================================================================================
	public function GridAndChartWeaver() {
		setStyle("skinClass", GridAndChartWeaverSkin);
		addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, mxmlContentCreationComplete, false, 0, true);
	}

	// 설정된 mxml content를 수집한다.
	// 즉... 현재 시점에서 내부의 component 들은 중도 변경이 안되고 있다.
	// 초기에 mxml 상에서 설정된 상태 그대로 사용되어지고 있다.
	private function mxmlContentCreationComplete(event:FlexEvent):void {
		removeEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, mxmlContentCreationComplete);

		if (numElements != 2) {
			error=new Error("AdvancedDataGrid 하나와 ColumnChart 하나가 필요합니다.");
			invalidateState();
			return;
		}

		var f:int=-1;
		var fmax:int=numElements;
		var element:IVisualElement;

		while (++f < fmax) {
			element=getElementAt(f);

			if (element is AdvancedDataGrid) {
				//----------------------------------------------------------------
				// Grid 초기화
				//----------------------------------------------------------------
				grid=element as AdvancedDataGrid;
				grid.horizontalScrollPolicy=ScrollPolicy.AUTO;
				grid.verticalScrollPolicy=ScrollPolicy.AUTO;
				grid.draggableColumns=false;

				// 데이터의 변화
				grid.addEventListener(FlexEvent.DATA_CHANGE, gridDataChange, false, 0, true);
				// Column 수량 변화
				grid.addEventListener("columnsChanged", gridColumnsChanged, false, 0, true);
				// Column의 사이즈 변화
				grid.addEventListener(AdvancedDataGridEvent.COLUMN_STRETCH, gridColumnStretch, false, 0, true);
				// Scroll 위치 변화 
				grid.addEventListener(ScrollEvent.SCROLL, gridScroll, false, 0, true);

				// 총체적 변화
				grid.addEventListener(FlexEvent.UPDATE_COMPLETE, gridUpdateComplete, false, 0, true);

				// Cell 선택됨
				grid.addEventListener(ListEvent.CHANGE, gridSelectionChanged, false, 0, true);

					//				trace("GridAndChartWeaver.mxmlContentCreationComplete(grid initlaized)");
			} else if (element is ColumnChart) {
				//---------------------------------------------
				// Chart 초기화
				//---------------------------------------------
				chart=element as ColumnChart;
				chart.setStyle("paddingLeft", 0);
				chart.setStyle("paddingRight", 0);
				chart.setStyle("paddingTop", 0);
				chart.setStyle("paddingBottom", 0);
				chart.setStyle("gutterTop", 0);
				chart.setStyle("gutterBottom", 0);
				chart.setStyle("gutterRight", 0);

				// Bindable 감지
				chart.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, chartPropertyChanged, false, 0, true);

				// Series 정보의 변화
				chart.addEventListener("legendDataChanged", legendDataChanged, false, 0, true);

					// chart.addEventListener(FlexEvent.UPDATE_COMPLETE, chartUpdateComplete, false, 0, true);
					//				trace("GridAndChartWeaver.mxmlContentCreationComplete(chart initlaized)");
			} else {
				error=new Error("AdvancedDataGrid 또는 ColumnChart만 집어넣을 수 있습니다");
				invalidateState();
				return;
			}
		}

		invalidateState();
		// invalidateProperties();
	}

	private function gridSelectionChanged(event:ListEvent):void {
		//		trace("GridAndChartWeaver.gridSelectionChanged(", event.columnIndex, event.rowIndex, ")");
		invalidateHighlight();
	}

	private function chartPropertyChanged(event:PropertyChangeEvent):void {
		if (event.property === "dataProvider") {
			if (event.oldValue is IList) {
				invalidateHighlight();
			}
		}
	}

	private function legendDataChanged(event:Event):void {
		invalidateState();
		invalidateHighlight();
	}

	private function gridColumnsChanged(event:Event):void {
		invalidateState();
		invalidateLayout();
		invalidateHighlight();
	}

	private function gridScroll(event:ScrollEvent):void {
		invalidateLayout();
	}

	// 모든 Action은 Grid에서 일어나고,
	private function gridDataChange(event:FlexEvent):void {
		invalidateState();
		invalidateHighlight();
	}

	private function gridColumnStretch(event:AdvancedDataGridEvent):void {
		invalidateLayout();
	}

	private function gridUpdateComplete(event:FlexEvent):void {
		invalidateLayout();
	}

	//	// Chart는 Grid의 Action에 반응하기만 한다
	//	private function chartUpdateComplete(event:FlexEvent):void {
	//		trace("GridAndChartWeaver.chartUpdateComplete(", event, ")");
	//		//		checkState();
	//	}

	//==========================================================================================
	// 
	//==========================================================================================
	private var stateDirty:Boolean;
	private var layoutDirty:Boolean;
	private var highlightDirty:Boolean;

	private var selectedRowIndex:int;

	private var selectedColumnIndex:int;

	private var selectedColumnDataField:String;

	protected function invalidateState():void {
		stateDirty=true;
		invalidateSkinState();
		invalidateProperties();
	}

	protected function invalidateHighlight():void {
		highlightDirty=true;
		invalidateProperties();
	}

	protected function invalidateLayout():void {
		layoutDirty=true;
		invalidateProperties();
	}

	override protected function commitProperties():void {
		// skin state 처리가 super.commitProperties() 에서 이루어지기 때문에
		// 상위 호출 이전에 처리해야 한다.
		//		trace("GridAndChartWeaver.commitProperties(grid locked column count is ", grid.lockedColumnCount, ")");

		if (stateDirty) {
			if (error) {
				clear=false;
			} else if (!chart.dataProvider || chart.dataProvider.length === 0) {
				disableMessage="NO DATA";
				clear=false;
			} else if (!hasGridColumns(grid) || !chart.series || chart.series.length === 0) {
				disableMessage="LOADING";
				clear=false;
			} else if (grid.lockedColumnCount === 0) {
				disableMessage="LOADING";
				clear=false;
			} else if (!(chart.horizontalAxis is LinearAxis)) {
				error=new Error("ColumnChart.horizontalAxis는 LinearAxis 이어야 합니다.");
				clear=false;
			} else {
				clear=true;
			}

			if (clear) {
				layoutDirty=true;
			}

			stateDirty=false;
		}

		if (layoutDirty) {
			invalidateDisplayList();
			layoutDirty=false;
		}

		if (highlightDirty) {
			processHighlight();
			highlightDirty=false;
		}

		super.commitProperties();
	}

	private function processHighlight():void {
		var f:int;

		var selectedCells:Array=grid.selectedCells;

		selectedRowIndex=-1;
		selectedColumnIndex=-1;
		selectedColumnDataField=null;

		if (selectedCells && selectedCells.length > 0) {
			var cell:Object=grid.selectedCells[0];
			selectedRowIndex=cell["rowIndex"];
			selectedColumnIndex=cell["columnIndex"];


			if (selectedColumnIndex < grid.lockedColumnCount) {
				selectedRowIndex=-1;
				selectedColumnIndex=-1;
			}
		}

		if (selectedColumnIndex > -1) {
			var columns:Array=DataGridUtils.getGridColumns(grid);
			var column:AdvancedDataGridColumn=columns[selectedColumnIndex];
			selectedColumnDataField=column.dataField;
		}

		//		trace("GridAndChartWeaver.processHighlight(", grid.lockedColumnCount, selectedRowIndex, selectedColumnIndex - grid.lockedColumnCount, selectedColumnDataField, ")");

		var selectedChartDataIndex:int=selectedColumnIndex - grid.lockedColumnCount;
		var chartData:IList=chart.dataProvider as IList;
		var gridData:IList=grid.dataProvider as IList;
		var chartVO:IGridAndChartWeaverChartValueObject;
		var gridVO:IGridAndChartWeaverGridValueObject;

		if (chartData) {
			f=chartData.length;

			while (--f >= 0) {
				chartVO=chartData.getItemAt(f) as IGridAndChartWeaverChartValueObject;

				if (chartVO) {
					chartVO.highlighted=f === selectedChartDataIndex;
				}
			}
		}

		if (gridData) {
			f=gridData.length;

			while (--f >= 0) {
				gridVO=gridData.getItemAt(f) as IGridAndChartWeaverGridValueObject;

				if (gridVO) {
					gridVO.highlightedField=selectedColumnDataField;
				}
			}
		}
	}

	private function hasGridColumns(grid:AdvancedDataGrid):Boolean {
		if (!grid) {
			return false;
		}

		var hasNotColumns:Boolean=!grid.columns || grid.columns.length === 0;
		var hasNotGroupedColumns:Boolean=!grid.groupedColumns || grid.groupedColumns.length === 0;

		return !hasNotColumns || !hasNotGroupedColumns;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!clear) {
			return;
		}

		var gridInfo:GridInfo=getGridInfo();
		var haxis:LinearAxis=chart.horizontalAxis as LinearAxis;

		//----------------------------------------------------------------
		// chart 에 locked columns 적용
		//----------------------------------------------------------------
		chart.setStyle("gutterLeft", gridInfo.lockedColumnsInfo.columnsWidthTotal);

		//----------------------------------------------------------------
		// chart 에 unlocked columns 적용
		//----------------------------------------------------------------
		// horizontal axis의 절대 공간 = 0 ~ 1
		haxis.minimum=gridInfo.visibleColumnStartRatio;
		haxis.maximum=gridInfo.visibleColumnEndRatio;
		//		trace("GridAndChartWeaver.updateDisplayList(", gridInfo.visibleColumnStartRatio, gridInfo.visibleColumnEndRatio, ")");
		//		trace("GridAndChartWeaver.updateDisplayList(", haxis.minimum, haxis.maximum, ")");
		setChartHorizontalPosition(chart.dataProvider as IList, gridInfo.unlockedColumnsInfo.columnsRatioList);

		drawChartHighlight(gridInfo);

		if (renderDirect) {
			chart.validateNow();
		}
	}

	private function drawChartHighlight(gridInfo:GridInfo):void {
		var bgelement:DisplayObject;
		var highlightElement:GridAndChartWeaverChartHighlightElement;
		var f:int=chart.backgroundElements.length;
		var index:int;

		while (--f >= 0) {
			bgelement=chart.backgroundElements[f];

			if (bgelement is GridAndChartWeaverChartHighlightElement) {
				highlightElement=bgelement as GridAndChartWeaverChartHighlightElement;

				if (selectedColumnIndex > -1) {
					index=selectedColumnIndex - grid.lockedColumnCount;
					highlightElement.highlighted=true;
					highlightElement.highlightStartX=sumNumbers(gridInfo.unlockedColumnsInfo.columnsWidthList.slice(grid.horizontalScrollPosition, index));
					highlightElement.highlightEndX=sumNumbers(gridInfo.unlockedColumnsInfo.columnsWidthList.slice(grid.horizontalScrollPosition, index + 1));
				} else {
					highlightElement.highlighted=false;
				}
			}
		}
	}

	private function setChartHorizontalPosition(vos:IList, ratios:Vector.<Number>):void {
		var vo:IGridAndChartWeaverChartValueObject;
		var nx:Number=0;
		var nr:Number;

		var f:int=-1;
		var fmax:int=vos.length;

		while (++f < fmax) {
			nr=ratios[f];

			vo=vos.getItemAt(f) as IGridAndChartWeaverChartValueObject;
			vo.horizontalPosition=nx + (nr / 2);

			//			trace("GridAndChartWeaver.setChartHorizontalPosition(", f, nx, ")");

			nx+=nr;
		}
	}

	private function getGridInfo():GridInfo {
		var f:int;
		var fmax:int;

		// Columns
		var columns:Array=DataGridUtils.getGridColumns(grid);
		var lockedColumnCount:int=grid.lockedColumnCount;
		var lockedColumns:Array=columns.slice(0, lockedColumnCount);
		var unlockedColumns:Array=columns.slice(lockedColumnCount);

		// 잠겨있는 Column의 정보 
		var lockedColumnsInfo:ColumnsWidthInfo=collectColumnsWidthInfo(lockedColumns);

		// 잠겨있지 않은 column의 정보
		var unlockedColumnsInfo:ColumnsWidthInfo=collectColumnsWidthInfo(unlockedColumns);

		// Grid 전체의 정보
		var borderWeight:int=grid.getStyle("borderVisible") ? 1 : 0;

		// Scroll 정보를 바탕으로 현재 눈에 보이는 Column들의 정보
		var visibleWidth:Number=grid.width - lockedColumnsInfo.columnsWidthTotal - (borderWeight * 2);
		var visibleColumnStartRatio:Number=sumNumbers(unlockedColumnsInfo.columnsRatioList.slice(0, grid.horizontalScrollPosition));
		var visibleColumnEndRatio:Number=(visibleWidth / unlockedColumnsInfo.columnsWidthTotal) + visibleColumnStartRatio;


		//		trace("GridAndChartWeaver.getGridInfo(", grid.horizontalScrollPosition, visibleColumnStartRatio, visibleColumnEndRatio, ")");

		//		trace("GridAndChartWeaver.getGridInfo() locked");
		//		trace(lockedColumnsInfo);
		//		trace("GridAndChartWeaver.getGridInfo() unlocked");
		//		trace(unlockedColumnsInfo);
		//		trace("GridAndChartWeaver.getGridInfo(", visibleColumnStartRatio, ")");



		var gridInfo:GridInfo=new GridInfo;
		gridInfo.lockedColumnsInfo=lockedColumnsInfo;
		gridInfo.unlockedColumnsInfo=unlockedColumnsInfo;
		gridInfo.visibleColumnStartRatio=visibleColumnStartRatio;
		gridInfo.visibleColumnEndRatio=visibleColumnEndRatio;


		//		var column:AdvancedDataGridColumn;
		//		var columnWidthTotal:Number=grid.width - lockedColumnsWidth - (gridBorderWeight * 2);
		//		var width:Vector.<Number>=new Vector.<Number>(columns.length, true);
		//
		//		var f:int=-1;
		//		var fmax:int=columns.length;
		//		while (++f < fmax) {
		//			column=columns[f];
		//			width[f]=column.width;
		//			trace("TestGridAndChart.getGridColumnWidthList(", column.dataField, column.width, ")");
		//		}

		return gridInfo;
	}

	private function sumNumbers(numbers:Vector.<Number>):Number {
		if (numbers.length === 0) {
			return 0;
		}

		var sum:Number=0;
		var f:int=numbers.length;
		while (--f >= 0) {
			sum+=numbers[f];
		}
		return sum;
	}

	private function collectColumnsWidthInfo(columns:Array):ColumnsWidthInfo {
		var column:AdvancedDataGridColumn;
		var columnsWidthList:Vector.<Number>=new Vector.<Number>(columns.length, true);
		var columnsRatioList:Vector.<Number>=new Vector.<Number>(columns.length, true);
		var columnsWidthTotal:Number=0;
		var columnWidth:Number;

		var f:int=-1;
		var fmax:int=columns.length;
		while (++f < fmax) {
			column=columns[f];
			columnWidth=column.width;

			columnsWidthList[f]=columnWidth;
			columnsWidthTotal+=columnWidth;
		}

		f=-1;
		fmax=columns.length;
		while (++f < fmax) {
			columnsRatioList[f]=columnsWidthList[f] / columnsWidthTotal;
		}

		var columnWidthInfo:ColumnsWidthInfo=new ColumnsWidthInfo;
		columnWidthInfo.columnsWidthList=columnsWidthList;
		columnWidthInfo.columnsWidthTotal=columnsWidthTotal;
		columnWidthInfo.columnsRatioList=columnsRatioList;

		return columnWidthInfo;
	}

	//==========================================================================================
	// skin
	//==========================================================================================
	override protected function getCurrentSkinState():String {
		var state:String=(error) ? "error" : !clear ? "disabled" : "normal";
		//		trace("!!!!GridAndChartWeaver.getCurrentSkinState(", state, ")");
		return state;
	}


}
}

import ssen.common.StringUtils;

class ColumnsWidthInfo {
	public var columnsWidthList:Vector.<Number>;
	public var columnsRatioList:Vector.<Number>;
	public var columnsWidthTotal:Number;

	public function toString():String {
		return StringUtils.formatToString("[ColumnWidthInfo]\ncolumnWidthList={0}\ncolumnRatioList={1}\ncolumnWidthTotal={2}\n[/ColumnWidthInfo]", columnsWidthList,
										  columnsRatioList, columnsWidthTotal);
	}
}

class GridInfo {
	public var lockedColumnsInfo:ColumnsWidthInfo;
	public var unlockedColumnsInfo:ColumnsWidthInfo;
	public var visibleColumnStartRatio:Number;
	public var visibleColumnEndRatio:Number;
}
