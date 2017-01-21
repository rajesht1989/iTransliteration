//
//  Transliteration.m
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "Transliteration.h"

@implementation Transliteration

- (instancetype)initWithObject:(id)object
{
    if (self = [super init]) {
        if ([object isKindOfClass:[NSArray class]])
        {
            NSArray *array = object;
            if ([array count] > 1)
            {
               self.isSuccess = [[array objectAtIndex:0] isEqualToString:@"SUCCESS"];
                if ([[array objectAtIndex:1] count])
                {
                    NSArray *arrayObject = [[array objectAtIndex:1] objectAtIndex:0];
                    if ([arrayObject count] > 1)
                    {
                        self.strText = [arrayObject objectAtIndex:0];
                        self.arrTransliteration = [arrayObject objectAtIndex:1];
                    }
                }
               
            }
        }
    }
    return self;
}

@end
