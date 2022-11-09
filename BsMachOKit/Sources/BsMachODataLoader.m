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

@implementation BsMachODataLoader

+ (NSArray *)loadInjectData {
    return [self loadDataFromSegment:BS_INJ_SEG
                             section:BS_INJ_SECT];
}

+ (NSArray *)loadDataFromSegment:(const char *)segmentName
                         section:(const char *)sectionName {
    
    NSMutableArray *frameworkNames = [NSMutableArray array];
        
    // 通过主二进制文件，找静态库的注入数据
    {
        NSString *name = NSBundle.mainBundle.executablePath.lastPathComponent;
        if (name.length) {
            [frameworkNames addObject:name];
        }
        else {
            [self print:@"Load Main Bundle MachO Error"];
        }
    }
    
    NSFileManager *fm = NSFileManager.defaultManager;

    // Frameworks
    {
        NSString *path = NSBundle.mainBundle.privateFrameworksPath;
        NSError *error;
        NSArray *contents = [fm contentsOfDirectoryAtPath:path
                                                    error:&error];
        if (error) {
            [self print:@"Load Frameworks MachO Error: %@", error.localizedFailureReason];
        }
        else {
            for (NSString *file in contents) {
                [frameworkNames addObject:file.stringByDeletingPathExtension];
            }
        }
    }
    
    // Plugins
    {
        NSString *path = NSBundle.mainBundle.builtInPlugInsPath;
        if ([fm fileExistsAtPath:path]) {
            NSError *error;
            NSArray *contents = [fm contentsOfDirectoryAtPath:path
                                                        error:&error];
            if (error) {
                [self print:@"Load Plugins MachO Error: %@", error.localizedFailureReason];
            }
            else {
                for (NSString *file in contents) {
                    [frameworkNames addObject:file.stringByDeletingPathExtension];
                }
            }
        }
    }
    
    return [self loadDataByFrameworkNames:frameworkNames
                                  segment:segmentName
                                  section:sectionName];
}

+ (NSArray *)loadDataByFrameworkNames:(NSArray *)frameworkNames
                              segment:(const char *)segmentName
                              section:(const char *)sectionName {
    
    [self print:@"Prepare loading frameworks: %@", frameworkNames];

    NSMutableArray *result = [NSMutableArray array];

    for (NSString *name in frameworkNames) {
        u_long size = 0;
        uintptr_t *mem = (uintptr_t *)getsectdatafromFramework([name UTF8String],
                                                               segmentName,
                                                               sectionName,
                                                               &size);
        if (mem == NULL) {
            [self print:@"Skip load for framework: %@", name];
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
                [self print:@"Skip parse for framework: %@, at: %lu", name, i];
            }
        }
    }
    
    return result.copy;
}

static BOOL __showLog = NO;
+ (void)setShowLog:(BOOL)showLog {
    __showLog = showLog;
}

+ (BOOL)showLog {
    return __showLog;
}

+ (void)print:(NSString *)log, ... {
    if (self.showLog) {
        NSLog(@"[%@] %@", NSStringFromClass(self), log);
    }
}

@end
