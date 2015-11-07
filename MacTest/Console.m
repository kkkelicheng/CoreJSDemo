
//
//  Console.m
//  MacTest
//
//  Created by kelicheng on 15/11/7.
//  Copyright © 2015年 klc. All rights reserved.
//

#import "Console.h"



@implementation Console

- (id)initWithContext:(JSContext *)ctx
{
    if (self = [super init]) {
        myCtx = ctx;
    }
    return self;
}

-(void)log
{
    NSArray * args = [JSContext currentArguments];
    NSLog(@"%@",[args componentsJoinedByString:@","]);
}


@end
