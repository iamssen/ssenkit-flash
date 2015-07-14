package ssen.components.chart.pola.pieAxis2 {
import ssen.common.IDisposable;

public class PieAxisElement implements IDisposable {
	public var axis:PieAxis;

	public function ready():void {
	}

	public function animate(t:Number):void {
	}

	public function render():void {
	}

	public function dispose():void {
		axis = null;
	}
}
}
