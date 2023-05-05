//
//  BsMachOKitTests.m
//  BsMachOKitTests
//
//  Created by crzorz on 2021/12/02.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <BsMachOKit/BsMachOKit.h>

BS_MACHO_INJECT(q, "1");

@interface BsMachOKitTests : XCTestCase

@end

@implementation BsMachOKitTests

- (void)testLoadInjectData {    
    NSArray *data = [BsMachODataLoader loadInjectData];
    XCTAssertTrue(data.count == 1);
    XCTAssertTrue([data.firstObject isKindOfClass:NSDictionary.class]);
    
    NSDictionary *dict = data.firstObject;
    XCTAssertTrue(dict.allKeys.count == 1);
    XCTAssertTrue(dict.allValues.count == 1);

    XCTAssertTrue([dict.allKeys.firstObject isEqualToString:@"q"]);
    XCTAssertTrue([dict.allValues.firstObject isEqualToString:@"1"]);
}


@end
