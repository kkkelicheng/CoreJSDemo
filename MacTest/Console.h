//
//  Console.h
//  MacTest
//
//  Created by kelicheng on 15/11/7.
//  Copyright © 2015年 klc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol ConsoleJSExport <JSExport>

-(void)log;

@end

@interface Console : NSObject<ConsoleJSExport>
{
    JSContext * myCtx;
}
- (id)initWithContext:(JSContext *)ctx;

@end
