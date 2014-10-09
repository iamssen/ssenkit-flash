package ssen.components.sparkDatagridSupportClasses._showcase_.views {
import flash.display.Graphics;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import mx.collections.IList;
import mx.core.UIComponent;

import spark.components.DataGrid;
import spark.formatters.NumberFormatter;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import ssen.flexkit.components.grid.elements.IDataGridRowElement;
import ssen.flexkit.components.grid.elements.RowElementController;
import ssen.showcase.models.FooterDataGridRow;

public class SampleFooterElement extends UIComponent implements IDataGridRowElement {
	protected var helper:RowElementController;

	public function SampleFooterElement() {
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
		clearText();

		var columns:IList=helper.dataGrid.grid.columns;
		var f:int=-1;
		var fmax:int=columns.length;
		var fill:Rectangle;
		var text:Rectangle;

		var totals:Vector.<int>=getTotals();

		while (++f < fmax) {
			fill=helper.dataGrid.grid.getColumnBounds(f);
			g.beginFill(0xf8f8f8);
			if (f === 0) {
				fill=text=new Rectangle(fill.x + 1, 1, fill.width, unscaledHeight - 1);
			} else if (f === fmax - 1) {
				fill=new Rectangle(fill.x + 2, 1, unscaledWidth - fill.x - 3, unscaledHeight - 1);
				text=new Rectangle(fill.x + 2, 1, fill.width - 1, unscaledHeight - 1);
			} else {
				fill=text=new Rectangle(fill.x + 2, 1, fill.width - 1, unscaledHeight - 1);
			}
			g.drawRect(fill.x, fill.y, fill.width, fill.height);
			g.endFill();

			if (totals[f] > 0) {
				printText(totals[f], text);
			}
		}
	}

	private function getTotals():Vector.<int> {
		if (!dataGrid.dataProvider) {
			return new <int>[0, 0, 0, 0, 0, 0];
		}

		var mobile:int=0;
		var tablet:int=0;
		var labtop:int=0;
		var desktop:int=0;

		var f:int=dataGrid.dataProvider.length;
		var row:FooterDataGridRow;
		while (--f >= 0) {
			row=dataGrid.dataProvider.getItemAt(f) as FooterDataGridRow;
			mobile+=row.mobile;
			tablet+=row.tablet;
			labtop+=row.labtop;
			desktop+=row.desktop;
		}

		return new <int>[0, 0, mobile, tablet, labtop, desktop];
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
			format.textAlign=TextAlign.RIGHT;
			format.verticalAlign=VerticalAlign.MIDDLE;
			format.fontFamily="_sans";
			format.fontSize=12;
			format.paddingRight=20;

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
