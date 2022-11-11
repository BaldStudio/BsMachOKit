//
//  BsMachODataLoader.h
//  BsMachOKit
//
//  Created by crzorz on 2022/10/13.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
    搜索目录：
    按照下面的目录找二进制文件
    ├── Demo   # App的主二进制，包含需要找的静态库信息
    ├── Frameworks # App的动态库目录
    ├── Plugins # 其他Bundle目录，如单测Bundle

    数据结构：
    [
        {"key": "value"},
        {"key": "value"},
        {"key": "value"},
    ]
*/

typedef NSDictionary<NSString *, NSString *> * BsMachOInjectDataType;
typedef NSArray<BsMachOInjectDataType> * BsMachOInjectDataResult;

@interface BsMachODataLoader : NSObject

/// 读取注入的数据，位于 BS_INJ_SEG, BS_INJ_SECT
/// 数据类型为 BsMachOInjectData
+ (BsMachOInjectDataResult)loadInjectData;

+ (BsMachOInjectDataResult)loadDataFromSegment:(const char *)segmentName
                                       section:(const char *)sectionName;

+ (BsMachOInjectDataResult)loadDataByFrameworkNames:(NSArray<NSString *> *)frameworkNames
                                            segment:(const char *)segmentName
                                            section:(const char *)sectionName;

@end

NS_ASSUME_NONNULL_END
