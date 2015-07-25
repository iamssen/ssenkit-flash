# Style 관리

기본 Class들을 만들어둔다

- name.space.views.formats
	- HeaderTextFormat
	- ArticleTextFormat
	- ...

기본 바인딩을 해서 사용할 수 있다.

```
<Tag>
	<format>
		<HeaderTextFormat fontSize="13"/>
	</format>
</Tag>
```

# Text Format Interfaces

ITextLayoutFormatComponent
- textAlign : String = left|center|right --> !important
- truncationOptions : TruncationOptions
- format : ITextLayoutFormat
- formatFunction : (defaultFormat:ITextLayoutFormat, params:Dictionary) => ITextLayoutFormat

TextLayoutFormatComponentMixin
- textAlign
- truncationOptions
- format
- formatFunction
- getFormat(params:Object):ITextLayoutFormat

Text Print
- width, height + padding
- text align + vertical align
- minimize, maximize

Components
- HtmlRichText
	- 단순히 text에 html을 입력할 수 있게 해주는 RichText
	- very heavy
- TextComponentMixin + ITextComponent extends DisplayObjectContainer, ITextLayoutFormatComponent
	- text : String = html|plain text
	- width, height
	- padding left, right, top, bottom
	- useMinimizeScaling
	- useMaximizeScaling


- IHtmlLines extends DisplayObjectContainer, ITextLayoutFormatComponent (이 단계는 쓸모 없어짐)
	- weight : text lines + display object container
	- shape :
		- read only width / height (using scaling)
		- text align
	- render : manual
- HtmlLabel extends UIComponent, ITextLayoutFormatComponent
	- weight : text lines + display object container  + ui component
	- shape :
		- write width / height
		- text align
		- vertical align
		- auto scaling (option)
		- @padding
	- render : invalidate

