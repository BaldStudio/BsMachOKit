//
//  ViewController.m
//  BsMachOKitDemo
//
//  Created by crzorz on 2021/12/02.
//  Copyright © 2021 BaldStudio. All rights reserved.
//

#import "ViewController.h"
#import <BsMachOKit/BsMachOKit.h>

bs_macho_inject_data(a, "1");
bs_macho_inject_data(b, "2");
bs_macho_inject_data(c, "3");
bs_macho_inject_data(d, 4);
bs_macho_inject_data(e, 5);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *data = [BsMachODataLoader loadInjectData];
    NSLog(@"%@", data);
    for (NSDictionary *d in data) {
        NSString *key = d.allKeys.firstObject;
        NSString *value = d.allValues.firstObject;
        NSLog(@"%@: %@", key, value);
    }
}

@end
