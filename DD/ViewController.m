//
//  ViewController.m
//  DD
//
//  Created by 覃 on 2020/7/9.
//  Copyright © 2020 Qin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton*bt=[UIButton buttonWithType:(UIButtonTypeCustom)];
    bt.frame=CGRectMake(100, 200, 50, 50);
    [bt setTitle:@"按钮" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}


@end
