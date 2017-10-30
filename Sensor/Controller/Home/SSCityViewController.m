//
//  SSCityViewController.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/25.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSCityViewController.h"
#import "ZWCollectionViewFlowLayout.h"
#import "Public.h"
#import "HeadView.h"
#import "CityViewCell.h"

#import "NBSearchResultController.h"
#import "NBSearchController.h"
#import "SearchResult.h"
#import "NSMutableArray+FilterElement.h"

#import "SSLocation.h"

@interface SSCityViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,NBSearchResultControllerDelegate,CityViewCellDelegate>

{
    UITableView *_tableView;
    HeadView    *_CellHeadView;
    NSMutableArray * _locationCity; //定位当前城市
    
    NSMutableArray *_dataArray; //定位，最近，热门数据原
    
    NSMutableDictionary *_allCitysDictionary; //所有数据字典
    NSMutableArray *_keys; //城市首字母
    
}
@property (nonatomic, strong)NBSearchController *searchController; //搜索的控制器

@property (nonatomic, strong)NSMutableArray *searchList; //搜索结果的数组

@property (nonatomic, strong)NBSearchResultController *searchResultController; //搜索的结果控制器

@property(strong,nonatomic)NSMutableArray *allCityArray;  //所有城市数组

@property (nonatomic, strong) CLLocationManager *locationManager; //定位

@end

@implementation SSCityViewController

#pragma mark - 懒加载一些内容
-(NSMutableArray *)allCityArray
{
    if (!_allCityArray) {
        _allCityArray = [NSMutableArray array];
    }
    return _allCityArray;
}
- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SSLocation sharedLocation] startLocation];
    [self loadData];
    [self initTableView];
    [self initSearchController];
    
    self.title = @"选择城市";
    
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];
    
    
}

-(void)loadData
{
    _dataArray=[NSMutableArray array];
    //定位城市
    _locationCity=[NSMutableArray arrayWithObject:[[SSLocation sharedLocation] locationCityName]];
    [_dataArray addObject:_locationCity];
    
    //热门城市
    NSArray *hotCity=[NSArray arrayWithObjects:@"北京",@"上海",@"广州",@"深圳",@"杭州",@"南京",@"天津",@"武汉",@"重庆", nil];
    [_dataArray addObject:hotCity];
    
    //索引城市
    NSString *path=[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"];
    _allCitysDictionary=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    //将所有城市放到一个数组里
    for (NSArray *array in _allCitysDictionary.allValues) {
        for (NSString *citys in array) {
            [self.allCityArray addObject:citys];
        }
    }
    
    
    _keys=[NSMutableArray array];
    [_keys addObjectsFromArray:[[_allCitysDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加多余三个索引
    [_keys insertObject:@"热门" atIndex:0];
    [_allCitysDictionary setObject:hotCity forKey:@"热门"];
    [_keys insertObject:@"定位" atIndex:0];
    [_allCitysDictionary setObject:_locationCity forKey:@"定位"];
}
-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = RGB(150, 150, 150);
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CityViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CityViewCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
}
-(void)initSearchController //创建搜索控制器
{
    self.searchResultController=[[NBSearchResultController alloc]init];
    self.searchResultController.delegate=self;
    _searchController=[[NBSearchController alloc]initWithSearchResultsController:self.searchResultController];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater=self;
    _searchController.searchBar.delegate = self;
    _tableView.tableHeaderView = self.searchController.searchBar;
    
    
}

//修改SearchBar的Cancel Button 的Title
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [_searchController.searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[_searchController.searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section<=1) {
        return 1;
    }else{
        
        NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:section]];
        
        return array.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<=1) {
        
        return [CityViewCell getHeightWithCityArray:_dataArray[indexPath.section]];
    }else{
        
        return 47;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section<=1) {
        
        static NSString *identfire=@"CityViewCell";
        
        CityViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire forIndexPath:indexPath];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setContentView:_dataArray[indexPath.section]];
        return cell;
        
    }else{
        
        static NSString *identfire=@"cellID";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire forIndexPath:indexPath];
            
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
        
        cell.textLabel.text=array[indexPath.row];
        return cell;
    }
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _CellHeadView=[[HeadView alloc]init];
    
    if (section==0) {
        
        _CellHeadView.TitleLable.text=@"定位城市";
    }else if (section==1){
        
        _CellHeadView.TitleLable.text=@"热门城市";
        
    }
   else{
        
        _CellHeadView.TitleLable.text=_keys[section];
    }
    
    return _CellHeadView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
    [self popRootViewControllerWithName:array[indexPath.row]];
}

-(void)SelectCityNameInCollectionBy:(NSString *)cityName
{
    [self popRootViewControllerWithName:cityName];
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    // 移除搜索结果数组的数据
    [self.searchList removeAllObjects];
    //过滤数据
    self.searchList= [SearchResult getSearchResultBySearchText:searchString dataArray:self.allCityArray];
    if (searchString.length==0&&self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [self.searchList filterTheSameElement];
    NSMutableArray *dataSource = nil;
    if ([self.searchList count]>0) {
        dataSource = [NSMutableArray array];
        // 结局了数据重复的问题
        for (NSString *str in self.searchList) {
            [dataSource addObject:str];
        }
    }
    
    //刷新表格
    self.searchResultController.dataSource = dataSource;
    [self.searchResultController.tableView reloadData];
    [_tableView reloadData];
    
}
/**
 *  点击了搜索的结果的 cell
 *
 *  @param resultVC  搜索结果的控制器
 *  @param follow    搜索结果信息的模型
 */
- (void)resultViewController:(NBSearchResultController *)resultVC didSelectFollowCity:(NSString *)cityName
{
    self.searchController.searchBar.text =@"";
    [self.searchController dismissViewControllerAnimated:NO completion:nil];
    [self popRootViewControllerWithName:cityName];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.searchController.active?nil:_keys;
}
-(void)returnText:(ReturnCityName)block
{
    self.returnBlock=block;
}
- (void)popRootViewControllerWithName:(NSString *)cityName
{
    self.returnBlock(cityName);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
