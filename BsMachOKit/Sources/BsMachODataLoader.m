//
//  BsMachODataLoader.m
//  BsMachOKit
//
//  Created by crzorz on 2022/10/13.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

#import "BsMachODataLoader.h"
#import "BsMachOKitDefines.h"

#include <mach-o/getsect.h>

#if BS_MACHO_DEBUG
#define BS_MACHO_DLOG(FORMAT, ...) \
NSLog(@"[BsMachODataLoader] %@", [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define BS_MACHO_DLOG(FORMAT, ...)
#endif

@implementation BsMachODataLoader

+ (NSArray *)loadInjectData {
    return [self loadDataFromSegment:BS_INJ_SEG
                             section:BS_INJ_SECT];
}

+ (NSArray *)loadDataFromSegment:(const char *)segmentName
                         section:(const char *)sectionName {
    
    NSMutableArray *frameworkNames = [NSMutableArray array];
        
    // 通过主二进制文件，找静态库的注入数据
    NSString *mainExecute = NSBundle.mainBundle.executablePath.lastPathComponent;
    if (mainExecute.length) {
        [frameworkNames addObject:mainExecute];
    }
    else {
        BS_MACHO_DLOG(@"Load Main Bundle MachO Error");
    }

    // Frameworks
    [frameworkNames addObjectsFromArray:
         [self fileNamesAtPath:NSBundle.mainBundle.privateFrameworksPath]];

    // Plugins
    [frameworkNames addObjectsFromArray:
         [self fileNamesAtPath:NSBundle.mainBundle.builtInPlugInsPath]];
    
    return [self loadDataByFrameworkNames:frameworkNames
                                  segment:segmentName
                                  section:sectionName];
}

+ (NSArray *)loadDataByFrameworkNames:(NSArray *)frameworkNames
                              segment:(const char *)segmentName
                              section:(const char *)sectionName {
    BS_MACHO_DLOG(@"Prepare loading frameworks: %@", frameworkNames);

    NSMutableArray *result = [NSMutableArray array];

    for (NSString *name in frameworkNames) {
        u_long size = 0;
        uintptr_t *mem = (uintptr_t *)getsectdatafromFramework(name.UTF8String,
                                                               segmentName,
                                                               sectionName,
                                                               &size);
        if (mem == NULL) {
            BS_MACHO_DLOG(@"Skip load for framework: %@", name);
            continue;
        }
        
        u_long count = size / sizeof(BsMachOInjectData);
        BsMachOInjectData *addrs = (BsMachOInjectData *)mem;
        for (u_long i = 0; i < count; i++) {
            BsMachOInjectData obj = (BsMachOInjectData)addrs[i];
            NSString *key = [NSString stringWithUTF8String:obj.key];
            NSString *value = [NSString stringWithUTF8String:obj.value];
            if (key.length && value.length) {
                [result addObject:@{key: value}];
            }
            else {
                BS_MACHO_DLOG(@"Skip parse for framework: %@, at: %lu", name, i);
            }
        }
    }
    
    return result.copy;
}

+ (NSArray *)fileNamesAtPath:(NSString *)path {
    NSFileManager *fm = NSFileManager.defaultManager;
    NSMutableArray *fileNames = [NSMutableArray array];
    if (![fm fileExistsAtPath:path]) {
        return fileNames.copy;
    }
    
    NSError *error;
    NSArray *contents = [fm contentsOfDirectoryAtPath:path
                                                error:&error];
    if (error) {
        BS_MACHO_DLOG(@"Load Files Error: %@", error.localizedFailureReason);
        return fileNames.copy;
    }

    for (NSString *file in contents) {
        [fileNames addObject:file.stringByDeletingPathExtension];
    }
    return fileNames.copy;
}

@end
