package ssen.components.grid.headers {
import ssen.common.IDisposable;

public interface IHeaderColumnRenderer {
	function draw(container:IHeaderContainer, column:IHeaderColumn):IDisposable;
}
}
