//
//  Transliteration.h
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transliteration : NSObject

- (instancetype)initWithObject:(id)object;

@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,assign)NSString *strText;
@property(nonatomic,assign)NSArray *arrTransliteration;

@end
