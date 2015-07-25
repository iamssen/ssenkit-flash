package ssen.drawing {
import flash.display.Graphics;
import flash.geom.Point;

import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;

public class GraphicsUtils {
	/**
	 * DashedLineRenderer에서 참조하는 점선 라인 로직을 구현한 메소드
	 *
	 * @param graphics 점선을 그릴 대상 객체의 graphics 객체
	 * @param stroke Stroke으로 사용될 Stroke 객체
	 * @param points 위치 좌표를 담은 배열
	 *
	 */
	public static function drawDashedPolyLine(graphics:Graphics, stroke:IStroke, points:Array):void {
		var color:uint;
		var alpha:uint;
		var thickness:uint=stroke.weight;

		if (stroke is Stroke) {
			color=Stroke(stroke).color;
			alpha=Stroke(stroke).alpha;
		} else if (stroke is SolidColorStroke) {
			color=SolidColorStroke(stroke).color;
			alpha=SolidColorStroke(stroke).alpha;
		} else {
			return;
		}

		var pointsArr:Array=getPoints(points);
		for (var i:int=0; i < pointsArr.length - 1; i++) {
			if (i <= pointsArr.length - 1) {
				DashedLine.drawDashedLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha);
			}
		}
	}

	public static function drawArrowLine(graphics:Graphics, stroke:Stroke, points:Array):void {
		var color:uint=stroke.color;
		var alpha:uint=stroke.alpha;
		var thickness:uint=stroke.weight;
		var pointsArr:Array=getPoints(points);
		for (var i:int=0; i < pointsArr.length - 1; i++) {
			if (i == pointsArr.length - 2) {
				Line.drawArrowLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha, true);
			} else {
				Line.drawArrowLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha, false);
			}
		}
	}

	public static function drawStepLine(graphics:Graphics, stroke:Stroke, points:Array):void {
		var color:uint=stroke.color;
		var alpha:uint=stroke.alpha;
		var thickness:uint=stroke.weight;
		var pointsArr:Array=getPoints(points);
		for (var i:int=0; i < pointsArr.length - 1; i++) {
			if (i == 0) {
				Line.drawStepLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha, "start");
			} else if (i == pointsArr.length - 2) {
				Line.drawStepLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha, "end");
			} else {
				Line.drawStepLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha, "");
			}
		}
	}

	public static function drawGapLine(graphics:Graphics, gap:Number, stroke:Stroke, points:Array):void {
		var color:uint=stroke.color;
		var alpha:uint=stroke.alpha;
		var thickness:uint=stroke.weight;
		var pointsArr:Array=getPoints(points);
		for (var i:int=0; i < pointsArr.length - 1; i++) {
			if (i <= pointsArr.length - 1) {
				Line.drawGapLine(graphics, gap, pointsArr[i], pointsArr[i + 1], color, thickness, alpha);
			}
		}
	}

	private static function getPoints(value:Array):Array {
		var result:Array=new Array();
		for (var i:int=0; i < value.length; i++) {
			var point:Point=new Point(value[i].x, value[i].y);
			result.push(point);
		}
		return result;
	}
}
}

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.geom.Point;

class Line {
	/**
	 * 생성자 함수
	 **/
	public function Line() {

	}

	/**
	 *
	 * target을 지정받아 target의 graphics 객체를 사용해 라인을 그리는 메소드.
	 *
	 * @param s graphics 객체를 사용할 대상 오브젝트
	 * @param startX 라인을 그릴 최초 X 좌표
	 * @param startY 라인을 그릴 최초 Y 좌표
	 * @param endX startX좌표로부터 라인을 이을 목표 X좌표
	 * @param endY startY좌표로부터 라인을 이을 목표 Y좌표
	 * @param thick 라인의 두께
	 * @param color 라인의 색
	 *
	 *
	 **/
	public static function drawLine ( g:Graphics, startX :Number, startY :Number, endX :Number, endY :Number, thick :Number, color :Number ):void
	{
		var g:Graphics = g;
		g.clear();
		g.lineStyle ( thick, color, 100 );
		g.moveTo ( startX, startY );
		g.lineTo ( endX, endY );
	}

	public static function drawArrowLine(g:Graphics, startPoint:Point, endPoint:Point, lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1, bArrow:Boolean = false):void {
		var g:Graphics = g;
		var pt:Point = new Point(startPoint.x,startPoint.y);
		var pt2:Point = new Point(endPoint.x,endPoint.y);
		var dx:Number = pt2.x - pt.x;
		var dy:Number = pt2.y - pt.y;
		var dist:Number = Math.sqrt(dx * dx + dy * dy);
		var len:Number = Math.round(dist / 10);
		var theta:Number = Math.atan2(dy, dx);

		g.lineStyle(thickness, lineColor, alpha);
		g.moveTo(pt.x, pt.y);
		g.lineTo(pt2.x, pt2.y);

		if (bArrow) {
			var pA:Point = new Point(pt2.x + Math.cos(theta + 10) * 10, pt2.y + Math.sin(theta + 10) * 10);
			var pB:Point = new Point(pt2.x + Math.cos(theta - 10) * 10, pt2.y + Math.sin(theta - 10) * 10);

			g.lineStyle(1, lineColor, alpha);
			g.moveTo(pt.x, pt.y);
			g.beginFill(0xFFFFFF, alpha);
			g.drawCircle(pt.x, pt.y, thickness / 2);
			g.endFill();

			g.lineStyle(thickness, lineColor, alpha, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			g.moveTo(pt2.x, pt2.y);
			g.beginFill(lineColor, alpha);
			g.lineTo(pA.x, pA.y);
			g.lineTo(pB.x, pB.y);
			g.lineTo(pt2.x, pt2.y);
			g.endFill();
		} else {
			g.lineStyle(1, lineColor, alpha);
			g.moveTo(pt.x, pt.y);
			g.beginFill(0xFFFFFF, alpha);
			g.drawCircle(pt.x, pt.y, thickness / 2);
			g.endFill();
		}
	}

	public static function drawStepLine(g:Graphics, startPoint:Point, endPoint:Point, lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1, pos:String=""):void {
		var g:Graphics = g;
		var pt:Point = new Point(startPoint.x,startPoint.y);
		var pt2:Point = new Point(endPoint.x,endPoint.y);
		var dx:Number = pt2.x - pt.x;
		var dy:Number = pt2.y - pt.y;
		var dist:Number = Math.sqrt(dx * dx + dy * dy);
		var len:Number = Math.round(dist / 10);
		var theta:Number = Math.atan2(dy, dx);

		var ptCenter:Point = new Point((pt.x + pt2.x) / 2, (pt.y + pt2.y) / 2);
		g.lineStyle(thickness, lineColor, alpha, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);

		if (pos == "start") {
			g.moveTo(pt.x, pt.y);
			g.lineTo(pt.x - (ptCenter.x - pt.x), pt.y);
		} else if (pos == "end") {
			g.moveTo(pt2.x, pt2.y);
			g.lineTo(pt2.x - (ptCenter.x - pt2.x), pt2.y);
		}

		g.moveTo(pt.x, pt.y);
		g.lineTo(ptCenter.x, pt.y);
		g.moveTo(ptCenter.x, pt2.y);
		g.lineTo(pt2.x, pt2.y);
	}

	public static function drawGapLine (g:Graphics, gap:Number, startPoint:Point, endPoint:Point, color :Number, thick :Number, alpha:Number ):void
	{
		var pt:Point = new Point(startPoint.x,startPoint.y);
		var pt2:Point = new Point(endPoint.x,endPoint.y);
		var dx:Number = pt2.x - pt.x;
		var dy:Number = pt2.y - pt.y;
		var theta:Number = Math.atan2(dy, dx);

		var pA:Point = new Point(pt.x + Math.cos(theta) * gap, pt.y + Math.sin(theta) * gap);
		var pB:Point = new Point(pt2.x + Math.cos(theta) * -gap, pt2.y + Math.sin(theta) * -gap);

		g.lineStyle ( thick, color, alpha );
		g.moveTo ( pA.x, pA.y );
		g.lineTo ( pB.x, pB.y );
	}
}

class DashedLine
{
	/**
	 *
	 * 대상 객체의  graphics 속성등을 입력받아 점선을 긋는 메소드
	 *
	 * @param g  점선을 그릴 대상 객체의 grapihcs 객체
	 * @param startPoint   점선의 시작점
	 * @param endPoint 점선의 끝저
	 * @param lineColor 라인의 색상
	 * @param thickness 선의 두께
	 * @param alpha 선의 알파값
	 *
	 *
	 **/
	public static function drawDashedLine(g:Graphics,startPoint:Point,endPoint:Point,lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1):void {
		var g:Graphics=g;
		g.lineStyle(thickness,lineColor,alpha);
		var pt:Point =new Point(startPoint.x,startPoint.y);
		var pt2:Point = new Point(endPoint.x,endPoint.y);
		var dx:Number = pt2.x - pt.x;
		var dy:Number = pt2.y - pt.y;
		var dist:Number= Math.sqrt(dx*dx+dy*dy);
		var len:Number = Math.round(dist/10);
		var theta:Number = Math.atan2(dy,dx);
		for (var i:int=0; i<len; i++) {
			g.moveTo(pt.x,pt.y);
			var targetPoint:Point;
			if (i==len-1) {
				targetPoint = new Point(pt2.x- Math.cos(theta)*5,pt2.y-Math.sin(theta)*5);
			} else {
				targetPoint = new Point(pt.x + Math.cos(theta)*5,pt.y + Math.sin(theta)*5);
			}
			g.lineTo(targetPoint.x,targetPoint.y);
			pt = new Point(targetPoint.x + Math.cos(theta)*5,targetPoint.y + Math.sin(theta)*5);
		}
	}
	/**
	 *
	 * 대상 객체의  graphics 속성등을 입력받아 점으로 이루어진 사각형을 그리는 메소드
	 *
	 * @param g  점선을 그릴 대상 객체의 grapihcs 객체
	 * @paramx x 사각형이 시작될 x 좌표
	 * @param y 사각형이 시작될 y 좌표
	 * @param width 사각형의 너비
	 * @param height 사각형의 높이
	 * @param lineColor 라인의 색상
	 * @param thickness 선의 두께
	 * @param alpha 선의 알파값
	 *
	 *
	 **/
	public static function drawDashedRect(g:Graphics,x:Number,y:Number,width:Number,height:Number,lineColor:uint=0x000000,thickness:uint=1,alpha:uint=1):void {
		DashedLine.drawDashedLine(g,new Point(x,y),new Point(x+width,y),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x+width,y),new Point(x+width,y+height),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x+width,y+height),new Point(x,y+height),lineColor,thickness);
		DashedLine.drawDashedLine(g,new Point(x,y+height),new Point(x,y),lineColor,thickness);
	}
}