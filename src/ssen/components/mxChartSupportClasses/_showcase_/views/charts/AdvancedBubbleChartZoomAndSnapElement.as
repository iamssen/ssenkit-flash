package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import mx.charts.LinearAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.BubbleSeries;
import mx.charts.series.items.BubbleSeriesItem;
import mx.collections.ListCollectionView;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

/** Advanced Bubble Chart의 Zoom, Move, Selection 기능들을 처리한다 */
public class AdvancedBubbleChartZoomAndSnapElement extends AdvancedBubbleChartElement {
	
	//----------------------------------------------------------------
	// 계산된 chart axis의 min, max values
	//----------------------------------------------------------------
	private var minimumHorizontalValue:Number;
	private var maximumHorizontalValue:Number;
	private var minimumVerticalValue:Number;
	private var maximumVerticalValue:Number;

	//==========================================================================================
	// config flag
	//==========================================================================================
	/** Zoom 활성화 여부 */
	public var zoomEnabled:Boolean;
	
	/** Move 활성화 여부 (selectionEnabled와 동시에 활성화 시키면 안됨) */
	public var scrollEnabled:Boolean;
	
	/** Selection 활성화 여부 (scrollEnabled와 동시에 활성화 시키면 안됨) */
	public var selectionEnabled:Boolean;
	
	/** Zoom 을 활성화 시킬 최소 Bubble 갯수 (최소 갯수 이하가 들어오면 Zoom이 작동하지 않게 됨) */
	public var zoomCount:int=2;

	/** 절대적 Y축 최소값 */
	public var absoluteVerticalMinimum:Number=NaN;
	
	/** 절대적 Y축 최대값 */
	public var absoluteVerticalMaximum:Number=NaN;
	
	/** 절대적 X축 최소값 */
	public var absoluteHorizontalMinimum:Number=NaN;
	
	/** 절대적 X축 최대값 */
	public var absoluteHorizontalMaximum:Number=NaN;

	//==========================================================================================
	// generated flag : 기능들이 현재 진행 중인지 여부를 판단할 때 사용 (충돌 방지 flag)
	//==========================================================================================
	private var snapUsed:Boolean;
	private var selectionUsed:Boolean;
	private var zoomUsed:Boolean;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function AdvancedBubbleChartZoomAndSnapElement() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	/** @private Selection에 사용할 Mouse Down Event (RIGHT_MOUSE_DOWN으로 대체 가능) */
	public var selectionMouseDownEvent:String=MouseEvent.MOUSE_DOWN;
	
	/** @private Selection에 사용할 Mouse Up Event (RIGHT_MOUSE_UP으로 대체 가능) */
	public var selectionMouseUpEvent:String=MouseEvent.MOUSE_UP;
	
	/** @private Selection에 사용할 Mouse Move Event */
	public var selectionMouseMoveEvent:String=MouseEvent.MOUSE_MOVE;
	
	/** @private Move에 사용할 Mouse Down Event (RIGHT_MOUSE_DOWN으로 대체 가능) */
	public var snapMouseDownEvent:String=MouseEvent.MOUSE_DOWN;
	
	/** @private Move에 사용할 Mouse Up Event (RIGHT_MOUSE_UP으로 대체 가능) */
	public var snapMouseUpEvent:String=MouseEvent.MOUSE_UP;
	
	/** @private Move에 사용할 Mouse Move Event */
	public var snapMouseMoveEvent:String=MouseEvent.MOUSE_MOVE;
	
	/** @private Selection, Move 등의 Mouse Event 들을 capture 레벨에서 작동시킬지 여부 */
	public var globalize:Boolean=false;

	//----------------------------------------------------------------
	// start events
	//----------------------------------------------------------------
	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

		addEventListener(MouseEvent.MOUSE_WHEEL, zoomWheelHandler, globalize, 0, true);
		addEventListener(snapMouseDownEvent, snapMouseDownHandler, globalize, 0, true);
		addEventListener(selectionMouseDownEvent, selectionMouseDownHandler, globalize, 0, true);
	}

	//----------------------------------------------------------------
	// wheel and zoom trigger
	//----------------------------------------------------------------
	/** Zoom 상태를 초기화 시킨다 */
	public function resetZoom():void {
		if (!zoomEnabled || snapMovingState || selectionMovingState || !zoomUsed) {
			return;
		}

		// Axis 가져옴
		var vaxis:LinearAxis=getVerticalAxis();
		var haxis:LinearAxis=getHorizontalAxis();

		haxis.minimum=minimumHorizontalValue;
		haxis.maximum=maximumHorizontalValue;
		vaxis.minimum=minimumVerticalValue;
		vaxis.maximum=maximumVerticalValue;

		invalidateDisplayList();

	}

	private function zoomWheelHandler(event:MouseEvent):void {
		// 줌 비활성이거나, 현재 움직임이 발생하고 있는 중이라면 취소한다
		if (!zoomEnabled || snapMovingState || selectionMovingState || !zoomUsed) {
			return;
		}

		zoom(event.localX, event.localY, event.delta);
	}

	private function zoom(localX:Number, localY:Number, delta:int):void {
		// Axis 가져옴
		var vaxis:LinearAxis=getVerticalAxis();
		var haxis:LinearAxis=getHorizontalAxis();

		// 현재 마우스 위치의 h / v 값을 찾아냄
		var hvalue:Number=((haxis.maximum - haxis.minimum) * (localX / unscaledWidth)) + haxis.minimum;
		var vvalue:Number=((vaxis.maximum - vaxis.minimum) * (localY / unscaledHeight)) + vaxis.minimum;

		// 현재 마우스 위치 전체 사이즈 비율 위치를 찾아냄 
		var hratio:Number=localX / unscaledWidth;
		var vratio:Number=localY / unscaledHeight;

		// wheel의 delta를 결정한 뒤에  
		// 현재 마우스를 위치를 중심축으로 확대 축소값을 계산 
		// (axis의 minimum, maximum을 계산)
		var hd:Number=delta * ((haxis.maximum - haxis.minimum) / 100);
		var vd:Number=delta * ((vaxis.maximum - vaxis.minimum) / 100);
		var vmin:Number=vaxis.minimum + (vd * (1 - vratio));
		var vmax:Number=vaxis.maximum - (vd * vratio);
		var hmin:Number=haxis.minimum + (hd * hratio);
		var hmax:Number=haxis.maximum - (hd * (1 - hratio));

		// 데이터에 허락된 최소 / 최대 값을 넘어가면 제한값으로 변경
		if (hmin < minimumHorizontalValue) {
			hmin=minimumHorizontalValue;
		}
		if (hmax > maximumHorizontalValue) {
			hmax=maximumHorizontalValue;
		}
		if (vmin < minimumVerticalValue) {
			vmin=minimumVerticalValue;
		}
		if (vmax > maximumVerticalValue) {
			vmax=maximumVerticalValue;
		}

		// 적용
		vaxis.minimum=vmin;
		vaxis.maximum=vmax;
		haxis.minimum=hmin;
		haxis.maximum=hmax;

		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// right moving trigger
	//----------------------------------------------------------------
	// 현재 움직이고 있는 상태인지 확인 (다른 행동들의 중첩 실행 방지 용도로 사용)
	private var snapMovingState:Boolean;
	// 시작 마우스 위치
	private var snapStartMouseX:int, snapStartMouseY:int;
	// 시작 최소 값
	private var snapStartMinimumHorizontalValue:Number, snapStartMinimumVerticalValue:Number;
	// 1pixel 당 얼마의 값을 가지는지 확인 
	private var snapHorizontalValuePerPixel:Number, snapVerticalValuePerPixel:Number;
	// 화면 최대값 - 최소값
	private var snapHorizontalDistanceMinimumByMaximum:Number, snapVerticalDistanceMinimumByMaximum:Number;

	private function snapMouseDownHandler(event:MouseEvent):void {
		if (!scrollEnabled || selectionMovingState || !selectionUsed) {
			return;
		}

		removeEventListener(snapMouseDownEvent, snapMouseDownHandler, globalize);

		var vaxis:LinearAxis=getVerticalAxis();
		var haxis:LinearAxis=getHorizontalAxis();

		snapStartMouseX=event.stageX;
		snapStartMouseY=event.stageY;

		snapStartMinimumHorizontalValue=haxis.minimum;
		snapStartMinimumVerticalValue=vaxis.minimum;

		snapHorizontalDistanceMinimumByMaximum=haxis.maximum - haxis.minimum;
		snapVerticalDistanceMinimumByMaximum=vaxis.maximum - vaxis.minimum;

		snapHorizontalValuePerPixel=snapHorizontalDistanceMinimumByMaximum / unscaledWidth;
		snapVerticalValuePerPixel=snapVerticalDistanceMinimumByMaximum / unscaledHeight;

		snapMovingState=true;

		invalidateDisplayList();

		stage.addEventListener(snapMouseMoveEvent, snapMouseMoveHandler, globalize, 0, true);
		stage.addEventListener(snapMouseUpEvent, snapMouseUpHandler, globalize, 0, true);
	}

	private function snapMouseMoveHandler(event:MouseEvent):void {
		var mx:int=snapStartMouseX - event.stageX;
		var my:int=snapStartMouseY - event.stageY;

		var tominh:Number=snapStartMinimumHorizontalValue + (snapHorizontalValuePerPixel * mx);
		var tominv:Number=snapStartMinimumVerticalValue - (snapVerticalValuePerPixel * my);
		var tomaxh:Number=tominh + snapHorizontalDistanceMinimumByMaximum;
		var tomaxv:Number=tominv + snapVerticalDistanceMinimumByMaximum;

		if (tominh < minimumHorizontalValue) {
			tominh=minimumHorizontalValue;
			tomaxh=tominh + snapHorizontalDistanceMinimumByMaximum;
		} else if (tomaxh > maximumHorizontalValue) {
			tomaxh=maximumHorizontalValue;
			tominh=tomaxh - snapHorizontalDistanceMinimumByMaximum;
		}

		if (tominv < minimumVerticalValue) {
			tominv=minimumVerticalValue;
			tomaxv=tominv + snapVerticalDistanceMinimumByMaximum;
		} else if (tomaxv > maximumVerticalValue) {
			tomaxv=maximumVerticalValue;
			tominv=tomaxv - snapVerticalDistanceMinimumByMaximum;
		}

		var vaxis:LinearAxis=getVerticalAxis();
		var haxis:LinearAxis=getHorizontalAxis();

		vaxis.minimum=tominv;
		vaxis.maximum=tomaxv;
		haxis.minimum=tominh;
		haxis.maximum=tomaxh;

		invalidateDisplayList();
	}

	private function snapMouseUpHandler(event:MouseEvent):void {
		snapMovingState=false;

		stage.removeEventListener(snapMouseMoveEvent, snapMouseMoveHandler, globalize);
		stage.removeEventListener(snapMouseUpEvent, snapMouseUpHandler, globalize);

		addEventListener(snapMouseDownEvent, snapMouseDownHandler, globalize, 0, true);

		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// selection trigger
	//----------------------------------------------------------------
	// 영역이 설정되어 있는지 확인
	private var zoneSelected:Boolean;
	// 현재 마우스의 이동이 있는지 확인 (다른 액션을 막는데 사용)
	private var selectionMovingState:Boolean;
	// 마우스 시작 위치의 실제 값 (시작점)
	private var selectionStartHorizontalValue:Number, selectionStartVerticalValue:Number;
	// 마우싀 시작 위치의 실제 값 (이동 이후의 끝점)
	private var selectionEndHorizontalValue:Number, selectionEndVerticalValue:Number;
	// 마우스 시작 위치 (너무 조금 이동하지 않았는지 체크하기 위한 값들)
	private var selectionStartX:int, selectionStartY:int;
	// 마우스 시작 지역 위치
	private var selectionStartLocalX:int, selectionStartLocalY:int;
	// 마우스 종료 지역 위치
	private var selectionEndLocalX:int, selectionEndLocalY:int;

	private function selectionMouseDownHandler(event:MouseEvent):void {
		if (!selectionEnabled || snapMovingState || !snapUsed) {
			return;
		}

		var haxis:LinearAxis=getHorizontalAxis();
		var vaxis:LinearAxis=getVerticalAxis();

		removeEventListener(selectionMouseDownEvent, selectionMouseDownHandler, globalize);

		var x:Number=event.localX;
		var y:Number=event.localY;

		selectionStartHorizontalValue=getHorizontalValue(x);
		selectionStartVerticalValue=getVerticalValue(y);
		selectionEndHorizontalValue=getHorizontalValue(x);
		selectionEndVerticalValue=getVerticalValue(y);

		selectionStartLocalX=event.localX;
		selectionStartLocalY=event.localY;
		selectionStartX=event.stageX;
		selectionStartY=event.stageY;

		selectionMovingState=true;

		stage.addEventListener(selectionMouseMoveEvent, selectionMouseMoveHandler, globalize, 0, true);
		stage.addEventListener(selectionMouseUpEvent, selectionMouseUpHandler, globalize, 0, true);

		zoneSelected=true;

		clearSelectedItems();

		invalidateDisplayList();
	}

	private function selectionMouseMoveHandler(event:MouseEvent):void {
		if (!event.buttonDown) {
			selectionMouseUpHandler(event);
		}

		var x:Number=getSelectionLocalX(event.stageX);
		var y:Number=getSelectionLocalY(event.stageY);

		selectionEndHorizontalValue=getHorizontalValue(x);
		selectionEndVerticalValue=getVerticalValue(y);

		zoneSelected=true;

		invalidateDisplayList();
	}

	private function getSelectionLocalX(x:Number):Number {
		x=selectionStartLocalX + (x - selectionStartX);

		if (x < 0) {
			return 0;
		} else if (x > unscaledWidth) {
			return unscaledWidth;
		}

		return x;
	}

	private function getSelectionLocalY(y:Number):Number {
		y=selectionStartLocalY + (y - selectionStartY);

		if (y < 0) {
			return 0;
		} else if (y > unscaledHeight) {
			return unscaledHeight;
		}

		return y;
	}

	private function selectionMouseUpHandler(event:MouseEvent):void {
		selectionMovingState=false;

		stage.removeEventListener(selectionMouseMoveEvent, selectionMouseMoveHandler, globalize);
		stage.removeEventListener(selectionMouseUpEvent, selectionMouseUpHandler, globalize);

		addEventListener(selectionMouseDownEvent, selectionMouseDownHandler, globalize, 0, true);



		var selectedItems:Array;

		// 마우스의 움직임이 적을때 작은 포인트의 최상위를 검색, 아니면 영역을 검색
		if (Math.abs(event.stageX - selectionStartX) < 10 || Math.abs(event.stageY - selectionStartY) < 10) {
			zoneSelected=false;
			invalidateDisplayList();

			selectionEndLocalX=getSelectionLocalX(event.stageX);
			selectionEndLocalY=getSelectionLocalY(event.stageY);

			selectedItems=processSelectedItemWithPoint();
		} else {
			selectionEndLocalX=getSelectionLocalX(event.stageX);
			selectionEndLocalY=getSelectionLocalY(event.stageY);

			selectedItems=processSelectedItemsWithZone();
		}

		// 선택 위치에 아무런 아이템들이 없다면 selection 취소
		if (selectedItems.length === 0) {
			zoneSelected=false;
			invalidateDisplayList();

			bubbleChart.setSelectedDatas(null);

			return;
		}

		zoneSelected=false;

		bubbleChart.setSelectedDatas(selectedItems);

		invalidateDisplayList();
	}

	private function clearSelectedItems():void {
		var seriesList:Array=chart.series;
		var data:IAdvancedBubbleData;
		var datas:ListCollectionView;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;
		var series:Series;
		var bubble:BubbleSeries;

		f=-1;
		fmax=seriesList.length;

		while (++f < fmax) {
			series=seriesList[s];

			if (series is BubbleSeries) {
				bubble=series as BubbleSeries;

				if (!bubble.dataProvider) {
					return;
				}

				datas=bubble.dataProvider as ListCollectionView;

				if (!datas || datas.length === 0) {
					continue;
				}

				s=-1;
				smax=datas.length;
				while (++s < smax) {
					data=datas.getItemAt(s) as IAdvancedBubbleData;

					if (!data) {
						continue;
					}

					data.selected=false;
				}
			}
		}
	}

	private function processSelectedItemWithPoint():Array {
		var selectedItems:Array=[];

		var seriesList:Array=chart.series;
		var items:Array;
		var item:BubbleSeriesItem;
		var data:IAdvancedBubbleData;

		var f:int;
		var s:int;
		var series:Series;
		var bubble:BubbleSeries;

		f=seriesList.length;
		while (--f >= 0) {
			series=seriesList[s];

			if (series is BubbleSeries) {
				bubble=series as BubbleSeries;

				if (!bubble.items || bubble.items.length === 0) {
					continue;
				}

				items=bubble.items;

				s=items.length;
				while (--s >= 0) {
					item=items[s];
					data=item.item as IAdvancedBubbleData;

					if (!data) {
						continue;
					}

					if (selectedItems.length === 0 && tp(selectionEndLocalX, selectionEndLocalY, item.x, item.y,
														 ((bubble.maxRadius - bubble.minRadius) * item.z) + bubble.minRadius)) {
						data.selected=true;
						selectedItems.push(data);
					} else {
						data.selected=false;
					}
				}
			}
		}

		return selectedItems;
	}

	private function processSelectedItemsWithZone():Array {
		var selectedItems:Array=[];

		var seriesList:Array=chart.series;
		var items:Array;
		var item:BubbleSeriesItem;
		var data:IAdvancedBubbleData;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;
		var series:Series;
		var bubble:BubbleSeries;

		f=-1;
		fmax=seriesList.length;
		while (++f < fmax) {
			series=seriesList[f];

			if (series is BubbleSeries) {
				bubble=series as BubbleSeries;

				if (!bubble.items || bubble.items.length === 0) {
					continue;
				}

				items=bubble.items;

				s=-1;
				smax=items.length;
				while (++s < smax) {
					item=items[s];
					data=item.item as IAdvancedBubbleData;

					if (!data) {
						continue;
					}

					if (tz(selectionStartLocalX, selectionStartLocalY, selectionEndLocalX, selectionEndLocalY, item.x, item.y,
						   ((bubble.maxRadius - bubble.minRadius) * item.z) + bubble.minRadius)) {
						data.selected=true;
						selectedItems.push(data);
					} else {
						data.selected=false;
					}
				}
			}
		}

		return selectedItems;
	}

	// target(tx, ty, tr:radius)이 특정 영역(start:sx,sy - end:ex,ey)내부에 속해 있는지 확인한다  
	private function tz(sx:Number, sy:Number, ex:Number, ey:Number, tx:Number, ty:Number, tr:Number):Boolean {
		var z:Number;

		if (sx > ex) {
			z=sx;
			sx=ex;
			ex=z;
		}

		if (sy > ey) {
			z=sy;
			sy=ey;
			ey=z;
		}

		// return center || top left || top right || bottom left || bottom right
		return ts(sx, sy, ex, ey, tx, ty) || ts(sx, sy, ex, ey, tx - tr, ty - tr) || ts(sx, sy, ex, ey, tx + tr, ty - tr) || ts(sx, sy, ex, ey, tx - tr, ty + tr) || ts(sx, sy, ex,
																																										ey, tx + tr,
																																										ty + tr);
	}

	// target point (tx, ty) 가 특정 영역에 속해 있는지 확인한다
	private function ts(sx:Number, sy:Number, ex:Number, ey:Number, tx:Number, ty:Number):Boolean {
		var out:Boolean=tx < sx || tx > ex || ty < sy || ty > ey;
		return !out;
	}

	// x, y 위치가 target(tx, ty, tr:radius)에 접촉하는지 확인 
	// 삼각계산으로 x,y 와 tx,ty의 거리를 구한 다음
	// 거리를 radius 와 비교한다 (마우스의 특징을 고려 접촉 판정 승인 거리에 여분을 준다) 
	private function tp(x:Number, y:Number, tx:Number, ty:Number, tr:Number):Boolean {
		var dist:Number=(tx - x) * (tx - x) + (ty - y) * (ty - y);
		return Math.sqrt(dist) < tr + 5;
	}



	//==========================================================================================
	// data process
	//==========================================================================================
	/** @inheritDoc */
	override protected function computeDataProvider():void {
		// 최대, 최소 값들
		var hmax:Number=Number.MIN_VALUE;
		var hmin:Number=Number.MAX_VALUE;
		var vmax:Number=Number.MIN_VALUE;
		var vmin:Number=Number.MAX_VALUE;

		var seriesList:Array=chart.series;
		var data:Object;
		var datas:ListCollectionView;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;
		var series:Series;
		var bubble:BubbleSeries;
		var hv:Number;
		var vv:Number;

		var count:int=0;

		f=-1;
		fmax=seriesList.length;

		while (++f < fmax) {
			series=seriesList[s];

			if (series is BubbleSeries) {
				bubble=series as BubbleSeries;

				if (!bubble.dataProvider) {
					_computeDataProvider=true;
					invalidateProperties();
					return;
				}

				datas=bubble.dataProvider as ListCollectionView;

				if (!datas || datas.length === 0) {
					continue;
				}

				s=-1;
				smax=datas.length;
				while (++s < smax) {
					data=datas.getItemAt(s);

					hv=data[bubble.xField];
					vv=data[bubble.yField];

					if (hv > hmax) {
						hmax=hv;
					}
					if (hv < hmin) {
						hmin=hv;
					}

					if (vv > vmax) {
						vmax=vv;
					}
					if (vv < vmin) {
						vmin=vv;
					}

					count++;
				}
			}
		}


		var hgap:Number=(count > 1) ? (hmax - hmin) / 20 : hmax;
		var vgap:Number=(count > 1) ? (vmax - vmin) / 20 : vmax;

		minimumHorizontalValue=hmin - hgap;
		maximumHorizontalValue=hmax + hgap;
		minimumVerticalValue=vmin - vgap;
		maximumVerticalValue=vmax + vgap;

		// 최소값이 0보다 크고, 최대-최소 보다 최소가 더 작은 경우면 최소값을 0으로 치환
		// 1090 --- 1100 과 같이 0과의 갭이 너무 큰 경우를 위해서 고려 
		if (minimumHorizontalValue > 0 && minimumHorizontalValue < (maximumHorizontalValue - minimumHorizontalValue)) {
			minimumHorizontalValue=0;
		}

		if (minimumVerticalValue > 0 && minimumVerticalValue < (maximumVerticalValue - minimumVerticalValue)) {
			minimumVerticalValue=0;
		}

		// absolute
		if (!isNaN(absoluteHorizontalMinimum) && minimumHorizontalValue < absoluteHorizontalMinimum) {
			minimumHorizontalValue=absoluteHorizontalMinimum;
		}

		if (!isNaN(absoluteHorizontalMaximum) && maximumHorizontalValue < absoluteHorizontalMaximum) {
			maximumHorizontalValue=absoluteHorizontalMaximum;
		}

		if (!isNaN(absoluteVerticalMinimum) && minimumVerticalValue < absoluteVerticalMinimum) {
			minimumVerticalValue=absoluteVerticalMinimum;
		}

		if (!isNaN(absoluteVerticalMaximum) && maximumVerticalValue < absoluteVerticalMaximum) {
			maximumVerticalValue=absoluteVerticalMaximum;
		}

		// axis
		var vaxis:LinearAxis=getVerticalAxis();
		var haxis:LinearAxis=getHorizontalAxis();

		if (vaxis) {
			vaxis.minimum=minimumVerticalValue;
			vaxis.maximum=maximumVerticalValue;
		}

		if (haxis) {
			haxis.minimum=minimumHorizontalValue;
			haxis.maximum=maximumHorizontalValue;
		}

		zoomUsed=count >= zoomCount;
		snapUsed=count > 0;
		selectionUsed=count > 0;

		zoneSelected=false;

		invalidateDisplayList();

		//		trace("AdvancedBubbleChartZoomAndSnapElement.computeDataProvider set h values(", _minimumHorizontalValue, _maximumHorizontalValue, ")");
		//		trace("AdvancedBubbleChartZoomAndSnapElement.computeDataProvider set v values(", _minimumVerticalValue, _maximumVerticalValue, ")");
		//		trace("AdvancedBubbleChartZoomAndSnapElement.computeDataProvider(", vaxis, haxis, ")");
	}

	//==========================================================================================
	// render
	//==========================================================================================
	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();
		clearTexts();

		if (zoomUsed) {
			var chartDataProvider:ListCollectionView=getChartDataProvider();
			if (!chartDataProvider) {
				return;
			}

			var vaxis:LinearAxis=getVerticalAxis();
			var haxis:LinearAxis=getHorizontalAxis();
			var vy:Number;
			var vh:Number;
			var hx:Number;
			var hw:Number;
			var vstart:Number;
			var vend:Number;
			var hstart:Number;
			var hend:Number;
			var hstartValue:Number;
			var hendValue:Number;
			var vstartValue:Number;
			var vendValue:Number;

			//		if (snapChanged) {
			//---------------------------------------------
			// draw scroll
			//--------------------------------------------- 
			vstart=(vaxis.minimum - minimumVerticalValue) / (maximumVerticalValue - minimumVerticalValue);
			vend=(vaxis.maximum - minimumVerticalValue) / (maximumVerticalValue - minimumVerticalValue);

			hstart=(haxis.minimum - minimumHorizontalValue) / (maximumHorizontalValue - minimumHorizontalValue);
			hend=(haxis.maximum - minimumHorizontalValue) / (maximumHorizontalValue - minimumHorizontalValue);

			const scrollSize:int=3;

			vy=(1 - vend) * (unscaledHeight - scrollSize);
			vh=(vend - vstart) * (unscaledHeight - scrollSize);
			hx=(hstart * (unscaledWidth - scrollSize) + scrollSize);
			hw=(hend - hstart) * (unscaledWidth - scrollSize);

			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRect(0, vy, scrollSize, vh);
			graphics.drawRect(hx, unscaledHeight - scrollSize, hw, scrollSize);
			graphics.endFill();
				//		}
		}

		//---------------------------------------------
		// draw selection
		//---------------------------------------------
		if (zoneSelected) {
			var rect:Rectangle=new Rectangle;
			hstart=getHorizontalPosition(selectionStartHorizontalValue);
			hend=getHorizontalPosition(selectionEndHorizontalValue);
			vstart=getVerticalPosition(selectionStartVerticalValue)
			vend=getVerticalPosition(selectionEndVerticalValue);

			if (hstart > hend) {
				rect.x=hend;
				rect.width=hstart - hend;

				hstartValue=selectionEndHorizontalValue;
				hendValue=selectionStartHorizontalValue;
			} else {
				rect.x=hstart;
				rect.width=hend - hstart;

				hstartValue=selectionStartHorizontalValue;
				hendValue=selectionEndHorizontalValue;
			}

			if (vstart > vend) {
				rect.y=vend;
				rect.height=vstart - vend;

				vstartValue=selectionStartVerticalValue;
				vendValue=selectionEndVerticalValue;
			} else {
				rect.y=vstart;
				rect.height=vend - vstart;

				vstartValue=selectionEndVerticalValue;
				vendValue=selectionStartVerticalValue;
			}

			graphics.lineStyle(1);
			graphics.beginFill(0x000000, 0.02);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();

			const GAP:int=5;
			const INNER:int=3;
			const OUTER:int=4;

			graphics.lineStyle(1, 0x000000, 0.5);

			if (rect.height > 20) {
				if (rect.x > 20) {
					// dot
					graphics.moveTo(rect.x - GAP - OUTER, rect.y);
					graphics.lineTo(rect.x - GAP + INNER, rect.y);

					graphics.moveTo(rect.x - GAP - OUTER, rect.y + rect.height);
					graphics.lineTo(rect.x - GAP + INNER, rect.y + rect.height);

					// line
					graphics.moveTo(rect.x - GAP, rect.y);
					graphics.lineTo(rect.x - GAP, rect.y + rect.height);

					// print
					printVerticalText(vendValue, vstartValue, rect.x - GAP, rect.y, rect.height, true);
				} else {
					// dot
					graphics.moveTo(rect.x + rect.width + GAP - INNER, rect.y);
					graphics.lineTo(rect.x + rect.width + GAP + OUTER, rect.y);

					graphics.moveTo(rect.x + rect.width + GAP - INNER, rect.y + rect.height);
					graphics.lineTo(rect.x + rect.width + GAP + OUTER, rect.y + rect.height);

					// line
					graphics.moveTo(rect.x + rect.width + GAP, rect.y);
					graphics.lineTo(rect.x + rect.width + GAP, rect.y + rect.height);

					// print
					printVerticalText(vendValue, vstartValue, rect.x + rect.width + GAP, rect.y, rect.height, false);
				}
			}

			if (rect.width > 50) {
				if (rect.y > 20) {
					// dot
					graphics.moveTo(rect.x, rect.y - GAP - OUTER);
					graphics.lineTo(rect.x, rect.y - GAP + INNER);

					graphics.moveTo(rect.x + rect.width, rect.y - GAP - OUTER);
					graphics.lineTo(rect.x + rect.width, rect.y - GAP + INNER);

					// line
					graphics.moveTo(rect.x, rect.y - GAP);
					graphics.lineTo(rect.x + rect.width, rect.y - GAP);

					// print
					printHorizontalText(hstartValue, hendValue, rect.x, rect.y - GAP, rect.width, true);
				} else {
					// dot
					graphics.moveTo(rect.x, rect.y + rect.height + GAP - INNER);
					graphics.lineTo(rect.x, rect.y + rect.height + GAP + OUTER);

					graphics.moveTo(rect.x + rect.width, rect.y + rect.height + GAP - INNER);
					graphics.lineTo(rect.x + rect.width, rect.y + rect.height + GAP + OUTER);

					// line
					graphics.moveTo(rect.x, rect.y + rect.height + GAP);
					graphics.lineTo(rect.x + rect.width, rect.y + rect.height + GAP);

					// print
					printHorizontalText(hstartValue, hendValue, rect.x, rect.y + rect.height + GAP, rect.width, false);
				}
			}
		}

		//---------------------------------------------
		// draw total
		//---------------------------------------------
		graphics.lineStyle(0, 0x000000, 0);
		graphics.beginFill(0x000000, 0);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
	}


	//==========================================================================================
	// text control
	//==========================================================================================
	/** Selection에 표시될 가로축 텍스트를 처리할 Label Function */
	public var horizontalLabelFunction:Function;
	
	/** Selection에 표시될 세로축 텍스트를 처리할 Label Function */
	public var verticalLabelFunction:Function;

	private var textLines:Vector.<TextLine>;

	private static var strFac:StringTextLineFactory=new StringTextLineFactory;
	private static var strRect:Rectangle=new Rectangle;
	private static var textFormat:TextLayoutFormat;

	private function printVerticalText(start:Number, end:Number, x:int, y:int, h:int, reverse:Boolean):void {
		var format:TextLayoutFormat=getTextFormat();

		if (reverse) {
			strRect.x=x - 100;
			strRect.y=y;
			strRect.width=100;
			strRect.height=h;

			format.textAlign=TextAlign.RIGHT;
		} else {
			strRect.x=x;
			strRect.y=y;
			strRect.width=100;
			strRect.height=h;

			format.textAlign=TextAlign.LEFT;
		}

		format.verticalAlign=VerticalAlign.TOP;
		strFac.textFlowFormat=format;
		strFac.compositionBounds=strRect;
		strFac.text=(verticalLabelFunction === null) ? start.toFixed(0) : verticalLabelFunction(start);
		strFac.createTextLines(createdTextLines);

		format.verticalAlign=VerticalAlign.BOTTOM;
		strFac.textFlowFormat=format;
		strFac.compositionBounds=strRect;
		strFac.text=(verticalLabelFunction === null) ? end.toFixed(0) : verticalLabelFunction(end);
		strFac.createTextLines(createdTextLines);
	}

	private function printHorizontalText(start:Number, end:Number, x:int, y:int, w:int, reverse:Boolean):void {
		var format:TextLayoutFormat=getTextFormat();

		if (reverse) {
			strRect.x=x;
			strRect.y=y - 100;
			strRect.width=w;
			strRect.height=100;

			format.verticalAlign=VerticalAlign.BOTTOM;
		} else {
			strRect.x=x;
			strRect.y=y;
			strRect.width=w;
			strRect.height=100;

			format.verticalAlign=VerticalAlign.TOP;
		}

		format.textAlign=TextAlign.LEFT;
		strFac.textFlowFormat=format;
		strFac.compositionBounds=strRect;
		strFac.text=(horizontalLabelFunction === null) ? start.toFixed(0) : horizontalLabelFunction(start);
		strFac.createTextLines(createdTextLines);

		format.textAlign=TextAlign.RIGHT;
		strFac.textFlowFormat=format;
		strFac.compositionBounds=strRect;
		strFac.text=(horizontalLabelFunction === null) ? end.toFixed(0) : horizontalLabelFunction(end);
		strFac.createTextLines(createdTextLines);
	}

	private function getTextFormat():TextLayoutFormat {
		if (!textFormat) {
			textFormat=new TextLayoutFormat;
			textFormat.paddingLeft=2;
			textFormat.paddingRight=2;
			textFormat.paddingTop=2;
			textFormat.paddingBottom=2;
			textFormat.color=0x000000;
			textFormat.fontSize=11;
			textFormat.fontFamily="Dotum,Verdana,Arial,_sans";
		}

		return textFormat;
	}

	private function clearTexts():void {
		if (!textLines) {
			return;
		}

		var f:int=textLines.length;
		var line:TextLine;
		while (--f >= 0) {
			line=textLines[f];
			removeChild(line);
			TextLineRecycler.addLineForReuse(line);
		}
		textLines.length=0;
	}

	private function createdTextLines(line:TextLine):void {
		if (!textLines) {
			textLines=new Vector.<TextLine>;
		}

		line.mouseEnabled=false;
		line.mouseChildren=false;
		//		line.tabEnabled=false;
		//		line.tabChildren=false;

		addChild(line);
		textLines.push(line);
	}
}
}
