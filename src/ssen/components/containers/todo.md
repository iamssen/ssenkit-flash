# Files

- AnimateContainer.as
- AnimateContainerSkin.mxml
- MaskingAnimateContainer.as


SkinnableContainer Base...

내부 Display를 Bitmap Drawing 해서 효과로 사용한다.

animateContainer : BitmapImage
prev : BitmapData -- 이전 상태 Capture
next : BitmapData -- 이후 상태 Capture

1. invalidateAnimate
1. commitProperties
    1. contentGroup으로 prev를 만든다
    1. 각 종, component들에 값들을 입력
1. updateDisplayList? (contentGroup의 update가 완료된 상태를 감지...)
    1. contentGroup으로 next를 만든다
    1. transition.start(animateContainer, prev, next)
        1. animateContainer를 보이게 한다
        1. prev를 그린다
        1. transition animate to next
        1. animateContainer를 안보이게 한다
        1. prev와 next를 dispose() 한다

```
<TransitionContainer>
    <transition>
        <Swipe direction="left" duration="0.4"/>
        <Slide direction="left" duration="0.4"/>
        <!--
        IBitmapTransition
        - start(container : BitmapData, prev : BitmapData, next : BitmapData)
        - stop()
        - pause()
        - resume()
        -->
    </transition>
</TransitionContainer>
```