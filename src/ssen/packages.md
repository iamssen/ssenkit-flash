# case

1. Showcase__ 가 붙은 파일들은 library 에서 exclude 시킨다
1. 각각의 directory에 component.yml 을 넣어서 자동으로 manifest.xml 을 만들어내고, command line에 -namespace 옵션을 추가한다


mxmlc command line build 시에 아래와 같이 하지 않으면 뭔가 좆같아짐...

```
flbuild.addArg('-keep-as3-metadata=Inject,PostConstruct')
flbuild.addArg('-default-size 1600 900')
flbuild.addArg('-warnings=false')
flbuild.addArg('-compress=true')
flbuild.addArg('-debug=false')
flbuild.addArg('-optimize=true')
flbuild.addArg('-static-link-runtime-shared-libraries=true')
flbuild.addArg('-accessible=true')
```

# libraries

- ssen.reflow
- ssen.components // 종류별로 구분하지 말고, namespace 단위로 구분하자
    - graphicElements
        - SVGImage extends UIComponent
        - LinedBox extends FilledElement
    - dropdownAnchors
        - DropdownAnchor extends SkinnableComponent
        - DropdownAnchorSkin
        - DropdownPopupAnchor
    - ssen-mxchart : mxChartSupportClasses
        - cartesianChartElements
            - CartesianChartElement --> LogAxis, EaseLinearAxis 대응되게 변경
            - ColumnSeriesRendererBaseElement
            - StackedColumnSeriesRendererBaseElement
            - StackedColumnWireElement!
        - axis
            - EaseLinearAxis
        - series
            - EaseLinearSeries!
    - polaChart
        - PolaChart
        - radarAxis
            - RadarAxis
            - RadarSeries
        - pieAxis
            - PieAxis
            - PieSeries
    - cartesianChart
        - CartesianChart
    - containers
        - AnimateContainer extends SkinnableContainer
        - AnimateContainerSkin
        - MaskingContainer extends SkinnableContainer
        - MaskingContainerSkin
    - focus
        - TransparentFocusSkin
    - ssen-sparkgrid : sparkDatagridSupportClasses
        - editors
        - renderers
        - editableRenderers
        - models
    - inputs
    - popups
    - renderers
    - scroll
- ssen.theme.lined
    - 
- ssen.layouts
    - FlowLayout --> 이거 뭔가 제대로 안되었던 것 같은데...
- ssen.animations
    - IBitmapAnimation
    - SwipeAnimation
    - SlideAnimation
- ssen.drawing
    - 
- ssen.devkit
- ssen.datakit