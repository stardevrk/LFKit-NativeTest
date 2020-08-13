//
//  ViewController.m
//  PARtmp
//
//  Created by DevMaster on 8/9/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import "ViewController.h"
#import "LivePreview.h"

@interface ViewController ()
    @property (nonatomic, copy) LivePreview *recordView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect previewRect = CGRectMake(30, 30, 180, 250);
    _recordView = [[LivePreview alloc] initWithFrame:previewRect];
    [self.view addSubview:_recordView];
    
}


@end
