//
//  ShopPicturesController.m
//  ATN
//
//  Created by 吴明飞 on 16/5/28.
//  Copyright © 2016年 王赛. All rights reserved.
//

#import "ShopPicturesController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIButton+WebCache.h"
#import "ShopInformationModel.h"
#import "ManagerModel.h"
@interface ShopPicturesController ()<ZLPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *pickPhotos;
@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, strong) NSMutableArray *idNumArr;
@end

@implementation ShopPicturesController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
   
    
    
}

- (void)refreshData {

    NSMutableArray *urls = [[NSMutableArray alloc] init];

    //NSArray *albumArr = [UserModel defaultModel].albumArr;
    for (NSDictionary *dic in self.imageSourceArr) {
        
        NSString *albumImageUrl = dic[@"url"];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", Service_Url, albumImageUrl];
        NSNumber *albumId = dic[@"id"];
        [urls addObject:urlString];
        [self.photosArr addObject:albumImageUrl];
        [self.idNumArr addObject:albumId];
        
    }
   
    
    _photos = [NSMutableArray arrayWithCapacity:urls.count];
    for (NSString *url in urls) {
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:url];
        [_photos addObject:photo];
    }

    _assets = _photos.mutableCopy;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.photosArr = [NSMutableArray arrayWithCapacity:8];
    self.idNumArr = [NSMutableArray arrayWithCapacity:8];
    [self customNaviBar];
    
    [self setupViews];
}




- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customNaviBar {
    //自定义导航栏
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 64 * kHMulriple)];
    naviView.backgroundColor = RGB(83, 83, 83);
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 25 * kHMulriple, 80 * kMulriple, 30 * kHMulriple);
    
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * kMulriple, 2.5 * kHMulriple, 15 * kMulriple, 25 * kHMulriple)];
    arrowImage.image = [UIImage imageNamed:@"arrowImage"];
    [backBtn addSubview:arrowImage];

    [naviView addSubview:backBtn];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(137 * kMulriple, 20 * kHMulriple, 100 * kMulriple, 40 * kHMulriple)];
    textLabel.text = @"店铺信息";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    textLabel.centerX = naviView.width / 2;
    
    [naviView addSubview:textLabel];
    
    //搜索按钮
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(330 * kMulriple, 25 * kHMulriple, 40 * kMulriple, 30 * kMulriple);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    [commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:commitBtn];
    
    [self.view addSubview:naviView];
    
    
}


- (void)setupViews {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 69 * kHMulriple, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
    
    [self refreshData];
    // 属性scrollView
    [self reloadScrollView];

}


- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 4;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col + 2 * kMulriple, row * width, width - 4 * kMulriple, width - 3 * kHMulriple);
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            [btn setBackgroundImage:[UIImage imageNamed:@"showListImage"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(photoSelecte) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            ZLPhotoPickerBrowserPhoto *photo = [self.assets objectAtIndex:i];
            
            if (photo != nil && [photo.asset isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[photo.asset thumbImage] forState:UIControlStateNormal];
            }else{
                ZLPhotoPickerBrowserPhoto *photo = self.assets[i];
                [btn sd_setImageWithURL:photo.photoURL forState:UIControlStateNormal];
            }
            photo.toView = btn.imageView;
            btn.tag = i;
            [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
}

- (void)commitBtnAction:(UIButton *)sender {
    
    NSMutableArray *imageDataArr = [[NSMutableArray alloc] init];
    
    
    for (ZLPhotoPickerBrowserPhoto *photo in self.pickPhotos) {
        
        [imageDataArr addObject:[photo.asset thumbImage]];
    }
    WS(weakself);
    [HttpHelper uploadManyFile:imageDataArr Success:^(NSArray *success) {
        
    
        [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeAlbumsSuccess" object:nil];
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - 选择图片
- (void)photoSelecte{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.maxCount = 10-self.photos.count;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    // CallBack
    __weak typeof(self)weakSelf = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        self.pickPhotos = [NSMutableArray arrayWithCapacity:status.count];
        for (ZLPhotoAssets *assets in status) {
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:assets];
            photo.asset = assets;
            [self.pickPhotos addObject:photo];
        }
        
        weakSelf.assets = [NSMutableArray arrayWithArray:weakSelf.photos];
        [weakSelf.assets addObjectsFromArray:self.pickPhotos];
        [weakSelf reloadScrollView];
    };
    [pickerVc showPickerVc:self];
}

- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.assets;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
   
   
    if (self.assets.count > index) {
        
        if (self.photos.count > index) {
            dispatch_queue_t queue1 = dispatch_get_main_queue();
            
            NSString *urlString = [NSString stringWithFormat:@"/shop/shop/%@/album/%@",[AccountTool unarchiveShopId], self.idNumArr[index]];

            [HttpHelper requestMethod:@"DELETE" urlString:urlString parma:nil success:^(id json) {
                
                
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                dispatch_sync(queue1, ^{
                    
                    [self.assets removeObjectAtIndex:index];
                    [self.photos removeObjectAtIndex:index];
                    [self.idNumArr removeObjectAtIndex:index];
                    [self reloadScrollView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteAlbumsSuccess" object:nil];
                    
                });
                
                
            } failure:^(NSError *error) {
                
            }];
            
        }  else if (self.photos.count == 0) {
            [self.assets removeObjectAtIndex:index];
            [self.pickPhotos removeObjectAtIndex:index];
            [self reloadScrollView];
        } else if (self.assets.count > self.photos.count) {
            
            [self.assets removeObjectAtIndex:index];
            NSInteger indexOf = index - self.photos.count;
            [self.pickPhotos removeObjectAtIndex:indexOf];
            [self reloadScrollView];
        }
        
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


@end
