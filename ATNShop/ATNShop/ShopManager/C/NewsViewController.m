//
//  NewsViewController.m
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/6/27.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import "NewsViewController.h"
#import "FMDatabase.h"
#import "NewsCell.h"
#import "NewsModel.h"


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FMDatabase *database;//数据库操作类
@property (nonatomic, strong) NSMutableArray *dataSourceArr;


@end

@implementation NewsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArr = [NSMutableArray arrayWithCapacity:8];
    [self customNaviBar];
    self.view.backgroundColor = RGB(238, 238, 238);
   
    [self requestData];
    
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
    
}

- (void)createTable {
    
    if (![self.database open]) {
        return;
    }
    
    [self.database executeUpdate:@"create table if not exists NewsModel (news_id integer primary key autoincrement, news_newsId text, news_content text, news_createtime text)"];
    
    //3.关闭数据库
    [self.database close];
}

- (void)selectDataFromDataBase {
    
    //1.打开数据库
    if (![self.database open]) {
        return;
    }
    //2.通过SQL语句执行查询操作
    FMResultSet *result = [self.database executeQuery:@"select * from NewsModel"];
    while ([result next]) {
        NSString *newsID  = [result stringForColumn:@"news_newsId"];
        NSString *content = [result stringForColumn:@"news_content"];
       
        NSString *createtime = [result stringForColumn:@"news_createtime"];
        
        //把数据封装到对象里
        NewsModel *model = [[NewsModel alloc] initWithNewsId:newsID content:content createtime:createtime];
        //存放到数组中
        [self.dataSourceArr addObject:model];
        
    }

    //3.关闭数据库
    [self.database close];
    
}

//插入一条数据
- (void)insertIntoDataBaseWithModel:(NewsModel *)model{
    //1.打开数据库
    if (![self.database open]) {
        return;
    }
    //2.通过SQL语句操作数据库(即插入一条数据)
     [self.database executeUpdate:@"insert into NewsModel(news_newsId, news_content, news_createtime) values(?, ?, ?)", model.id, model.content, model.createtime];
    
    //3.关闭数据库
    [self.database close];
}


//删除一条数据
- (void)deleteFromDataBaseWithModel:(NewsModel *)model{
    //1.打开数据库
    BOOL isOpen = [self.database open];
    //2.执行SQL语句操作数据库 -- 删除操作
    if (!isOpen) {
        return;
    }
    [self.database executeUpdate:@"delete from NewsModel where news_newsId = ?", model.id];
    //3.关闭数据库
    [self.database close];
}

- (NSString *)getFilePath {
    
    //缓存文件夹的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //拼接上数据文件的路径
    
    return [path stringByAppendingPathComponent:@"News.sqlite"];
}


- (void)setupViews {
    
    if (self.dataSourceArr.count == 0) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(98 * kMulriple, 184 * kHMulriple, 180 * kMulriple, 180 * kHMulriple)];
        imageView.image = [UIImage imageNamed:@"nosource"];
        imageView.alpha = 0.5;
        [self.view addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(210 * kMulriple, 280 * kHMulriple, 90 * kMulriple, 25 * kHMulriple)];
        label.text = @"暂无数据";
        label.textColor = RGB(111, 111, 111);
        label.font = KFont;
        
        [self.view addSubview:label];
        self.view.backgroundColor = RGB(200, 200, 200);
    } else {
    
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWight, kHeight - 64 * kHMulriple) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGB(238, 238, 238);
        [self.view addSubview:self.tableView];
        
        [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"NewsCell"];
  }
}

- (void)customNaviBar {
    self.title = @"系统消息";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowImage"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20 * kMulriple], NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    self.navigationController.navigationBar.barTintColor = RGB(83, 83, 83);
}

- (void)handleBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)requestData {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    WS(weakself);
    [HttpHelper requestUrl:KMessage_url success:^(id json) {
       
        [SVProgressHUD dismiss];
                
        
        NSArray *dataArr = json[@"data"];
        for (NSDictionary *dic in dataArr) {
                    
            NewsModel *model = [[NewsModel alloc] initWithNewsId:dic[@"id"] content:dic[@"content"] createtime:dic[@"createtime"]];
            //更新数据库
            [weakself insertIntoDataBaseWithModel:model];
            [self.dataSourceArr addObject:model];
        }
        [self.tableView reloadData];
        [self setupViews];
        
        
        
    } failure:^(NSError *error) {
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.dataSourceArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    NewsModel *model = self.dataSourceArr[indexPath.row];
    newsCell.model = model;
    newsCell.backgroundColor = RGB(238, 238, 238);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *model = self.dataSourceArr[indexPath.row];
    return [NewsCell heightForRowWithModel:model];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1.数据源
        NewsModel *model = self.dataSourceArr[indexPath.row];
        //从数组中删除
        [self.dataSourceArr removeObjectAtIndex:indexPath.row];
        
        //从数据库删除该条数据
        [self deleteFromDataBaseWithModel:model];
        
        
        //2.界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


@end
