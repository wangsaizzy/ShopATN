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
@interface ShopInformationController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,  UIGestureRecognizerDelegate>
@property (nonatomic, strong) ShopInformationView *shopView;

@property (nonatomic, assign) BOOL isHeadImage;
@property (nonatomic, assign) BOOL isPublicizeImage;


@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) POIAnnotation *annotation;

@property (nonatomic, strong) NSString *cityIdStr;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, strong) CategoryNextModel *model;


@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@end




@implementation ShopInformationController
{
    
    
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
    
    self.shopView = [[ShopInformationView alloc] initWithFrame:CGRectMake(0, 60 * kHMulriple, kWight, kHeight)];

    [self.view addSubview:self.shopView];
    

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

    
    
    //头像按钮点击事件
    [self.shopView.headImageViewBtn addTarget:self action:@selector(headImageViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shopView.publicizeImageBtn addTarget:self action:@selector(publicizeImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    
    NSURL *headImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, model.portraitUrl]];
    
    [self.shopView.shopHeadImageView sd_setImageWithURL:headImageUrl placeholderImage:[UIImage imageNamed:@"headImage"]];
    
    
    _shopView.shopNameTF.text = [NSString stringWithFormat:@" %@", model.name];
    
    
    
    if (model.address.length > 0) {
        
        _shopView.detailAddressTV.text = model.address;
        _shopView.detailAddressTV.placeholder = nil;
    }
    
    _shopView.phoneTF.text = [NSString stringWithFormat:@" %@", model.phone];
    

    NSNumber *backRate = model.backRate;
    float backRateCount = [backRate floatValue];
    int backRateNum = 100 * backRateCount;
    _shopView.discountTF.text = [NSString stringWithFormat:@" %d",backRateNum];
    

    self.longitude = model.longitude;
    
    self.latitude = model.latitude;
    
    [UserModel defaultModel].longitude = model.longitude;
    
    [UserModel defaultModel].latitude = model.latitude;
    
    
}




#pragma mark -更改按钮方法
- (void)alertBtnAction:(UIButton *)sender {
    
    if (_shopView.shopNameTF.text.length == 0) {
        
        ShowAlertView(@"请输入店铺名称");
        return;
    }
    
    if (_shopView.detailAddressTV.text.length == 0) {
        ShowAlertView(@"请输入店铺地址");
        return;
    }
    
    if (_shopView.descriptionTV.text.length == 0) {
        
        ShowAlertView(@"请输入店铺描述");
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
    [dict setObject:_shopView.shopNameTF.text forKey:@"name"];
       
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



#pragma mark -头像
- (void)headImageViewBtnAction:(UIButton *)sender {
    
    _isHeadImage = YES;
    _isPublicizeImage = NO;
    
    [self upLoadPhotosFromCameraOrGraph];
}

- (void)publicizeImageBtnAction:(UIButton *)sender {
    
    _isHeadImage = NO;
    _isPublicizeImage = YES;

    [self upLoadPhotosFromCameraOrGraph];
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




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.shopView.shopNameTF resignFirstResponder];
    [self.shopView.phoneTF resignFirstResponder];
}


- (void)customNaviBar {
    
    
    //自定义导航栏
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWight, 60 * kHMulriple)];
    naviView.backgroundColor = RGB(83, 83, 83);
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 25 * kHMulriple, 112 * kMulriple, 30 * kHMulriple);
    
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * kMulriple, 2.5 * kHMulriple, 12 * kMulriple, 19 * kHMulriple)];
    arrowImage.image = [UIImage imageNamed:@"arrowImage"];
    [backBtn addSubview:arrowImage];

    [naviView addSubview:backBtn];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * kMulriple, 0, 90 * kMulriple, 25 * kHMulriple)];
    textLabel.text = @"店铺信息";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:18 * kMulriple];
    
    [backBtn addSubview:textLabel];
    
    //更改按钮
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(330 * kMulriple, 27 * kHMulriple, 40 * kMulriple, 25 * kMulriple);
    [alertBtn setTitle:@"保存" forState:UIControlStateNormal];
    [alertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alertBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    [alertBtn addTarget:self action:@selector(alertBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:alertBtn];
    
    [self.view addSubview:naviView];
    
    
    
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
    
    if (_isPublicizeImage) {
        
        _shopView.publicizeImageView.image = image;
        
        NSString *urlStringBanner = [NSString stringWithFormat:@"/shop/shop/%@/banner", [AccountTool unarchiveShopId]];
        //更新横幅
        [self uploadImageWithUrl:urlStringBanner image:_shopView.publicizeImageView.image];

        
        _isPublicizeImage = YES;
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
