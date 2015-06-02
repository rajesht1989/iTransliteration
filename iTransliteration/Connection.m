//
//  Connection.m
//  iTransliteration
//
//  Created by Rajesh on 6/2/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "Connection.h"
#import <UIKit/UIKit.h>
@implementation Connection

+ (void)sendAsyncRequestWithText:(NSString *)string andLanguageCode:(NSString *)code block:(completionReturn)completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/inputtools/request?text=%@&ime=transliteration_en_%@&num=5&cp=0&cs=0&ie=utf-8&oe=utf-8&app=jsapi",string,code]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id objReturn = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            completion(objReturn);
        });
    }];
}

@end
