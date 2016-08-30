//
//  AddGoodsController.m
//  ATN
//
//  Created by 吴明飞 on 16/5/7.
//  Copyright © 2016年 王赛. All rights reserved.
//
#define kMaxGoodsNameLength 16
#define KMaxGoodsPriceLength 6
#import "AddGoodsController.h"
#import "AddGoodsView.h"
#import "GoodsModel.h"
@interface AddGoodsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AddGoodsView *goodsView;

@end

@implementation AddGoodsController

{
    
    BOOL _isChange;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:RGB(94, 94, 94)};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义视图
    [self setupViews];
    //添加导航按钮
    [self customNaviBar];
    
    //获取数据
    [self requestData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_goodsView.goodsNameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(priceTFEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_goodsView.goodsPriceTF];
}

- (void)setupViews {
    self.title = @"添加商品";
    self.goodsView = [[AddGoodsView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.goodsView];
    //商品图片添加按钮点击事件
    [_goodsView.goodsImageBtn addTarget:self action:@selector(goodsImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    textLabel.text = @"添加商品";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
    textLabel.centerX = naviView.width / 2;
    //搜索按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(330 * kMulriple, 25 * kHMulriple, 40 * kMulriple, 30 * kMulriple);
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:17 * kMulriple];
    [addBtn addTarget:self action:@selector(submitInformationAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:addBtn];
    
    [self.view addSubview:naviView];
    
    [naviView addSubview:textLabel];

}

- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestData {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Service_Url, self.model.img[@"portrait"][@"url"]]];
    [_goodsView.goodsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"list"]];
    _goodsView.goodsNameTF.text = self.model.name;
    _goodsView.goodsPriceTF.text = self.model.price;
    _isChange = YES;
    
}

#pragma mark -提交商品信息
- (void)submitInformationAction:(UIButton *)sender {
    
    if (_goodsView.goodsImageView.image == nil) {
        ShowAlertView(@"请选择图片");
        return;
    }
    if (_goodsView.goodsNameTF.text.length == 0) {
        ShowAlertView(@"请输入商品名称");
        return;
    }
    if (_goodsView.goodsPriceTF.text.length == 0) {
        ShowAlertView(@"请填写价格");
        return;
    }
    
    if (self.isSubmit) {
        
        [self addGoods];
        
        
    } else if (_isChange) {
        
        [self alertGoods];
        
    }
    
}

//新增商品
- (void)addGoods{
        
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_goodsView.goodsNameTF.text forKey:@"name"];
    [dict setObject:_goodsView.goodsPriceTF.text forKey:@"price"];
    
    
    [SVProgressHUD showWithStatus:@"添加中..."];
    WS(weakself);
    [HttpHelper uploadFileWithMethod:@"POST" URL:KAddGoods_url name:@"portrait" fileName:@"image.jpg" param:dict image:_goodsView.goodsImageView.image success:^(id json) {
    
                
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddGoodsSuccess" object:nil];
        
    } failure:^(NSError *error) {
        
        
        
    } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    
}

//修改商品
- (void)alertGoods {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_goodsView.goodsNameTF.text forKey:@"name"];
    [dict setObject:_goodsView.goodsPriceTF.text forKey:@"price"];
   
    NSString *urlString = [NSString stringWithFormat:@"/shop/product/%@", self.model.id];
   
    [SVProgressHUD showWithStatus:@"修改中"];
    WS(weakself);
    [HttpHelper uploadFileWithMethod:@"PUT" URL:urlString name:@"portrait" fileName:@"image.jpg" param:dict image:_goodsView.goodsImageView.image success:^(id json) {
        
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertGoodsSuccess" object:nil];
       
    } failure:^(NSError *error) {
        
        if (error) {
            
            [SVProgressHUD showInfoWithStatus:@"修改失败"];
        }

       
        
    } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

#pragma mark -商品图片
- (void)goodsImageBtnAction:(UIButton *)sender {
    
    [self.goodsView.goodsNameTF resignFirstResponder];
    [self.goodsView.goodsPriceTF resignFirstResponder];
    
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
                    [weakself presentViewController:imagePicker animated:YES completion:nil];
                }
            }
                break;
            case 1:{
                //打开本地相册
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate = weakself;
               
                [weakself presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
        }
    }];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _goodsView.goodsImageView.image = image;
    
}


#pragma mark -UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *nameStr = [_goodsView.goodsNameTF.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *priceStr = [_goodsView.goodsPriceTF.text stringByReplacingCharactersInRange:range withString:string];
    
   
    if (nameStr.length > kMaxGoodsNameLength && range.length!=1){
        _goodsView.goodsNameTF.text = [nameStr substringToIndex:kMaxGoodsNameLength];
        
        return NO;
        
    }
    if (priceStr.length > KMaxGoodsPriceLength && range.length != 1) {
        
        _goodsView.goodsPriceTF.text = [priceStr substringToIndex:KMaxGoodsPriceLength];
        return NO;
    }
    
    
    return YES;
}

- (void)nameTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _goodsView.goodsNameTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxGoodsNameLength) {
                textField.text = [toBeString substringToIndex:kMaxGoodsNameLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxGoodsNameLength) {
            textField.text = [toBeString substringToIndex:kMaxGoodsNameLength];
        }
    }
}

- (void)priceTFEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = _goodsView.goodsPriceTF.text;
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > KMaxGoodsPriceLength) {
                textField.text = [toBeString substringToIndex:KMaxGoodsPriceLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > KMaxGoodsPriceLength) {
            textField.text = [toBeString substringToIndex:KMaxGoodsPriceLength];
        }
    }
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_goodsView.goodsNameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"
                                                 object:_goodsView.goodsPriceTF];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.goodsView.goodsNameTF resignFirstResponder];
    [self.goodsView.goodsPriceTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
