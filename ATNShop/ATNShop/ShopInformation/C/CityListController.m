//
//  CityListController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/5.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "CityListController.h"
#import "ChineseString.h"
#import "FMDatabase.h"
#import "CityModel.h"
@interface CityListController ()
@property (nonatomic, strong) FMDatabase *database;//数据库操作类
@property (nonatomic, strong) NSMutableArray *citySourceArr;
@property (nonatomic, strong) NSMutableArray *cityNameArr;
@property (nonatomic, strong) NSMutableArray *cityIdArr;
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) NSMutableArray *letterResultArr;
@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexArray = [NSMutableArray arrayWithCapacity:8];
    self.letterResultArr = [NSMutableArray arrayWithCapacity:8];
    self.citySourceArr = [NSMutableArray arrayWithCapacity:8];
    self.cityNameArr = [NSMutableArray arrayWithCapacity:8];
//    NSString *timeout = [NSString stringWithFormat:@"%@", [UserModel defaultModel].timeout];
//    if (timeout.length == 0) {
//        
//        [self requestData];
//    } else {
//        
//        [self requestMoreData];
//    }
    
    //创建数据库
    [self createDataBase];
    
    //创建表
    [self createTable];
    
    //读取数据
    [self selectDataFromDataBase];
}

- (void)createDataBase {
    
    //数据库操作对象
    self.database = [FMDatabase databaseWithPath:[self getFilePath]];
    NSLog(@"%@", [self getFilePath]);
}

- (void)createTable {
    
    if (![self.database open]) {
        return;
    }
    
    [self.database executeUpdate:@"create table if not exists CityModel (city_id integer primary key autoincrement, city_cityId text, city_name text, city_longitude text, city_latitude text, city_updatetime text)"];

    //3.关闭数据库
    [self.database close];
}

- (void)selectDataFromDataBase {
    
    //1.打开数据库
    if (![self.database open]) {
        return;
    }
    //2.通过SQL语句执行查询操作
    FMResultSet *result = [self.database executeQuery:@"select * from CityModel"];
    while ([result next]) {
        NSString *cityID  = [result stringForColumn:@"city_cityId"];
        NSString *name = [result stringForColumn:@"city_name"];
        NSString *longitude = [result stringForColumn:@"city_longitude"];
        NSString *latitude = [result stringForColumn:@"city_latitude"];
        NSString *updatetime = [result stringForColumn:@"city_updatetime"];
       
        //把数据封装到对象里
        CityModel *model = [[CityModel alloc] initWithName:name cityId:cityID longitude:longitude latitude:latitude updatetime:updatetime];
        //存放到数组中
        [self.citySourceArr addObject:model];
        [self.cityNameArr addObject:model.name];
    }

    NSArray *cityArr = self.cityNameArr;
    
    self.indexArray = [ChineseString IndexArray:cityArr];
    self.letterResultArr = [ChineseString LetterSortArray:cityArr];
    
    NSLog(@"=================%ld", self.citySourceArr.count);
    //3.关闭数据库
    [self.database close];

}

//插入一条数据
- (void)insertIntoDataBaseWithModel:(CityModel *)model{
    //1.打开数据库
    if (![self.database open]) {
        return;
    }
    //2.通过SQL语句操作数据库(即插入一条数据)
    [self.database executeUpdate:@"insert into CityModel(city_cityId, city_name, city_longitude, city_latitude, city_updatetime) values(?, ?, ?, ?, ?)", model.cityId, model.name, model.longitude, model.latitude, model.updatetime];
    //3.关闭数据库
    [self.database close];
}


//删除一条数据
- (void)deleteFromDataBaseWithModel:(CityModel *)model{
    //1.打开数据库
    BOOL isOpen = [self.database open];
    //2.执行SQL语句操作数据库 -- 删除操作
    if (!isOpen) {
        return;
    }
    [self.database executeUpdate:@"delete from CityModel where city_cityId = ?", model.cityId];
    //3.关闭数据库
    [self.database close];
}


- (void)requestData {
    
    NSString *urlString =@"http://123.56.77.171/app/user/area";
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD show];
    NSURL *url = [NSURL URLWithString:urlStr];
    [SVProgressHUD show];
    NSMutableURLRequest  *request = [NSMutableURLRequest requestWithURL:url];
    NSString *value = [NSString stringWithFormat:@"%@", [UserModel defaultModel].token];
    [request addValue:value forHTTPHeaderField:@"Authorization"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        [self parseDataWithData:data];
        [SVProgressHUD dismiss];
        
    }];
    
}

//解析数据 添加到数据源
- (void)parseDataWithData:(NSData *)data{
    
    WS(weakself);

    //使用系统JSON解析方式进行解析
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict);
   
    NSArray *dataArr = dict[@"data"];
    
    NSMutableArray *updatetimeArr = [NSMutableArray arrayWithCapacity:6];
    
    for (NSDictionary *dic in dataArr) {
        
        CityModel *model = [[CityModel alloc] initWithName:dic[@"name"] cityId:dic[@"id"] longitude:dic[@"longitude"] latitude:dic[@"latitude"] updatetime:dic[@"updatetime"]];
        

        [weakself insertIntoDataBaseWithModel:model];
        
        //获取时间戳，并加入数组
        NSTimeInterval _interval=[dic[@"updatetime"] doubleValue] / 1000.0;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [objDateformat stringFromDate:date];
        
        [updatetimeArr addObject:dateString];
    }
    
    //对数组进行升序排序
    NSArray *updateSourceArr = updatetimeArr;
    
    NSArray *sortUpdatetimeArr = [updateSourceArr sortedArrayUsingSelector:@selector(compare:)];
    //取得排序之后最晚的那个时间
    //[UserModel defaultModel].timeout = [sortUpdatetimeArr lastObject];
    NSLog(@"%@", sortUpdatetimeArr);

    [self.tableView reloadData];

}



- (void)requestMoreData {
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //NSString *updatetime = [NSString stringWithFormat:@"%@", [UserModel defaultModel].timeout];
   // [dict setObject:updatetime forKey:@"updatetime"];
    
    NSLog(@"%@", dict);
    
    NSString *urlString =@"/user/area";
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [SVProgressHUD show];
    WS(weakself);
    
    
    [HttpHelper requestMethod:@"GET" urlString:urlString parma:dict success:^(id json) {
        
        if ([json[@"message"] isEqualToString:@"成功"]) {
            NSLog(@"%@", json);
            NSArray *dataArr = json[@"data"];
            
            //创建新的可变数组，用来加入时间戳
            NSMutableArray *newUpdatetimeArr = [NSMutableArray arrayWithCapacity:8];
            
            for (NSDictionary *dic in dataArr) {
                
            
                CityModel *model = [[CityModel alloc] initWithName:dic[@"name"] cityId:dic[@"id"] longitude:dic[@"longitude"] latitude:dic[@"latitude"] updatetime:dic[@"updatetime"]];
                
                //先删除
                [weakself deleteFromDataBaseWithModel:model];
                
                //更新数据库
                [weakself insertIntoDataBaseWithModel:model];
                //获取时间戳，加入数组
                NSTimeInterval _interval=[dic[@"updatetime"] doubleValue] / 1000.0;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
                [objDateformat setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [objDateformat stringFromDate:date];
                
                [newUpdatetimeArr addObject:dateString];
                [SVProgressHUD dismiss];
                
            }
            
            //对数组进行升序排序
            NSArray *updateSourceArr = newUpdatetimeArr;
            
            NSArray *sortUpdatetimeArr = [updateSourceArr sortedArrayUsingSelector:@selector(compare:)];
            //取得排序之后最晚的那个时间
            //[UserModel defaultModel].timeout = [sortUpdatetimeArr lastObject];
            NSLog(@"%@", sortUpdatetimeArr);

            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
        
    }];

}

- (NSString *)getFilePath {
    
    //缓存文件夹的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //拼接上数据文件的路径
    
    return [path stringByAppendingPathComponent:@"DB.sqlite"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }

    
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -UITableview Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [UILabel new];
    lab.backgroundColor = RGB(238, 238, 238);
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = RGB(111, 111, 111);
    return lab;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    
    
    NSString *cityName = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
   
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
