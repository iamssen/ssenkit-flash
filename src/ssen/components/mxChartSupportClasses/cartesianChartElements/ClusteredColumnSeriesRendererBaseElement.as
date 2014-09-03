    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();

		if (!chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis)) {
			return;
		}

		var dataProvider:IList=chart.dataProvider as IList;

		var columnSet:ColumnSet=chart.series[0];
		var columnSetRects:Vector.<Vector.<Rectangle>>=getColumnRects(dataProvider, columnSet, unscaledWidth, unscaledHeight);
		var columnRects:Vector.<Rectangle>;
		var columnRect:Rectangle;
		var columnSetRect:Rectangle=new Rectangle;

		var v:Number;

		var f:int;
		var fmax:int;
		var s:int;
		var smax:int;

		var columnSetSeries:Array;
		var columnData:Object;
		var series:ColumnSeries;
		var fields:Vector.<String>;
		var field:String;

		begin();

		// loop data provider
		f=-1;
		fmax=dataProvider.length;

		while (++f < fmax) {
			columnRects=columnSetRects[f];
			columnSetSeries=columnSet.series;
			columnData=dataProvider.getItemAt(f);

			// column set rect
			columnRect=columnRects[0];
			series=columnSetSeries[0] as ColumnSeries;

			v=Number(columnData[series.yField]);

			columnSetRect.x=columnRect.x;
			columnSetRect.y=Number.MAX_VALUE;
			columnSetRect.width=0;
			columnSetRect.height=0;

			// loop series
			s=-1;
			smax=columnSetSeries.length;

			// field
			fields=new Vector.<String>(smax, true);

			while (++s < smax) {
				columnRect=columnRects[s];
				series=columnSetSeries[s] as ColumnSeries;

				field=series.yField;
				fields[s]=field;

				v=Number(columnData[field]);

				columnRect.y=getVerticalPosition(v);
				columnRect.height=unscaledHeight - columnRect.y;

				// draw
				drawColumnOverHead(columnRect, columnData, field);

				// column set rect
				if (columnRect.y < columnSetRect.y) {
					columnSetRect.y=columnRect.y;
					columnSetRect.height=columnRect.height;
				}
				columnSetRect.width+=columnRect.width;
			}

			drawColumnSetOverHead(columnSetRect, columnData, fields);
		}

		end();
	}

	private function getColumnRects(dataProvider:IList, columnSet:ColumnSet, w:Number, h:Number):Vector.<Vector.<Rectangle>> {
		// var columnMaxWidth:Number=columnSet.maxColumnWidth;   maxColumnWidth의 2배로 보인다... 왜지?
		var columnSetMaxWidth:Number=columnSet.maxColumnWidth * 2;
		var columnSetWidthRatio:Number=columnSet.columnWidthRatio;

		var columnSetSpaceWidth:Number=w / dataProvider.length;
		var columnSetWidth:Number=columnSetSpaceWidth * columnSetWidthRatio;

		if (!isNaN(columnSetMaxWidth) && columnSetWidth > columnSetMaxWidth) {
			columnSetWidth=columnSetMaxWidth;
		}

		var columnSetSeries:Array=columnSet.series;
		var columnWidth:Number=columnSetWidth / columnSetSeries.length;

		var columnSetLeft:Number=(columnSetSpaceWidth - columnSetWidth) / 2;

		var f:int=-1;
		var fmax:int=dataProvider.length;
		var s:int;
		var smax:int;
		var rect:Rectangle;

		var rects:Vector.<Vector.<Rectangle>>=new Vector.<Vector.<Rectangle>>(fmax, true);
		var columnSetRects:Vector.<Rectangle>;

		while (++f < fmax) {
			s=-1;
			smax=columnSetSeries.length;

			columnSetRects=new Vector.<Rectangle>(smax, true);

			while (++s < smax) {
				rect=new Rectangle;
				rect.x=((columnSetSpaceWidth * f) + columnSetLeft) + (columnWidth * s);
				rect.y=0;
				rect.width=columnWidth;
				rect.height=h;

				columnSetRects[s]=rect;
			}

			rects[f]=columnSetRects;
		}

		return rects;
	}

	protected function begin():void {

	}

	protected function end():void {

	}

	protected function drawColumnOverHead(rect:Rectangle, data:Object, field:String):void {
		graphics.beginFill(0x000000, 0.4);
		graphics.drawRect(rect.x + 2, rect.y, rect.width - 4, rect.height);
		graphics.endFill();
	}

	protected function drawColumnSetOverHead(rect:Rectangle, data:Object, fields:Vector.<String>):void {
		graphics.beginFill(0x000000, 0.2);
		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		graphics.endFill();
	}