# SwiftRipple
![SwiftRipple](SwiftRipple.gif)
# Overview

[中文](README_zh.md) [日本語](README_ja.md)

SwiftRipple is a SwiftUI Library for all platforms to create beautiful ripple effects, consisting of submodules `SwiftRipple`, `RippleButton`, and `Pulse`. With these components, you are just a bit of code from a fantastic ripple experience on SwiftUI.

`SwiftRipple` is the core module of the whole project. It integrates touch recognition so that it will automatically generate ripples on touch - you just need to put it there!

`RippleButton` is a ready-to-use material-design-like button built with `SwiftRipple` that provides smooth interaction and animation.

`Pulse` provides full functionality in `SwiftRipple` while providing increased flexibility so that you can manually handle and build your own fantastic ripple. Please check the examples here.


# Usage

## SwiftRipple

The initialization of `SwiftRipple` can be done in the following way:

```swift
SwiftRipple(
    @ViewBuilder ripple: @escaping (CGPoint) -> Ripple,
    appearAnimation: Animation,
    disappearAnimation: Animation,
    ripplePercent: CGFloat?,
    disappearApproach: RippleDisappearApproach = .extendOpacityDisappear
)
```

Let's explain the parameters:

- `ripple`: A closure you provide that returns the content of the ripple. The `CGPoint` parameter is the touch position, so that you can change the ripple content based on the touch position.
- `appearAnimation`: Use this to customize the animation "curve" when the ripple appears.
- `disappearAnimation`: Use this to customize the animation "curve" when the ripple disappears.
- `ripplePercent`: The percentage of the ripple when it's at the maximum size when the touch is held (not yet released).
<a id="disappearApproach"></a>
- `disappearApproach`: The approach when the ripple disappears. You can choose from `.extendOpacityDisappear` and `.opacityDisappear`. Selecting `.extendOpacityDisappear` will attempt to dilate the ripple to fill the whole screen before disappearing with opacity change, while selecting `.opacityDisappear` is with merely opacity change.

### NOTE

You can also use `appearDuration` and `disappearDuration` instead of `appearAnimation` and `disappearAnimation` to customize the duration of the animation without explicitly providing the animation curve. The unit is second.

## RippleButton

The initialization of `RippleButton` can be done in the following way:

```swift
RippleButton(
    @ViewBuilder content: @escaping (Bool, CGPoint) -> Content,
    @ViewBuilder background: @escaping (Bool, CGPoint) -> Background,
    @ViewBuilder ripple: @escaping (CGPoint) -> Ripple,
    action: @escaping (CGPoint) -> Void,
    appearAnimation: Animation,
    disappearAnimation: Animation,
    ripplePercent: CGFloat?,
    disappearApproach: RippleDisappearApproach = .extendOpacityDisappear
)
```

Let's explain the parameters:

- `content`: The content of the button. Basically what you put in `label` section when creating a SwiftUI native button. RippleButton will provide you two parameters. The first parameter is a boolean indicating whether the button is currently pressed, and the second parameter is the touch position.
- `background`: The background of the button. RippleButton will provide you two parameters with the same meaning as `content`.
- `ripple`: A closure you provide that returns the content of the ripple.
- `action`: The action to be performed when the button is pressed. The parameter is the touch position.
- `appearAnimation`: Use this to customize the animation "curve" when the ripple appears.
- `disappearAnimation`: Use this to customize the animation "curve" when the ripple disappears.
- `ripplePercent`: The percentage of the ripple when it's at the maximum size when the touch is held (not yet released).
- `disappearApproach`: See [the explanation of this in SwiftRipple](#disappearApproach).

### NOTE

- Just like how SwiftRipple does, you can also use `appearDuration` and `disappearDuration` instead of `appearAnimation` and `disappearAnimation` to customize the duration of the animation without explicitly providing the animation curve. The unit is second.

- You can also directly provide a `Ripple` instance to `ripple` parameter. Other initializers do exactly the same.

## Pulse

The initialization of `Pulse` can be done in the following way:

```swift
Pulse(
@ViewBuilder ripple: @escaping (Bool, CGPoint) -> Ripple,
    appearAnimation: Animation,
    disappearAnimation: Animation,
    defaultRipplePercent: CGFloat? = 0.8,
    disappearApproach: RippleDisappearApproach = .extendOpacityDisappear,
    ripples: Binding<[RippleParameter]>,
    allowTouch: Bool = false
)
``` 

`Pulse` provides full functionality in `SwiftRipple`, which means you need to manually handle how ripples are created and removed. This means that you will need to manage the array of `RippleParameter` yourself.

If anytime you need your life to be a little easier, `allowTouch` is always here for you. When `allowTouch` is on, `Pulse` will automatically handle the touch event and generate ripples, and you just need to handle the rest. Check for the [examples]() here.

### How to use `RippleParameter`

`RippleParameter` has the following properties:

- `pos`: The center of the ripple.
- `diameter`: The diameter of the ripple. SwiftRipple uses diameter instead of radius because in most cases it reduces background calculation and is more convenient.
- `scale`: The scale of the ripple.
- `isInternal`: Whether the ripple is internal.
  - This is useful when `allowTouch` is on, because when the touch is automatically handled, the touch ripple is considered "external", and the real ripple effects you want to make(e.g. an animation that loops, just like the [example]()) will be considered "internal". You can always focus on what you want to process by using `removeFirstInternalRipple()` or `removeFirstExternalRipple()`.
  - For example, when you create a Ripple, you basically just create one and then remove that one. But you don't want to just remove the first `RippleParameter` in the array because the user may touch and create a "touch ripple" `RippleParameter`. When you try to remove the ripple for the effact that you want to make, the first ripple in the array may not be the same one that you just creted. It may become the one that user created instead. So you will want to remove first "internal" ripple instead of just remove the first ripple in the array.
  - On contrary, if you are going to manually handle the user touch, the ripple created by the user should be considered external, so you will want to remove the first external ripple in the array.
  - By separating user's touch and the ripple effect you want to create, you can always keep the order of removing ripple correct.

## Example

After you added the library to your project, you can always open the library .swift file and there are some examples' preview macro already created for you.

You can either check examples there or check the example project [here]().