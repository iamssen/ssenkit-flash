package ssen.components.sparkDatagridSupportClasses._showcase_.views {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import mx.collections.IList;
import mx.core.UIComponent;

import spark.components.DataGrid;
import spark.formatters.NumberFormatter;

import ssen.components.sparkDatagridSupportClasses._showcase_.models.FooterGraphDataGridRow;
import ssen.components.sparkDatagridSupportClasses.elements.IDataGridRowElement;
import ssen.components.sparkDatagridSupportClasses.elements.RowElementController;

public class SampleFooterGraph extends UIComponent implements IDataGridRowElement {
	protected var helper:RowElementController;

	public function SampleFooterGraph() {
		helper=new RowElementController;
		helper.rowElement=this;
		helper.draw=draw;
	}

	public function get dataGrid():DataGrid {
		return helper.dataGrid;
	}

	public function set dataGrid(value:DataGrid):void {
		helper.dataGrid=value;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		helper.updateDisplayList(unscaledWidth, unscaledHeight);
	}

	private function draw(sizeChanged:Boolean, scrollChanged:Boolean, collectionChanged:Boolean):void {
		var g:Graphics=graphics;

		g.clear();
		g.beginFill(0x969696);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
		g.beginFill(0xe6e6e6);
		g.drawRect(0, 1, unscaledWidth, unscaledHeight - 1);
		g.endFill();
		clearText();

		var columns:IList=helper.dataGrid.grid.columns;
		var f:int=-1;
		var fmax:int=columns.length;
		var fill:Rectangle;
		var content:Rectangle;

		var max:int=getMax();
		var contentsBounds:Vector.<Rectangle>=new Vector.<Rectangle>(fmax);
		var first:Rectangle;

		while (++f < fmax) {
			fill=helper.dataGrid.grid.getColumnBounds(f);
			g.beginFill(0xfafafa);
			if (f === 0) {
				first=fill=content=new Rectangle(fill.x + 1, 1, fill.width, unscaledHeight - 1);
			} else if (f === fmax - 1) {
				fill=new Rectangle(fill.x + 2, 1, unscaledWidth - fill.x - 3, unscaledHeight - 1);
				content=new Rectangle(fill.x + 2, 1, fill.width - 1, unscaledHeight - 1);
			} else {
				fill=content=new Rectangle(fill.x + 2, 1, fill.width - 1, unscaledHeight - 1);
			}
			g.drawRect(fill.x, fill.y, fill.width, fill.height);
			g.endFill();

			contentsBounds[f]=content;
		}

		drawLines(max, first);

		f=-1;
		fmax=dataGrid.dataProvider.length;
		while (++f < fmax) {
			drawRow(dataGrid.dataProvider.getItemAt(f) as FooterGraphDataGridRow, max, contentsBounds);
		}
	}

	private static const graphPaddingTop:int=20;
	private static const graphPaddingBottom:int=20;

	private function getGraphY(q:int, max:int):int {
		var spaceHeight:int=height - graphPaddingTop - graphPaddingBottom;
		var graphHeight:int=spaceHeight * (q / max);

		return spaceHeight - graphHeight + graphPaddingTop;
	}

	private function drawLines(max:int, bound:Rectangle):void {
		var f:int=-1;
		var fmax:int=7;
		var q:int;
		var y:int;

		var textBound:Rectangle=bound.clone();

		while (++f <= fmax) {
			q=max * (f / fmax);
			y=getGraphY(q, max);
			graphics.beginFill(0xe6e6e6);
			graphics.drawRect(0, y, width, 1);
			graphics.endFill();
			textBound.y=y - 20;
			textBound.height=20;
			printText(q, textBound);
		}
	}

	private function drawRow(row:FooterGraphDataGridRow, max:int, bounds:Vector.<Rectangle>):void {
		var f:int=0;
		var fmax:int=9;
		var x:int;
		var y:int;
		var q:int;
		var b:Rectangle;

		var ps:Vector.<Point>=new Vector.<Point>;
		var p:Point;

		while (++f < fmax) {
			q=row["q" + f];
			b=bounds[f];
			x=(b.width / 2) + b.x;
			y=getGraphY(q, max);

			ps.push(new Point(x, y));

			graphics.lineStyle();
			graphics.beginFill(row.color);
			graphics.drawCircle(x, y, 4);
			graphics.endFill();
		}

		f=-1;
		fmax=ps.length;
		while (++f < fmax) {
			p=ps[f];
			graphics.lineStyle(3, row.color);
			if (f === 0) {
				graphics.moveTo(p.x, p.y);
			} else {
				graphics.lineTo(p.x, p.y);
			}
		}
	}

	private function getMax():int {
		if (!dataGrid.dataProvider) {
			return 0;
		}

		var f:int=dataGrid.dataProvider.length;
		var row:FooterGraphDataGridRow;
		var max:int=0;
		while (--f >= 0) {
			row=dataGrid.dataProvider.getItemAt(f) as FooterGraphDataGridRow;
			max=Math.max(max, row.q1, row.q2, row.q3, row.q4, row.q5, row.q6, row.q7, row.q8);
		}

		return max;
	}

	private var factory:StringTextLineFactory;
	private var formatter:NumberFormatter;
	private var lines:Vector.<TextLine>;

	private function clearText():void {
		if (lines) {
			var f:int=lines.length;
			var line:TextLine;
			while (--f >= 0) {
				line=lines[f];
				removeChild(line);
				TextLineRecycler.addLineForReuse(line);
			}

			lines.length=0;
		}
	}

	private function printText(num:Number, boundary:Rectangle):void {
		if (!factory) {
			formatter=new NumberFormatter;
			formatter.fractionalDigits=0;

			var format:TextLayoutFormat=new TextLayoutFormat;
			format.color=0xcccccc;
			format.textAlign=TextAlign.RIGHT;
			format.verticalAlign=VerticalAlign.BOTTOM;
			format.fontFamily="_sans";
			format.fontSize=11;
			format.paddingRight=5;

			factory=new StringTextLineFactory;
			factory.textFlowFormat=format;

			lines=new Vector.<TextLine>;
		}

		factory.compositionBounds=boundary;
		factory.text=formatter.format(num);
		factory.createTextLines(function(line:TextLine):void {
			addChild(line);
			lines.push(line);
		});
	}
}
}
