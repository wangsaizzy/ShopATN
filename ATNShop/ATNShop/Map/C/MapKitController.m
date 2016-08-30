//
//  MapKitController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/7.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "MapKitController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "POIAnnotation.h"
#import "AroundInformationCell.h"
#import "SearchResultView.h"
#import "AppDelegate.h"
typedef NS_ENUM(NSInteger, AMapPOISearchType)
{
    AMapPOISearchTypeKeywords,
    AMapPOISearchTypeAround,
};

@interface MapKitController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIApplicationDelegate>

@property (nonatomic, strong) SearchResultView *resultView;
@property (nonatomic) AMapPOISearchType poiSearchType;
@end

@implementation MapKitController

{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    UITableView *_tableView;
    NSMutableArray *_poiAnnotations;
    UITextField *_searchTF;
    NSMutableArray *_poiSearchAnnotations;
    NSString *_city;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义导航栏
    [self customNaviBar];
    //添加列表视图
    [self setupTableView];
    
    [self setupViews];
    
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}



//返回按钮
- (void)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self clearMapView];
    
    [self clearSearch];
}



- (void)setupTableView {
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 434 * kHMulriple, kWight, self.view.bounds.size.height - 429 * kHMulriple) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[AroundInformationCell class] forCellReuseIdentifier:@"AroundInformationCell"];
    
    }

- (void)setupViews {
    
    //_mapView = [self mapView];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple, CGRectGetWidth(self.view.bounds), 378 * kHMulriple)];
    //_mapView.frame = CGRectMake(0, 64 * kHMulriple, CGRectGetWidth(self.view.bounds), 378 * kHMulriple);
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    

    NSString *longitude = [NSString stringWithFormat:@"%@", self.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%@", self.latitude];
    
    if ([longitude floatValue] > 0 && [latitude floatValue] > 0) {
    
        _mapView.showsUserLocation = NO;    //YES 为打开定位，NO为关闭定位
        
        self.poiSearchType = AMapPOISearchTypeAround;
        
        [self searchPoiWithType:AMapPOISearchTypeAround];
        
    } else {
        
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        
        [_mapView setZoomLevel:16.1 animated:YES];
    }
}



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        
        self.poiSearchType = AMapPOISearchTypeAround;
        //取出当前位置的坐标
        
        //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
        request.sortrule = 0;
        request.requireExtension = YES;
        
        //发起周边搜索
        [_search AMapPOIAroundSearch: request];
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        
        
        [_mapView addAnnotation:pointAnnotation];
    }
}



#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    
    switch (self.poiSearchType)
    {
        case AMapPOISearchTypeKeywords:
        {
            _poiSearchAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
                
                POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:obj];
                [_poiSearchAnnotations addObject:annotation];
                
            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.resultView = [[SearchResultView alloc] initWithFrame:CGRectMake(0, 64 * kHMulriple, kWight, kHeight - 64 * kHMulriple)];
                
                ;
                [self.view addSubview:self.resultView];
                self.resultView.dataSource = _poiSearchAnnotations;
                
            }];
            

            __weak typeof(self)weakSelf = self;
            [self.resultView setFinishBlock:^(POIAnnotation *annotation){
                weakSelf.ChangePOIAnnotation(annotation);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];

        }
            break;
    
        case AMapPOISearchTypeAround:
        {
            _poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
                
                POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:obj];
                [_poiAnnotations addObject:annotation];
                
                
            }];
            

            
            [_tableView reloadData];
        }
            break;
        
    }

    
    
    
    
}

- (void)searchPoiWithType:(AMapPOISearchType)searchType
{
    /* 清除存在的annotation. */
    [_mapView removeAnnotations:_mapView.annotations];
    
    switch (searchType)
    {
        case AMapPOISearchTypeKeywords:
        {
            [self searchPoiByKeyword];
            
            break;
        };
        case AMapPOISearchTypeAround:
        {
            [self searchPoiByCenterCoordinate];
            
            break;
        }
    }
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    NSString *longitude = [NSString stringWithFormat:@"%@", self.longitude];

    NSString *latitude = [NSString stringWithFormat:@"%@", self.latitude];
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    request.types =  @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    
    [_mapView addAnnotation:pointAnnotation];
}

/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword
{

    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = _searchTF.text;
    //request.city                = _city;
    request.types               =  @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.requireExtension    = YES;
    
    
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [_search AMapPOIKeywordsSearch:request];

}


- (void)clearMapView
{
     _mapView.showsUserLocation = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView removeOverlays:_mapView.overlays];
    
    _mapView.delegate = nil;
}

- (void)clearSearch
{
    _search.delegate = nil;
}

#pragma mark - 搜索
- (void)cancleBtnAction:(UIButton *)sender {
   
    [self.resultView removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -UITableViewDataSource && UITableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _poiAnnotations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75 * kHMulriple;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AroundInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AroundInformationCell" forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[AroundInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AroundInformationCell"];
    }
    
    POIAnnotation *annotation = _poiAnnotations[indexPath.row];
    NSString *titleStr = [annotation title];
    NSString *subtitleStr = [annotation subtitle];
    
    _city = [annotation district];
    
    cell.titleLabel.text = titleStr;
    cell.subtitleLabel.text = subtitleStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    POIAnnotation *annotation = _poiAnnotations[indexPath.row];
    self.ChangePOIAnnotation(annotation);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customNaviBar {
    self.view.backgroundColor = RGB(238, 238, 238);
    
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
    
    //搜索框
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(70 * kMulriple, 22 * kHMulriple, 240 * kMulriple, 36 * kHMulriple)];
    _searchTF.placeholder = @" 输入关键字";
    _searchTF.delegate = self;
    _searchTF.font = [UIFont systemFontOfSize:17 * kMulriple];
    [_searchTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchTF.textColor = [UIColor whiteColor];
    _searchTF.layer.borderWidth = 1.5 * kMulriple;
    _searchTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _searchTF.layer.cornerRadius = 18 * kMulriple;
    _searchTF.layer.masksToBounds = YES;
    _searchTF.returnKeyType = UIReturnKeySearch;//更改键盘的return
    _searchTF.tintColor = [UIColor whiteColor];
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10 * kMulriple,0,10 * kMulriple,26 * kHMulriple)];
    leftView.backgroundColor = [UIColor clearColor];
    _searchTF.leftView = leftView;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
//    //按钮
//    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    cancleBtn.frame = CGRectMake(310 * kMulriple, 25 * kHMulriple, 40 * kMulriple, 30 * kMulriple);
//    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:20 * kMulriple];
//    [cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [naviView addSubview:cancleBtn];
    [naviView addSubview:_searchTF];
    
    [self.view addSubview:naviView];

}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //开始编辑时触发，文本字段将成为first responder
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_searchTF.text.length == 0) {
        
       
    }
    self.poiSearchType = AMapPOISearchTypeKeywords;
    [self searchPoiWithType:AMapPOISearchTypeKeywords];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.resultView removeFromSuperview];
    [_searchTF resignFirstResponder];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTF resignFirstResponder];
    return YES;
}


@end
