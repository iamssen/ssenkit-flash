package ssen.components.chart.pola.pieAxis2 {
import ssen.components.base.renderHelpers.AnimationTrack;
import ssen.components.tooltips.ToolTipProvider;

public class PieSeries extends PieAxisElement {
	public var dataField:String;

	public var fillField:String;
	public var fillFunction:Function;

	public var outerRadiusRatio:Number = 1;
	public var innerRadiusRatio:Number = 0;

	public var toolTipProvider:ToolTipProvider;
	public var wedgeRenderer:PieSeriesWedgeRenderer;

	public var animationTrack:AnimationTrack;

	override public function ready():void {
		super.ready();
	}

	override public function animate(t:Number):void {
		super.animate(t);
	}

	override public function render():void {
		super.render();
	}

	override public function dispose():void {
		super.dispose();
	}
}
}
