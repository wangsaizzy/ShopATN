//
//  ShopInformationController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/4.
//  Copyright © 2016年 吴明飞. All rights reserved.
//
#define KMaxNameLength 16
#define kMaxPhoneLength 12
#import "ShopInformationController.h"
#import "ShopInformationView.h"
#import "ShopInformationModel.h"
#import "ShopPicturesController.h"
#import "ShopCategoryController.h"
#import "CityListController.h"
#import "MapKitController.h"
#import "POIAnnotation.h"
#import "CategoryNextModel.h"
#import "DropDownMenu.h"
#import "LDActionSheet.h"
#import "LDImagePicker.h"
#import "ManagerModel.h"
@interface ShopInformationController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, LDActionSheetDelegate, LDImagePickerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) ShopInformationView *shopView;

@property (nonatomic, assign) BOOL isHeadImage;
@property (nonatomic, assign) BOOL isShowListImge;
@property (nonatomic, assign) BOOL isBannerImage;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) POIAnnotation *annotation;

@property (nonatomic, strong) NSString *cityIdStr;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, strong) CategoryNextModel *model;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@end




@implementation ShopInformationController
{
    
    NSArray *_imageArr;
    NSInteger _imageIndex;
    
    BOOL _isChangeImage;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:RGB(94, 94, 94)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self customNaviBar];
    //自定义view
    [self setupViews];
    
    [self requestData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"ChangeAlbumsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"DeleteAlbumsSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_shopView.shopNameTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_shopView.phoneTF];
}



- (void)endEditing
{
    [self.view endEditing:YES];
    
}

- (void)setupViews {
    
    self.shopView = [[ShopInformationView alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple, kWight, kHeight)];

    [self.view addSubview:self.shopView];
    

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

    
    //横幅按钮点击事件
    [_shopView.shopBannerBtn addTarget:self action:@selector(shopBannerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //开关控件点击事件
    [self.shopView.stateSwitch addTarget:self action:@selector(stateSwitchValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    //头像按钮点击事件
    [self.shopView.headImageViewBtn addTarget:self action:@selector(headImageViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //店铺分类选择按钮
    [self.shopView.chooseCategoryBtn addTarget:self action:@selector(chooseCategoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //列表展示图按钮
    [self.shopView.showListBtn addTarget:self action:@selector(showListBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //环境展示图按钮
    [self.shopView.showEnvironmentBtn addTarget:self action:@selector(showEnvironmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shopView.mapBtn addTarget:self action:@selector(mapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)requestData {
    
    WS(weakself);
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中"];
    [HttpHelper requestUrl:KUserinfor_url success:^(id json) {

        [SVProgressHUD dismiss];
        NSDictionary *shopDic = json[@"data"][@"shop"];
        [weakself refreshData:shopDic];
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)refreshData:(NSDictionary *)dic {
    
    ManagerModel *model = [[ManagerModel alloc] initWithDic:dic];
    
    if ([model.status isEqualToString:@"OPEN"]) {
        
        _shopView.shopStateLabel.text = @"营业中";
        [_shopView.stateSwitch setOn:YES animated:YES];
    }
    if ([model.status isEqualToString:@"CLOSE"]) {
        
        _shopView.shopStateLabel.text = @"暂停营业";
        [_shopView.stateSwitch setOn:NO animated:YES];
    }
    
    
    
    NSURL *headImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.portraitUrl]];
    
    [self.shopView.shopHeadImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"headImage"]];
    
    NSURL *listImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.thumbnailUrl]];
    [self.shopView.shopListImageView sd_setImageWithURL:listImageUrl placeholderImage:[UIImage imageNamed:@"list"]];
    
    NSURL *bannerImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.bannerUrl]];
    [self.shopView.shopBannerImageView sd_setImageWithURL:bannerImageUrl placeholderImage:[UIImage imageNamed:@"banner"]];
    
    _shopView.shopNameTF.text = [NSString stringWithFormat:@" %@", model.name];
    
    
    _shopView.detailAddressTV.text = model.address;
    
    _shopView.phoneTF.text = [NSString stringWithFormat:@" %@", model.phone];
    
    

    NSNumber *backRate = model.backRate;
    float backRateCount = [backRate floatValue];
    int backRateNum = 100 * backRateCount;
    _shopView.discountLabel.text = [NSString stringWithFormat:@" %d%%折扣",backRateNum];
    
    _shopView.chooseCategoryLabel.text = [NSString stringWithFormat:@"%@-%@", model.categoryName, model.categoryNextName];
    
    self.imageArr = model.album;
    
    self.longitude = model.longitude;
    
    self.latitude = model.latitude;
    
    [UserModel defaultModel].longitude = model.longitude;
    
    [UserModel defaultModel].latitude = model.latitude;
    
    
}




#pragma mark -更改按钮方法
- (void)alertBtnAction:(UIButton *)sender {
    
    
    if (_shopView.detailAddressTV.text.length == 0) {
        ShowAlertView(@"请输入店铺地址");
        return;
    }
    if (_shopView.chooseCategoryLabel.text.length == 0) {
        ShowAlertView(@"请选择店铺分类");
        return;
    }
    if (_shopView.phoneTF.text.length == 0) {
        ShowAlertView(@"请输入电话号码");
        return;
    }
    
    // 更新资料
    [self startUpDataUserInfo];
    
}



//字典转字符串
- (NSString *)setDictionaryToString:(NSDictionary *)dic {
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [dic keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[dic valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}


//上传头像图片
- (void)uploadImageWithUrl:(NSString *)url image:(UIImage *)image {
    
    [HttpHelper uploadFileWithMethod:@"PUT" URL:url name:@"image" fileName:@"image.jpg" param:nil image:image success:^(id json) {
        
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"上传失败"];
    } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
}



//上传商家资料
- (void)startUpDataUserInfo {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
       
    NSString *longitude = [NSString stringWithFormat:@"%.2f", [self.annotation coordinate].longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.2f", [self.annotation coordinate].latitude];
    [dict setObject:longitude forKey:@"longitude"];
    [dict setObject:latitude forKey:@"latitude"];
    [dict setObject:_shopView.detailAddressTV.text forKey:@"address"];
    [dict setObject:@"YES" forKey:@"subscribeAble"];
    
    if ([self.annotation adcode]) {
        [dict setObject:[self.annotation adcode] forKey:@"area"];
    }
    
    if (self.model.id) {
        
        [dict setObject:self.model.id forKey:@"category"];
    }
    
    NSString *phoneStr = [_shopView.phoneTF.text substringFromIndex:1];
    [dict setObject:phoneStr forKey:@"phone"];
    
    if (self.status) {
        
       [dict setObject:self.status forKey:@"status"];
    }
    
    
    [dict setObject:_shopView.shopNameTF.text forKey:@"name"];
    
    WS(weakself);
    
    NSString *urlString =[NSString stringWithFormat: @"/shop/shop/%@", [AccountTool unarchiveShopId]];
    
    [SVProgressHUD showWithStatus:@"保存中"];
    
    [HttpHelper requestMethod:@"PUT" urlStr:urlString parma:dict success:^(id json) {
           
            
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            
            
        [weakself.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeSuccess" object:nil];
            
                    
                    
        
            
        } failure:^(NSError *error) {
            
        }];
    
}


- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -开关方法
- (void)stateSwitchValueChangedAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        
        self.status = @"OPEN";
    } else {
        
        self.status = @"CLOSE";
    }
}

#pragma mark -头像
- (void)headImageViewBtnAction:(UIButton *)sender {
    
    _isHeadImage = YES;
    _isShowListImge = NO;
    
    [self upLoadPhotosFromCameraOrGraph];
}

- (void)shopBannerBtnAction:(UIButton *)sender {
    
    LDActionSheet *actionSheet = [[LDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(LDActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    LDImagePicker *picker = [LDImagePicker sharedInstance];
    
    picker.delegate = self;
    [picker showImagePickerWithType:buttonIndex InViewController:self Scale:0.2];
    
}

- (void)imagePicker:(LDImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    self.shopView.shopBannerImageView.image = editedImage;
    NSString *urlStringBanner = [NSString stringWithFormat:@"/shop/shop/%@/banner", [AccountTool unarchiveShopId]];
    //更新横幅
    [self uploadImageWithUrl:urlStringBanner image:_shopView.shopBannerImageView.image];
    
}

- (void)imagePickerDidCancel:(LDImagePicker *)imagePicker{
    
}

- (void)mapBtnAction:(UIButton *)sender {
    
    MapKitController *mapVC = [[MapKitController alloc] init];
    
    
    mapVC.longitude = self.longitude;
    mapVC.latitude = self.latitude;
    
    
    WS(weakself);
    mapVC.ChangePOIAnnotation = ^(POIAnnotation *annotaiton) {
        
        self.annotation = annotaiton;
        weakself.shopView.detailAddressTV.text = [NSString stringWithFormat:@"%@%@", [annotaiton subtitle], [annotaiton title]];
        
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}


#pragma mark -店铺分类
- (void)chooseCategoryBtnAction:(UIButton *)sender {

    WS(weakself);
    ShopCategoryController *categoryVC = [[ShopCategoryController alloc] init];
    categoryVC.ChangeCategory = ^(CategoryNextModel *model) {
        
        weakself.model = model;
        weakself.shopView.chooseCategoryLabel.text = [NSString stringWithFormat:@"%@-%@", model.parentName, model.name];
    };
    [self.navigationController pushViewController:categoryVC animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.shopView.shopNameTF resignFirstResponder];
    [self.shopView.phoneTF resignFirstResponder];
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
    
    //更改按钮
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(330 * kMulriple, 25 * kHMulriple, 40 * kMulriple, 30 * kMulriple);
    [alertBtn setTitle:@"更改" forState:UIControlStateNormal];
    [alertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alertBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    [alertBtn addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:alertBtn];
    
    [self.view addSubview:naviView];
    
    
    
}

#pragma mark -列表展示图片
- (void)showListBtnAction:(UIButton *)sender {
    
    _isShowListImge = YES;
    _isHeadImage = NO;
    
    [self upLoadPhotosFromCameraOrGraph];
}

#pragma mark -环境展示图片
- (void)showEnvironmentBtnAction:(UIButton *)sender {
    
    ShopPicturesController *pictureVC = [[ShopPicturesController alloc] init];
    
    pictureVC.imageSourceArr = self.imageArr;
    
    [self.navigationController pushViewController:pictureVC animated:YES];
}



- (void)upLoadPhotosFromCameraOrGraph {
    
    WS(weakself)
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0: {
                //打开相机
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = weakself;
                    imagePicker.allowsEditing = YES;//可编辑
                    imagePicker.sourceType = sourceType;
                    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [weakself presentViewController:imagePicker animated:YES completion:nil];
                }
            }
                break;
            case 1:{
                //打开本地相册
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = weakself;
                [weakself presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
        }
    }];
    
}

- (UIImage *)imageFromView: (UIView *)theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

#pragma mark - UIImagePickerViewControllerDelegate
// 添加图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (_isHeadImage) {
        _shopView.shopHeadImageView.image = image;
        NSString *urlStringHead = [NSString stringWithFormat:@"/shop/shop/%@/portrait",  [AccountTool unarchiveShopId]];
        //更新头像
        [self uploadImageWithUrl:urlStringHead image:_shopView.shopHeadImageView.image];
        _isHeadImage = YES;
        
    }
    if (_isShowListImge) {
        _shopView.shopListImageView.image = image;
        NSString *urlStringList = [NSString stringWithFormat:@"/shop/shop/%@/thumbnail", [AccountTool unarchiveShopId]];
        
        //更新列表展示图
        [self uploadImageWithUrl:urlStringList image:_shopView.shopListImageView.image];
        _isShowListImge = YES;
        
    }
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    _imagePicker = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.shopView.shopNameTF resignFirstResponder];
    [self.shopView.phoneTF resignFirstResponder];
    [self.shopView.detailAddressTV resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *nameStr = [_shopView.shopNameTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *phoneStr = [_shopView.phoneTF.text stringByReplacingCharactersInRange:range withString:string];
    if (nameStr.length > KMaxNameLength && range.length!=1){
        _shopView.shopNameTF.text = [nameStr substringToIndex:KMaxNameLength];
        
        return NO;
        
    }
    if (phoneStr.length > kMaxPhoneLength && range.length != 1) {
        
        _shopView.phoneTF.text = [phoneStr substringToIndex:kMaxPhoneLength];
        return NO;
    }
    return YES;
}

- (void)nameTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _shopView.shopNameTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxNameLength) {
                textField.text = [toBeString substringToIndex:KMaxNameLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxNameLength) {
            textField.text = [toBeString substringToIndex:KMaxNameLength];
        }
    }
}

- (void)phoneTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _shopView.phoneTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxPhoneLength) {
                textField.text = [toBeString substringToIndex:kMaxPhoneLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxPhoneLength) {
            textField.text = [toBeString substringToIndex:kMaxPhoneLength];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeAlbumsSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteAlbumsSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_shopView.shopNameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_shopView.phoneTF];
}



@end
