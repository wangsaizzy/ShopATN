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

#import <CommonCrypto/CommonCryptor.h>
#import "ServerForCodeText.h"
#import "ManagerModel.h"
#import "ShopManagerView.h"
@interface ShopManagerController ()
@property (nonatomic, strong) ShopManagerView *managerView;
@property (nonatomic, copy) NSString *shopName;

@end

@implementation ShopManagerController




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

#pragma mark -- 自定义视图
- (void)setupViews {
    
    self.managerView = [[ShopManagerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.managerView];
    
    
    [_managerView.setUpBtn addTarget:self action:@selector(setUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_managerView.messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [_managerView.listBtn addTarget:self action:@selector(listBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *firstLineBtn = (UIButton *)[_managerView viewWithTag:1000 + i];
        [firstLineBtn addTarget:self action:@selector(firstLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *secondLineBtn = (UIButton *)[_managerView viewWithTag:2000 + i];
        [secondLineBtn addTarget:self action:@selector(secondLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [_managerView.loginoutBtn addTarget:self action:@selector(loginoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.managerView.photoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage"] options:SDWebImageRefreshCached];
    
    self.managerView.nameLabel.text = model.name;

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
            
            self.managerView.priceLabel.text = [NSString stringWithFormat:@"￥%ld.", a];
            
            self.managerView.priceLabel.frame = CGRectMake(10 * kMulriple, 5 * kHMulriple, [self widthForContentText:self.managerView.priceLabel.text], 30 * kHMulriple);
            self.managerView.priceLittleLabel.frame = CGRectMake([self widthForContentText:self.managerView.priceLabel.text] + 10 * kMulriple, 13 * kHMulriple, 40 * kMulriple, 20 * kHMulriple);
            NSString *subStr = [NSString stringWithFormat:@"%.2f", c];
            self.managerView.priceLittleLabel.text = [subStr substringWithRange:NSMakeRange(2, 2)];
            
        } else {
            self.managerView.priceLabel.text = @"￥0.";
            self.managerView.priceLittleLabel.text = @"00";
            self.managerView.priceLabel.frame = CGRectMake(10 * kMulriple, 5 * kHMulriple, 50 * kMulriple, 30 * kHMulriple);
            self.managerView.priceLittleLabel.frame = CGRectMake(55 * kMulriple, 12.5 * kHMulriple, 40 * kMulriple, 20 * kHMulriple);
            
        }
        
        if ([model.countTodayOrders integerValue] > 0) {
            
            self.managerView.acountLabel.text = [NSString stringWithFormat:@"%@", model.countTodayOrders];

        } else {
            
            self.managerView.acountLabel.text = @"0";
        }
    
    
}


#pragma mark -跳转到个人设置页面
- (void)setUpBtnAction:(UIButton *)sender {
    PersonalSetUpController *personVC = [[PersonalSetUpController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"个人设置";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark -跳转到系统消息页面
- (void)messageBtnAction:(UIButton *)sender {
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"系统消息";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:newsVC animated:YES];
}



#pragma mark -跳转到今日订单页面
- (void)listBtnAction:(UIButton *)sender {
    
    TodayListController *listVC = [[TodayListController alloc] init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"今日订单";
    self.navigationItem.backBarButtonItem = backItem;

    [self.navigationController pushViewController:listVC animated:YES];
    
}


#pragma mark -第一行按钮点击事件
- (void)firstLineBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1000:{
            
            CaiWuDuiZhangController *caiWuVC = [[CaiWuDuiZhangController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"财务对账";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:caiWuVC animated:YES];
            
        }
            break;
        case 1001: {
            DrawMoneyController *drawVC = [[DrawMoneyController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"收入提现";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:drawVC animated:YES];
        }
            break;
        case 1002:{
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
        case 2000:{
            ManagerProductController *managerVC = [[ManagerProductController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"商品管理";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:managerVC animated:YES];
        }
            break;
        case 2001: {
            UserCommentController *commentVC = [[UserCommentController alloc] init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"用户评价";
            self.navigationItem.backBarButtonItem = backItem;

            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
            
        case 2002: {
            
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -第三行按钮点击事件
- (void)loginoutBtnAction:(UIButton *)sender {
    
    
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

- (void)loginoutHandle {
    

    [self.managerView.photoImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.managerView.nameLabel.text = @"";
    
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
