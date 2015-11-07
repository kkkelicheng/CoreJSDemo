var foo = function(a){
    return "hello OC , I'm foo in JS." + a;
};

function bar(a){
    console.log("执行func -> bar " + a);
    return "hello OC , I'm bar in JS." + a;
};

foo(245);
bar(123);


console.log(foo(245));
// 在没有Console这个类的情况下 这里居然不报错  不过也没打印  mac os 环境 iOS不知包不报错。
//由于 doc 、 window 、 console 需要特定的环境去支持 所以在纯JS里面会发现不识别 console。
// 这个时候就需要在OC 本地去mock 这个console的效果 创建一个Console类写一个log方法。









//language();


//console.log(Date.now());
//console.time("sum");
//var sum = 0;
//for (var i =0 ; i < 1e5 ; i ++ ){
//    sum ++;
//}
//console.info(sum)
//console.timeEnd("sum");