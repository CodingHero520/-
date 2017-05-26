//
//  ViewController.m
//  多线程
//
//  Created by 包磊 on 17/3/8.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,assign)int count;
@property (nonatomic,strong)NSTimer * timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self Dispatch_After];
    [self Async];
//    [self Global_Queue];
//    [self BuildQueue];
//    [self dispatch_group_t];
//    [self Barrier_async];
//    [self dispatch_apply];
    
}
#pragma mark -- dispatch_apply
-(void)dispatch_apply{

    dispatch_queue_t DefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(5, DefaultQueue, ^(size_t i) {
       
        NSLog(@"%lu",i);
    });

}

#pragma mark -- barrier_async
-(void)Barrier_async{

    dispatch_queue_t queue = dispatch_queue_create("com.jsxm.concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2");
    });
    
    dispatch_barrier_async(queue, ^{
       
        NSLog(@"3");
    });
    
    dispatch_async(queue, ^{
       
        NSLog(@"4");
    });
    
  //结果是2 1 3 4
  //dispatch_barrier_async(queue, ^{});当前面的任务都执行完成之后再执行，后面的任务需要等待它执行完成之后再执行
    

}
#pragma mark --  调度组
-(void)dispatch_group_t{

    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, defaultQueue, ^{
        
        [NSThread  sleepForTimeInterval:3];
        
        NSLog(@"1");
    });
    
    dispatch_group_async(group, defaultQueue, ^{
       
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"2");
        
    });
    
    dispatch_group_notify(group, defaultQueue, ^{
       
        NSLog(@"3");
        
    });
    
    dispatch_group_enter(group);
    
    dispatch_async(defaultQueue, ^{
       
        NSLog(@"4");
        
        dispatch_group_leave(group);
    });
    
}
#pragma mark -- 创建自定义队列
-(void)BuildQueue{
  //DISPATCH_QUEUE_CONCURRENT：并发执行 NULL串行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.bjsxt,xoncurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"4");
        dispatch_async(concurrentQueue, ^{
           
            [NSThread sleepForTimeInterval:3];
            NSLog(@"5");
        });
        NSLog(@"6");
    });


}
#pragma mark -- 全局队列->并发队列
-(void)Global_Queue{

    //并行队列由dispatch_get_global_queue来创建获取，由系统创建3个不同的优先级，并行队列执行的顺序和其加入队列的顺序相同
    //并发线程可以同时执行多个任务，不过并发队列仍然按先进先出的顺序来启动任务，并发队列会在任务完成之前出列下一个任务开始执行，并发队列同时执行的任务数量会根据应用和系统动态变化，各种因素包括，可用核数量，其它进程正在执行的工作数量，其它串行队列中的任务优先的数量等等因素
    dispatch_queue_t  defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(defaultQueue, ^{
        
        NSLog(@"1");
        
    });
    dispatch_async(defaultQueue, ^{
        
       
        NSLog(@"2");
    });
    dispatch_async(defaultQueue, ^{
       
        NSLog(@"3");
        
    });
    dispatch_async(defaultQueue, ^{
       
        NSLog(@"4");
    });
    
}
#pragma mark -- 串行队列
-(void)Async{

    //串行队列由dispatch_queue_create来创建
    dispatch_queue_t mainQuene = dispatch_queue_create("baicu", NULL);
    
    dispatch_async(mainQuene, ^{
        
        NSLog(@"1");
        
    });
    
    dispatch_async(mainQuene, ^{
        
        NSLog(@"2");
    });
    
    dispatch_async(mainQuene, ^{
       
        NSLog(@"3");
    });
    
    dispatch_async(mainQuene, ^{
        
        NSLog(@"4");
    });
    


}
#pragma mark -- 主线程
-(void)Dispatch_Main{
//   dispatch_get_main_queue()  是唯一一个可以用来更新UI的线程
    //GCD术语
    /*
     1.串行(Serial):让任务一个接一个的执行(一个任务执行完毕之后，再执行下一个任务)
     2.并发(Concurrent)：可以让多个任务并发执行（同时）执行(自动开启多个线程同时执行任务)并发只有在异步函数(dispatch_async)函数下才有效（因为异步具有开启新线程的能力）
     3.同步(Synchronous):在当前线程中执行任务，不具备开启新线程的能力
     4.异步(Asynchronous):在新的线程执行任务，具备开启新线程的能力
     
     */
}
#pragma mark -- 延时多线程
-(void)Dispatch_After{
    
    //这个方法用来做延时处理
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        NSLog(@"到我了");
        
    });
    
    _count =1 ;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
-(void)run{

    if (_count == 20) {
        
        [_timer invalidate];
        _timer = nil;
    }
    _count ++;
    
    NSLog(@"%d",_count);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
