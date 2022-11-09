//
//  BsMachOKitTests.m
//  BsMachOKitTests
//
//  Created by crzorz on 2021/12/02.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BsMachOKit/BsMachOKit.h>

bs_macho_inject(q, "1");

@interface BsMachOKitTests : XCTestCase

@end

@implementation BsMachOKitTests

- (void)testLoadInjectData {
    BsMachODataLoader.showLog = YES;
    
    NSArray *data = [BsMachODataLoader loadInjectData];
    XCTAssertTrue(data.count == 1);
    XCTAssertTrue([data.firstObject isKindOfClass:NSDictionary.class]);
    
    NSDictionary *kv = data.firstObject;
    XCTAssertTrue(kv.allKeys.count == 1);
    XCTAssertTrue(kv.allValues.count == 1);

    XCTAssertTrue([kv.allKeys.firstObject isEqualToString:@"q"]);
    XCTAssertTrue([kv.allValues.firstObject isEqualToString:@"1"]);
}


@end
