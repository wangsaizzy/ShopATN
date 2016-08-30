//
//  PersonalSetUpController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/11.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "PersonalSetUpController.h"
#import "PersonalSetUpView.h"
#import "BackAdviseController.h"
#import "AlertSecretController.h"
#import "AboutUsController.h"
@interface PersonalSetUpController ()
@property (nonatomic, strong) PersonalSetUpView *setUpView;
@end

@implementation PersonalSetUpController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBar];
    self.title = @"个人设置";
    [self setUpViews];
}

- (void)customNaviBar {
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = left;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setUpViews {
    self.setUpView = [[PersonalSetUpView alloc] initWithFrame:self.view.bounds];
    self.view = self.setUpView;
    
    //缓存的单例类
    SDImageCache *sharedCache = [SDImageCache sharedImageCache];
    //得到存储的图片的总大小
    NSInteger imageSize = [sharedCache getSize];
    float imageCache = imageSize / 1024 / 1024;
    float size = [ShopListCache filePath];
    _setUpView.cacheLabel.text = [NSString stringWithFormat:@"%.1fM", imageCache + size];
    //检查更新按钮点击事件
    [_setUpView.checkUpdateBtn addTarget:self action:@selector(checkUpdateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //清除缓存按钮点击事件
    [_setUpView.cleanCacheBtn addTarget:self action:@selector(cleanCacheBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_setUpView.alertSecretBtn addTarget:self action:@selector(alertSecretBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //意见反馈按钮点击事件
    [_setUpView.backAdviseBtn addTarget:self action:@selector(backAdviseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //关于我们按钮点击事件
    [_setUpView.aboutUsBtn addTarget:self action:@selector(aboutUsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -检查更新按钮点击事件
- (void)checkUpdateBtnAction:(UIButton *)sender {
    
    ShowAlertView(@"AITENI1.0版本");
    
    
}






-(void)clearCachSuccess
{

    self.setUpView.cacheLabel.text = @"0.0M";
}

#pragma mark -清除缓存按钮点击事件
- (void)cleanCacheBtnAction:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"是否清除全部缓存" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushCleanMemory];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}




- (void)pushCleanMemory {

    
    //缓存的单例类
    SDImageCache *sharedCache = [SDImageCache sharedImageCache];
    //得到存储的图片的个数
//    NSInteger numberImageFiles = [sharedCache getDiskCount];
//    //得到存储的图片的总大小
//    NSInteger imageSize = [sharedCache getSize];
//    
//    NSLog(@"%@", NSHomeDirectory());
//    NSLog(@"已经缓存的图片个数:%ld, 总大小:%.fM", numberImageFiles, imageSize / 1024. / 1024.);
    [SVProgressHUD showWithStatus:@"清除中"];
    //清除缓存
    
    __block BOOL imagesCleared = NO;
    __block BOOL listDataCleared = NO;
    //图片缓存
    [sharedCache clearDiskOnCompletion:^{
        imagesCleared = YES;
        if (imagesCleared == YES) {
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        }
    }];
    
    //列表缓存
    [ShopListCache clearCacheListData:^{
       
        listDataCleared = YES;
        if (imagesCleared == YES && listDataCleared == YES) {
            
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
        
        }
    }];
    
       
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];

}

- (void)alertSecretBtnAction:(UIButton *)sender {
    
    AlertSecretController *codeVC = [[AlertSecretController alloc] init];
    [self.navigationController pushViewController:codeVC animated:YES];
}

#pragma mark -意见反馈按钮点击事件
- (void)backAdviseBtnAction:(UIButton *)sender {
    BackAdviseController *backVC = [[BackAdviseController alloc] init];
    [self.navigationController pushViewController:backVC animated:YES];
}


#pragma mark -关于我们按钮点击事件
- (void)aboutUsBtnAction:(UIButton *)sender {
    
    AboutUsController *usVC = [[AboutUsController alloc] init];
    [self.navigationController pushViewController:usVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
