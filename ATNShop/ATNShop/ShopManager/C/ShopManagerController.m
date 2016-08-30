//
//  ShopManagerController.m
//  @的你
//
//  Created by 吴明飞 on 16/3/24.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "ShopManagerController.h"
#import "PersonalSetUpController.h"
#import "UIView+Addition.h"
#import "CaiWuDuiZhangController.h"
#import "DrawMoneyController.h"
#import "ShopInformationController.h"
#import "ManagerProductController.h"
#import "UserCommentController.h"
#import "TodayListController.h"
#import "LoginAndRegistViewController.h"
#import "AppDelegate.h"
#import "ShopInformationModel.h"
#import "NewsViewController.h"
#import "DimensionalView.h"
#import <CommonCrypto/CommonCryptor.h>
#import "ServerForCodeText.h"
#import "ApplyActivityController.h"
#import "ManagerModel.h"
@interface ShopManagerController ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceLittleLabel;
@property (nonatomic, strong) UILabel *acountLabel;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, strong) DimensionalView *dimenView;
@end

@implementation ShopManagerController



- (DimensionalView *)dimenView {
    
    if (!_dimenView) {
        
        self.dimenView = [[DimensionalView alloc] initWithFrame:CGRectMake(60 * kMulriple, 185 * kHMulriple, 255 * kMulriple, 300 * kHMulriple)];
        self.dimenView.layer.cornerRadius = 20 * kMulriple;
        self.dimenView.layer.masksToBounds = YES;
        [self.dimenView.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dimenView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:RGB(94, 94, 94)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    if ([IsAppLoginTool unarchiveIsAppLogin] == YES) {
        
        [self getOrderAndIncomeData];
        
    }
 
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //布局视图
    
    [self setupViews];
    
    if ([IsAppLoginTool unarchiveIsAppLogin] == YES) {
      
       [self getUserInfoData];
       
    }
    else
    {
        // 进入登录页面
        LoginAndRegistViewController *loginView = [[LoginAndRegistViewController alloc]init];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:loginView];
        navVC.navigationBar.translucent = NO;
        [self presentViewController:navVC animated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"LoginShopSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"ChangeSuccess" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderAndIncomeData) name:@"RefreshAnalysisData" object:nil];
}


- (void)getUserInfoData {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    WS(weakself);
  
    [HttpHelper requestUrl:KUserinfor_url success:^(id json) {
        [SVProgressHUD dismiss];
        NSDictionary *shopDic = json[@"data"][@"shop"];
        [weakself parseUserInfoDic:shopDic];
        
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)parseUserInfoDic:(NSDictionary *)dic {
    
    
    
    ManagerModel *model = [[ManagerModel alloc] initWithDic:dic];
    
    [UserModel defaultModel].portraitUrl = model.portraitUrl;
    [UserModel defaultModel].shopName = model.name;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.portraitUrl]];
    [self.photoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImage"] options:SDWebImageRefreshCached];
    
    self.nameLabel.text = model.name;

    self.shopName = model.name;
    
    [UserModel defaultModel].phone = model.phone;

    
}
- (void)getOrderAndIncomeData {
    
    
    WS(weakself);
    [HttpHelper requestUrl:KAnalysis_url success:^(id json) {
        
        [weakself parseAnalysisDic:json];
     
    } failure:^(NSError *error) {
        
    }];

}

//解析数据 添加到数据源
- (void)parseAnalysisDic:(NSDictionary *)dic{
    
        
        NSDictionary *dataDic = dic[@"data"];
        ManagerModel *model = [[ManagerModel alloc] initWithDic:dataDic];
        NSNumber *income =  model.sumTodayInmoney;
        if ([income floatValue] > 0) {
            NSInteger a = [income integerValue];
            float b = [income floatValue];
            float c = b - a;
            
            self.priceLabel.text = [NSString stringWithFormat:@"￥%ld.", a];
            
            self.priceLabel.frame = CGRectMake(10 * kMulriple, 5 * kHMulriple, [self widthForContentText:self.priceLabel.text], 30 * kHMulriple);
            self.priceLittleLabel.frame = CGRectMake([self widthForContentText:self.priceLabel.text] + 10 * kMulriple, 13 * kHMulriple, 40 * kMulriple, 20 * kHMulriple);
            NSString *subStr = [NSString stringWithFormat:@"%.2f", c];
            self.priceLittleLabel.text = [subStr substringWithRange:NSMakeRange(2, 2)];
            
        } else {
            self.priceLabel.text = @"￥0.";
            self.priceLittleLabel.text = @"00";
            self.priceLabel.frame = CGRectMake(10 * kMulriple, 5 * kHMulriple, 50 * kMulriple, 30 * kHMulriple);
            self.priceLittleLabel.frame = CGRectMake(55 * kMulriple, 12.5 * kHMulriple, 40 * kMulriple, 20 * kHMulriple);
            
        }
        
        if ([model.countTodayOrders integerValue] > 0) {
            
            self.acountLabel.text = [NSString stringWithFormat:@"%@", model.countTodayOrders];

        } else {
            
            self.acountLabel.text = @"0";
        }
    
    
}


#pragma mark -跳转到个人设置页面
- (void)setUpBtnAction:(UIButton *)sender {
    PersonalSetUpController *personVC = [[PersonalSetUpController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark -跳转到系统消息页面
- (void)messageBtnAction:(UIButton *)sender {
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)deleteBtnAction:(UIButton *)sender {
    
    [self.dimenView removeFromSuperview];
}

#pragma mark -跳转到二维码页面
- (void)codeBtnAction:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"101100%@", [AccountTool unarchiveShopId]];

    [self.view addSubview:self.dimenView];
    [self.dimenView bringSubviewToFront:self.dimenView.deleteBtn];
    self.dimenView.shopNameLabel.text = self.shopName;
    self.dimenView.backgroundColor = [UIColor whiteColor];
    
    [self.dimenView.saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //将字符串转换成NSData
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
   
    //将CIImage转换成UIImage,并放大显示
    self.dimenView.scanImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:220];

}

//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)saveBtnAction:(UIButton *)sender {
    
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    UIImageWriteToSavedPhotosAlbum(self.dimenView.scanImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (error == nil) {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        
    }else{
        
        [SVProgressHUD showInfoWithStatus:@"保存失败"];
    }
    
}

#pragma mark -跳转到今日订单页面
- (void)listBtnAction:(UIButton *)sender {
    
    TodayListController *listVC = [[TodayListController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
    
}

#pragma mark -第一行按钮点击事件
- (void)firstLineBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100:{
            
            CaiWuDuiZhangController *caiWuVC = [[CaiWuDuiZhangController alloc] init];
            [self.navigationController pushViewController:caiWuVC animated:YES];
            
        }
            break;
        case 101: {
            DrawMoneyController *drawVC = [[DrawMoneyController alloc] init];
//            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//            backItem.title = @"收入提现";
//            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:drawVC animated:YES];
        }
            break;
        case 102:{
            ShopInformationController *shopVC = [[ShopInformationController alloc] init];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -第二行按钮点击事件
- (void)secondLineBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 200:{
            ManagerProductController *managerVC = [[ManagerProductController alloc] init];
            [self.navigationController pushViewController:managerVC animated:YES];
        }
            break;
        case 201: {
            UserCommentController *commentVC = [[UserCommentController alloc] init];
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
            
        case 202: {
            
             NSString *phoneStr = @"010-53655235";
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        
        }
            break;
        default:
            break;
    }
}

#pragma mark -第三行按钮点击事件
- (void)thirdLineBtnAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 300:{
            
            ApplyActivityController *activityVC = [[ApplyActivityController alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;
            
        case 301:{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self loginoutHandle];
            }];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [self presentViewController:alertController animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)loginoutHandle {
    

    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.nameLabel.text = @"";
    
    [[UserModel defaultModel] clearUserModel];
    
    [AccountTool clearAccount];
    [TimeTool clearTimeFile];
    [IsAppLoginTool clearIsAppLogin];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginOutSuccess" object:nil];
    LoginAndRegistViewController *loginView = [[LoginAndRegistViewController alloc]init];
    loginView.isFromHomeView = YES;
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:loginView];
    navVC.navigationBar.translucent = NO;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)setupViews {
    //设置背景色
    self.view.backgroundColor = RGB(237, 237, 237);
    
    //背景视图
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 * kHMulriple, kWight, 200 * kHMulriple)];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:headView.bounds];
    backImageView.image = [UIImage imageNamed:@"shopBackGround"];
    [headView addSubview:backImageView];
    
    //头像
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(152 * kMulriple, 30 * kHMulriple, 70 * kMulriple, 70 * kHMulriple)];
    [self.photoImageView setImage:[UIImage imageNamed:@"headImage"]];
    _photoImageView.layer.cornerRadius = 35 * kMulriple;
    _photoImageView.layer.masksToBounds = YES;
    
    [headView addSubview:self.photoImageView];
    
    //昵称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(147 * kMulriple, 115 * kHMulriple, 240 * kMulriple, 20 * kHMulriple)];
    _nameLabel.centerX = kWight / 2;
    _nameLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    [headView addSubview:self.nameLabel];
    
    //个人设置按钮
    UIButton *setUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    setUpBtn.frame = CGRectMake(kWight - 50 * kMulriple, 15 * kHMulriple, 30 * kMulriple, 30 * kHMulriple);
    [setUpBtn setBackgroundImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    
    [setUpBtn addTarget:self action:@selector(setUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:setUpBtn];
    
    //消息按钮
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(115 * kMulriple, 135 * kHMulriple, 60 * kMulriple, 60 * kHMulriple)];
    [messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [headView addSubview:messageBtn];
    
    //二维码按钮
    UIButton *codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(220 * kMulriple, 135 * kHMulriple, 60 * kMulriple, 60 * kHMulriple)];
    [codeBtn setImage:[UIImage imageNamed:@"dimen"] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:codeBtn];
    headView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:headView];
    
    //中间视图
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 220 * kHMulriple, kWight, 100 * kHMulriple)];
    secondView.backgroundColor = [UIColor whiteColor];
    //今日收入按钮
    UIButton *inComeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50 * kMulriple, 15 * kHMulriple, 100 * kMulriple, 80 * kHMulriple)];
    
    //今日收入
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * kHMulriple, 65 * kMulriple, 30 * kHMulriple)];
    
    _priceLabel.textColor = [UIColor redColor];
    
    
    _priceLabel.font = [UIFont systemFontOfSize:25 * kMulriple];
    
    self.priceLittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60 * kMulriple, 13 * kHMulriple, 40 * kMulriple, 20 * kMulriple)];
    self.priceLittleLabel.textColor = [UIColor redColor];
    _priceLittleLabel.font = [UIFont systemFontOfSize:19 * kMulriple];
    [inComeBtn addSubview:self.priceLittleLabel];
    [inComeBtn addSubview:self.priceLabel];
    
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMulriple, 40 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
    todayLabel.centerX = inComeBtn.width / 2;
    todayLabel.text = @"今日收入";
    todayLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    todayLabel.textColor = RGB(111, 111, 111);
    todayLabel.textAlignment = NSTextAlignmentCenter;
    [inComeBtn addSubview:todayLabel];
    [secondView addSubview:inComeBtn];
    
    //今日订单按钮
    UIButton *listBtn = [[UIButton alloc] initWithFrame:CGRectMake(225 * kMulriple, 15 * kHMulriple, 100 * kMulriple, 100 * kHMulriple)];
    [listBtn addTarget:self action:@selector(listBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * kHMulriple, 100 * kMulriple, 30 * kHMulriple)];
    _acountLabel.centerX = inComeBtn.width / 2;
    _acountLabel.textColor = [UIColor redColor];
    
    _acountLabel.textAlignment = NSTextAlignmentCenter;
    _acountLabel.font = [UIFont systemFontOfSize:25 * kMulriple];
    [listBtn addSubview:self.acountLabel];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMulriple, 40 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
    listLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    listLabel.centerX = inComeBtn.width / 2;
    listLabel.text = @"今日订单";
    listLabel.textColor = RGB(111, 111, 111);
    listLabel.textAlignment = NSTextAlignmentCenter;
    [listBtn addSubview:listLabel];
    [secondView addSubview:listBtn];
    
    [self.view addSubview:secondView];
    

    //分类视图
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 321.5 * kHMulriple, kWight, kHeight - 322 * kHMulriple)];
    categoryView.backgroundColor = RGB(237, 237, 237);
    NSArray *firstLineImageArr = @[@"verifyMoney",@"cashApply",@"shopInformation"];
    NSArray *firstLineLabelArr = @[@"财务对账", @"收入提现", @"店铺信息"];
    for (int i = 0; i < 3; i++) {
        
        //第一行按钮
        UIButton *firstLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * 125.5 * kMulriple, 0, 124 * kMulriple, 103 * kHMulriple)];
        firstLineBtn.backgroundColor = [UIColor whiteColor];
        UIImageView *firstLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:firstLineImageArr[i]]];
        [firstLineBtn addSubview:firstLineBtnImage];
        firstLineBtnImage.centerX = firstLineBtn.width / 2;
        firstLineBtnImage.centerY = 70  * kHMulriple / 2;
        UILabel *firstLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, firstLineBtnImage.frame.size.height + 10 * kHMulriple, firstLineBtn.frame.size.width, 12 * kHMulriple)];
        firstLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        firstLineLabel.textAlignment = NSTextAlignmentCenter;
        firstLineLabel.textColor = RGB(111, 111, 111);
        firstLineLabel.text = firstLineLabelArr[i];
        firstLineLabel.centerY = 145 * kHMulriple / 2;
        [firstLineBtn addSubview:firstLineLabel];
        [firstLineBtn addTarget:self action:@selector(firstLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        firstLineBtn.tag = 100 + i;
        [categoryView addSubview:firstLineBtn];
    }
    
    NSArray *secondLineImageArr = @[@"goodsManager",@"comment", @"business"];
    NSArray *secondLineLabelArr = @[@"管理产品", @"查看评价", @"联系业务经理"];
    for (int j = 0; j < 3; j++) {
        
        //第二行按钮
        UIButton *secondLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(125.5 * j * kMulriple, 104 * kHMulriple, 124 * kMulriple, 103 * kHMulriple)];
        secondLineBtn.backgroundColor = [UIColor whiteColor];
        UIImageView *secondLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:secondLineImageArr[j]]];
        [secondLineBtn addSubview:secondLineBtnImage];
        secondLineBtnImage.centerX = secondLineBtn.width / 2;
        secondLineBtnImage.centerY = 70 * kHMulriple / 2;
        UILabel *secondLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, secondLineBtnImage.frame.size.height + 10 * kHMulriple, secondLineBtn.frame.size.width, 12 * kHMulriple)];
        secondLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        secondLineLabel.textAlignment = NSTextAlignmentCenter;
        secondLineLabel.textColor = RGB(111, 111, 111);
        secondLineLabel.text = secondLineLabelArr[j];
        secondLineLabel.centerY = 145 * kHMulriple / 2;
        [secondLineBtn addSubview:secondLineLabel];
        [secondLineBtn addTarget:self action:@selector(secondLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        secondLineBtn.tag = 200 + j;
        [categoryView addSubview:secondLineBtn];
    }
    //第三行按钮
    NSArray *thirdLineImageArr = @[@"activityApply",@"loginout"];
    NSArray *thirdLineLabelArr = @[@"活动申请", @"退出登录"];
    for (int k = 0; k < 2; k++) {
        
        UIButton *thirdLineBtn = [[UIButton alloc] initWithFrame:CGRectMake(125.5 * k * kMulriple, 208 * kHMulriple, 124 * kMulriple, 103 * kHMulriple)];
        thirdLineBtn.backgroundColor = [UIColor whiteColor];
        UIImageView *thirdLineBtnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:thirdLineImageArr[k]]];
        [thirdLineBtn addSubview:thirdLineBtnImage];
        thirdLineBtn.tag = 300 + k;
        thirdLineBtnImage.centerX = thirdLineBtn.width / 2;
        thirdLineBtnImage.centerY = 70 * kHMulriple/ 2;
        UILabel *thirdLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, thirdLineBtnImage.frame.size.height + 10 * kHMulriple, thirdLineBtn.frame.size.width, 12 * kHMulriple)];
        thirdLineLabel.font = [UIFont systemFontOfSize:14 * kMulriple];
        thirdLineLabel.textAlignment = NSTextAlignmentCenter;
        thirdLineLabel.text = thirdLineLabelArr[k];
        thirdLineLabel.textColor = RGB(111, 111, 111);
        thirdLineLabel.centerY = 145 * kHMulriple / 2;
        [thirdLineBtn addSubview:thirdLineLabel];
        [thirdLineBtn addTarget:self action:@selector(thirdLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [categoryView addSubview:thirdLineBtn];
    }

    
    [self.view addSubview:categoryView];
}

//动态计算文本的高度
- (CGFloat)widthForContentText:(NSString *)text{
    //文本渲染时需要一个矩形的大小 第一个参数:size 在限定的范围(宽高区域内) size(控件的宽度, 尽量大的高度值)
    //attributes属性:设置的字体大小要和控件(contentLabel)的字体大小匹配一致 避免出现计算偏差
    
    CGSize boudingSize = CGSizeMake(335, 30);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:25 * kMulriple]};
    return [text boundingRectWithSize:boudingSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.width;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginShopSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeSuccess" object:nil];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshAnalysisData" object:nil];
}

@end
