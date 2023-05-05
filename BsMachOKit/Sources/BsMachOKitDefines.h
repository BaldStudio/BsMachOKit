//
//  BsMachOKitDefines.h
//  BsMachOKit
//
//  Created by crzorz on 2022/10/14.
//  Copyright © 2022 BaldStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 日志等开关
#ifndef BS_MACHO_DEBUG
#define BS_MACHO_DEBUG 0
#endif

#pragma mark-  *** Injector ***

#ifndef BS_INJ_SEG
#define BS_INJ_SEG "__BS_INJ"
#endif

#ifndef BS_INJ_SECT
#define BS_INJ_SECT "__data"
#endif

typedef struct {
    char *key;
    char *value;
} BsMachOInjectData;

#define BS_MACHO_ANNOTATION(seg, sect) \
__attribute((used, section(seg "," sect)))

#define BS_MACHO_INJECT_KV(seg, sect, _key_, _value_) \
BS_MACHO_ANNOTATION(seg, sect) \
static const BsMachOInjectData __bs_macho_##_key_##_data = { \
    .key = #_key_,      \
    .value = _value_,  \
}

#define BS_MACHO_INJECT(key, value) \
BS_MACHO_INJECT_KV(BS_INJ_SEG, BS_INJ_SECT, key, value)


NS_ASSUME_NONNULL_END
