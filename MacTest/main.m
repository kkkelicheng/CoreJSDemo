//
//  main.m
//  MacTest
//
//  Created by kelicheng on 15/11/7.
//  Copyright © 2015年 klc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "OBJ_JSExport.h"
#import "Console.h"


void func1() // OC调用JS的东西 很简单
{
    JSContext * context = [[JSContext alloc]init];
    context[@"abc"] = [JSValue valueWithInt32:120 inContext:context];
    JSValue * resultValue = [context evaluateScript:@"abc + 1"];
    
    context.exceptionHandler=^(JSContext * context  ,JSValue * exception)
    {
        NSLog(@"exception = %@",exception);
    };
    
    NSLog(@"abc value = %d",[resultValue toInt32]);
    
    
    
    //执行一句话
    NSString * script = @"1 + 2 + 3";
    JSValue * sum123 = [context evaluateScript:script];
    NSLog(@"sum 123 = %f",[sum123 toDouble]);
    
    
    
    
    //创建一个JS变量，赋值给js变量
    script = @"var globalValue = 888";
    [context evaluateScript:script];
    //从context 中拿到这个值  NSlog 可以打印JSValue
    NSLog(@"context[变量] = %@)",context[@"globalValue"]);
    
    
    
    JSValue * result;
    //本地定义一个函数
    script = @"function sum(a,b){return a+b;}";
    //放到context中
    [context evaluateScript:script];
    //根据函数名取到这个函数指针
    JSValue * func = context[@"sum"];
    //JS函数 在本地使用新的JSValue类型值去调用函数  数组里面放什么值要跟js函数里面的一样。
    result = [func callWithArguments:@[@99,@1]];
    NSLog(@"result of function sum(99 , 1) = %f",[result toDouble]);
    
    //当然也可以写 [context evaluateScript:@"sum(1,2)"]; 表示执行js函数。
}

void func2(){ //JS 调用native of OC
    JSContext * context = [[JSContext alloc]init];
    JSValue * result;
    //一般有两种方法
    
//    js函数是一个动态的参数
    
    
    // ***** 方法1 *****  -----------------通过block来调用
    // 在本地用block 在 content中申明了一个函数名  就是塞入了一个原生的函数
    context[@"sum"] = ^(int a , int b){
        return a + b;
    };
    //那么在JS可以就直接调用  sum(1,2);
    // 测试下就是
    JSValue * sumValue = context[@"sum"];
    result = [sumValue callWithArguments:@[@999,@1]];
    NSLog(@" js调用结果 = %f",[result toDouble]);



    
    // ***** 方法2 ******* -----------------通过JSExport这个类
    // 请看 func4
    
}


void func3()
{
    JSContext * context = [[JSContext alloc] init];
    JSValue * result ;
    
    context.exceptionHandler = ^(JSContext * ctx , JSValue * exceptValue){
        NSLog(@"exceptValue = %@",exceptValue);
    };
    
    //使用block向context写入一个原生的函数复杂点得部分 -----引用外部值问题
    int i = 100;
    
    context[@"sum"] = ^(int a , int b){
         return  a + b + i;   //视频中说的不可以引用外部的值。内存问题 就连使用context 都得使用【JSContext currentContext】 虽然得出的context跟被塞入函数的context是一同一个东西
    };
    
    // 测试
    JSValue * funSum = context[@"sum"];
    result = [funSum callWithArguments:@[@100 , @1]];
    NSLog(@"func sum 100 + 1 = %f",[result toDouble]);  //测试结果居然可以。是201。不知道是不泄露了。
    

    context[@"sum_2"] = ^(int a , int b){
        JSContext * ctx = [JSContext currentContext];   //正确的引用当前的上下文。外部变量不可以引用
        return a + b;
    };
    
    
    context[@"sum_3"] = ^(){  //这里就是JS的《动态参数》  block里面写成空的也可以。
        NSArray * arguments = [JSContext currentArguments];
        NSInteger intValue = 0;
        for (JSValue * intNumber in arguments) {
            intValue += [intNumber toInt32];
        }
        NSLog(@"receive all number = %ld",intValue);
        return intValue;
    };
    
    JSValue * funSum_3 = context[@"sum_3"];
    JSValue * sum_3_value = [funSum_3 callWithArguments:@[@1,@1,@1,@100]];
    NSLog(@"sum_3_js_value = %d",[sum_3_value toInt32]);
    // 或者
    sum_3_value = [context evaluateScript:@"sum_3(1,2,3,4)"];
    NSLog(@"sum_3_js_evaluateScript = %d",[sum_3_value toInt32]);

    //貌似没什么要注意的了用block
}

//其实自定义的协议继承自JSExport后,也可以让controller实现这个协议,把controller这个对象
//放入jsContext中 self.jsContext[@"xxx"] = self;
void func4()  //使用JSExport协议  让OC的类可以在JS中被调用。也就是可以引用这个类的方法了
{
    JSContext * ctx = [[JSContext alloc]init];
    //实例化一个有JSExport的类
    OBJ_JSExport * objc_js = [[OBJ_JSExport alloc]initWithContext:ctx];
    //把这个类塞到JS中
    ctx[@"objc_js"] = objc_js;
    ctx[@"objc_js"] = objc_js;
    ctx[@"objc_js"] = objc_js;
    ctx[@"objc_js"] = objc_js;

    //测试 让JS执行这个类，然后调用这个类
    [ctx evaluateScript:@"objc_js.printAllItProperty()"];
    
}

//该方法中的内容是:如何获取webView加载完网页后中的jsContext(执行js的上下文)
//关键点在于[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
void func5(){
    //该方法需要在- (void)webViewDidFinishLoad:(UIWebView *)webView 中执行
    /*
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  // 通过模型调用方法，这种方式更好些。
  HYBJsObjCModel *model  = [[HYBJsObjCModel alloc] init];
  // 模型
  self.jsContext[@"OCModel"] = model;
  model.jsContext = self.jsContext;
  model.webView = self.webView;
  // 增加异常的处理
  self.jsContext.exceptionHandler = ^(JSContext *context,   
 JSValue *exceptionValue) {
    context.exception = exceptionValue;
    NSLog(@"异常信息：%@", exceptionValue);
 };
    */
    
}


void loadScript(JSContext * ctx , NSString * fileName);

void addLogFuncToJS(JSContext * ctx);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        func4();
        
        JSContext * ctx = [[JSContext alloc]init];
        addLogFuncToJS(ctx);
        loadScript(ctx, @"test.js");
        [ctx evaluateScript:@"bar(567);"];
        
        //
    }
    return 0;
}



void addLogFuncToJS(JSContext * ctx)
{
    ctx[@"console"] = [[Console alloc]initWithContext:ctx];
}



//调用这个执行js文件
void loadScript(JSContext * ctx , NSString * fileName){
    NSString * resourcePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"resourcePath = %@",resourcePath);
    
//  NSString * filePath = [NSString stringWithFormat:@"%@/JS/%@",resourcePath,fileName];
    NSString * filePath = @"/Users/klc/Desktop/WorkFolder/MacTest/MacTest/JS/test.js";
    NSString * jsString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    ctx.exceptionHandler = ^(JSContext * ctx , JSValue * value){
        NSLog(@"except value = %@",value);
    };
    
    [ctx evaluateScript:jsString];
}

