//
//  Connection.h
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completionReturn)(id response);

@interface Connection : NSObject

+ (void)sendAsyncRequestWithText:(NSString *)string andLanguageCode:(NSString *)code block:(completionReturn)completion;

@end
