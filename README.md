# BsMachOKit

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/BaldStudio/BsMachOKit/master/LICENSE)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)

对 Mach-O 自定义段的数据读写库

# 安装

## Cocoapods

在 Podfile 中添加依赖：
```
pod 'BsMachOKit'
```
然后执行 `pod install`

# 使用

## 基本用法
默认从 `BS_INJ_SEG` 和 `BS_INJ_SECT` 获取数据
```
BS_MACHO_INJECT(t, "1");

...

NSArray *data = [BsMachODataLoader loadInjectData];
```
## 扩展用法
- 重写 `BS_INJ_SEG` 和 `BS_INJ_SECT`，覆盖默认的值
- 自定义区段的宏，通过 `loadDataFromSegment:section:` 方法指定名称获取数据
- 调用 `loadDataByFrameworkNames` 指定二进制名称获取数据


