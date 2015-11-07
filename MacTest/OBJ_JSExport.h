//
//  OBJ_JSExport.h
//  MacTest
//
//  Created by kelicheng on 15/11/7.
//  Copyright © 2015年 klc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol OBJ_JSExport <JSExport>  //这里其实就是在JS里面声明的几个变量和方法。然后JS可以知道这个里面的东西。然后操作

@property (nonatomic,copy) NSString * funcDescribute ;
@property (nonatomic,assign) NSInteger propertyCount;

- (void)printAllItProperty;

@end



@interface OBJ_JSExport : NSObject <OBJ_JSExport>{
    JSContext * OBJ_ctx;
}

@property (nonatomic,copy) NSString * funcName;

- (id)initWithContext:(JSContext *)ctx;  //当然 JS 无法看到这个。


@end
