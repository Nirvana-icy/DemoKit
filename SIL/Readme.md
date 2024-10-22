# 【Swift SIL代码分析系列】@objc & dynamic inside

> 配套Demo工程：
> 
> 1. clone `git@github.com:Nirvana-icy/DemoKit.git` 工程，切换到 /SIL 目录
> 
> 2. 在 test.swift 文件中输入Swift源码
> 
> 3. Terminal中执行以下编译指令
> 
> 
> ```swift
> 
> swiftc -emit-silgen -Onone test.swift | xcrun swift-demangle >> test.sil
> 
> ```
> 
> 3. 在 test.sil 查看输出


## @objc & dynamic inside

### Q1: 如何允许 Objective-C 代码调用 Swift 定义的方法？ 如何实现的?


A1: 使用 @objc属性。实现细节可以通过下面的例子进行说明。


Swift源码：

```swift

import Foundation

class Dog: NSObject {

@objc

func makeNoiseObjC() {}

}

```

  


生成SIL代码：

```swift

// Dog.makeNoiseObjC() // 生成面向swift的 makeNoiseObjC 方法

sil hidden [ossa] @test.Dog.makeNoiseObjC() -> () : $@convention(method) (@guaranteed Dog) -> () {

// %0 "self" // user: %1

bb0(%0 : @guaranteed $Dog):

debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1

%2 = tuple () // user: %3

return %2 : $() // id: %3

} // end sil function 'test.Dog.makeNoiseObjC() -> ()'


// @objc Dog.makeNoiseObjC() // 生成面向Objc的 makeNoiseObjC 方法

sil hidden [thunk] [ossa] @@objc test.Dog.makeNoiseObjC() -> () : $@convention(objc_method) (Dog) -> () {

// %0 // user: %1

bb0(%0 : @unowned $Dog): // 1. 传入Dog对象，@unowned属性修饰

%1 = copy_value %0 : $Dog // users: %6, %2

%2 = begin_borrow %1 : $Dog // users: %5, %4 // 2. begin_borrow通常用于函数参数传递，特别是当参数被标记为@guaranteed时，这表明函数不会消耗（take ownership of）参数值，而是只是借用它

// function_ref Dog.makeNoiseObjC()

%3 = function_ref @test.Dog.makeNoiseObjC() -> () : $@convention(method) (@guaranteed Dog) -> () // user: %4 // 3. 通过 function_ref 获取 Dog.makeNoiseObjC() 方法的引用，并调用它。

%4 = apply %3(%2) : $@convention(method) (@guaranteed Dog) -> () // user: %7

end_borrow %2 : $Dog // id: %5

destroy_value %1 : $Dog // id: %6 // 4. 销毁了复制的 Dog 对象，并返回了方法的调用结果

return %4 : $() // id: %7

} // end sil function '@objc test.Dog.makeNoiseObjC() -> ()'

```

  


通过 @objc 属性，Swift 方法可以被 Objective-C 代码调用，而 SIL 代码则负责处理这些互操作性的细节（见SIL代码中的注释）。

  


### Q2: @objc属性修饰的方法的派发方式是怎样的？

  


A2: v-table

  


```swift

sil_vtable Dog {

#Dog.makeNoiseObjC: (Dog) -> () -> () : @test.Dog.makeNoiseObjC() -> ()   // Dog.makeNoiseObjC()

#Dog.deinit!deallocator: @test.Dog.__deallocating_deinit  // Dog.__deallocating_deinit

}

```

#### Q3 dynamic 的作用？如何实现的？


1. dynamic 的作用：

使用了 dynamic 的 class （只有 class 可以 dynamic），会开启 message 模式，让 OC runtime 可以调用。

2. 实现原理：

`VTable 的变化`：在 Swift 中，每个类都有一个虚函数表（VTable），它包含了类中所有方法的引用。

对于 dynamic 方法，SIL 底部的 VTable 中不会包含该方法的引用，因为这个方法的实现可能在运行时改变，因此不能在编译时静态确定 。