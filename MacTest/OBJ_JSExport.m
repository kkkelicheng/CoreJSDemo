//
//  OBJ_JSExport.m
//  MacTest
//
//  Created by kelicheng on 15/11/7.
//  Copyright © 2015年 klc. All rights reserved.
//

#import "OBJ_JSExport.h"

@implementation OBJ_JSExport

@synthesize funcDescribute;
@synthesize propertyCount;

- (id)initWithContext:(JSContext *)ctx
{
    if (self = [super init]) {
        OBJ_ctx = ctx;
        self.funcName = @"按照视频写的一个测试类";
    }
    return self;
}


- (void)printAllItProperty
{
    NSString * printed = [NSString stringWithFormat:@"\n funcName =%@ \n funcDescribute = %@ \n propertyCount = %ld",self.funcName,self.funcDescribute,self.propertyCount];
    NSLog(@"调用 printAllItProperty = %@",printed);
}



@end
