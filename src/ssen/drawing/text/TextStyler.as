package ssen.drawingkit.text {
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextLayoutFormat;

/** Text Styler */
public class TextStyler {
	public static function getTextLayoutFormat(font:IFont, fontColor:uint, fontSize:int, letterSpacing:Number=0, textAlign:String="left",
											   verticalAlign:String="top", paddingLeft:int=0, paddingRight:int=0, paddingTop:int=0,
											   paddingBottom:int=0):TextLayoutFormat {
		var textFormat:TextLayoutFormat=new TextLayoutFormat;
		textFormat.color=fontColor;
		textFormat.fontSize=fontSize;
		textFormat.textAlign=textAlign;
		textFormat.verticalAlign=verticalAlign;
		textFormat.trackingLeft=letterSpacing;
		textFormat.trackingRight=letterSpacing;
		textFormat.fontFamily=font.fontFamily;
		textFormat.fontLookup=font.fontLookup;
		textFormat.paddingLeft=paddingLeft;
		textFormat.paddingRight=paddingRight;
		textFormat.paddingTop=paddingTop;
		textFormat.paddingBottom=paddingBottom;
		
		return textFormat;
	}
	
	public static function setFlowFormat(flow:TextFlow, font:IFont, letterSpacing:Number=0, textAlign:String="left",
										 verticalAlign:String="top", paddingLeft:int=0, paddingRight:int=0, paddingTop:int=0,
										 paddingBottom:int=0):TextFlow {
		flow.textAlign=textAlign;
		flow.verticalAlign=verticalAlign;
		flow.trackingLeft=letterSpacing;
		flow.trackingRight=letterSpacing;
		flow.fontFamily=font.fontFamily;
		flow.fontLookup=font.fontLookup;
		flow.paddingLeft=paddingLeft;
		flow.paddingRight=paddingRight;
		flow.paddingTop=paddingTop;
		flow.paddingBottom=paddingBottom;
		
		return flow;
	}
	
	public static function getTextLineSize(format:TextLayoutFormat, text:String, factory:StringTextLineFactory=null):Rectangle {
		factory=(factory !== null) ? factory : new StringTextLineFactory;
		factory.textFlowFormat=format;
		factory.text=text;
		factory.compositionBounds=new Rectangle(0, 0, 2560, 1600);
		
		var rect:Rectangle;
		
		factory.createTextLines(function(line:TextLine):void {
			if (rect === null) {
				rect=new Rectangle(line.x, line.y, line.width, line.height);
			} else {
				rect=rect.union(new Rectangle(line.x, line.y, line.width, line.height));
			}
			
			TextLineRecycler.addLineForReuse(line);
		});
		
		return rect;
	}
}
}
