//
//  shopMapViewController.m
//  meituan
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "shopMapViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAMapKit.h"
#import "bussinessModel.h"
#import "mapTimeView.h"
#import "loadViewController.h"
@interface shopMapViewController ()<AMapSearchDelegate,MAMapViewDelegate,mapTimeViewDeleget>
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)MAMapView *mamapview;
@property(nonatomic,strong)mapTimeView *maptimview;


@property(nonatomic,strong)MAUserLocation *location;

@property(nonatomic,strong)NSString *citystring;

@property(nonatomic,strong)NSMutableArray *walkArray;

@property(nonatomic,strong)NSMutableArray *carArray;

@property(nonatomic,strong)NSMutableArray *busArray;

@end

@implementation shopMapViewController
-(NSMutableArray *)walkArray
{
    if (!_walkArray) {
        _walkArray = [NSMutableArray array];
    }
    return _walkArray;
}
-(NSMutableArray *)carArray
{
    if (!_carArray) {
        _carArray = [NSMutableArray array];
    }
    return _carArray;
}
-(NSMutableArray *)busArray
{
    if (!_busArray) {
        _busArray = [NSMutableArray array];
    }
    return _busArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapSearchServices sharedServices].apiKey = MapAppKey;
    [self setNavTitle:@"商家地址"];
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self searchcity];
    
    [self creatmap];
    [self addmaptimeview];
    
    [ZBProssHud showFrom:self.view withtetxt:@"地图加载中.."];
}

-(void)addmaptimeview
{
    self.maptimview = (mapTimeView *)[mapTimeView viewFromXib:@"mapTimeView"];
    self.maptimview.frame = CGRectMake(25.5*Kscr, KscrH-KBar1-54*Kscr, 324*Kscr, 44*Kscr);
    self.maptimview.deleget = self;
    self.maptimview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.maptimview];
}

-(void)creatmap
{
    [MAMapServices sharedServices].apiKey = MapAppKey;
    self.mamapview = [[MAMapView alloc]initWithFrame:self.view.bounds];
    
    MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake([self.model.latitude doubleValue], [self.model.longitude doubleValue]);
    point.title = self.model.business_name;
    [self.mamapview addAnnotation:point];
    
//    [self.mamapview selectAnnotation:point animated:YES];
    self.mamapview.showsUserLocation = YES;
    self.mamapview.delegate = self;
    
    self.mamapview.userTrackingMode =MAUserTrackingModeFollowWithHeading;
    
    self.mamapview.centerCoordinate = CLLocationCoordinate2DMake([self.model.latitude doubleValue], [self.model.longitude doubleValue]);
    
    [self.mamapview selectAnnotation:point animated:YES];
    [self.view insertSubview:self.mamapview atIndex:0];
}

//标注的回调
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    MAAnnotationView *maanopoint = [mapView dequeueReusableAnnotationViewWithIdentifier:@"maanopoint"];
    if (!maanopoint) {
        maanopoint = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"maanopoint"];
    }
    maanopoint.image = [UIImage imageNamed:@"locapoint.png"];
    maanopoint.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
    maanopoint.draggable = YES;        //设置标注可以拖动，默认为NO
    return maanopoint;
}

//步行路经查询
-(void)buxingsearch:(MAUserLocation *)userLocation
{
//AMapWalkingRouteSearchRequest
    AMapWalkingRouteSearchRequest *request = [[AMapWalkingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude: userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:[self.model.latitude doubleValue] longitude:[self.model.longitude doubleValue]];
    
    [self.search AMapWalkingRouteSearch: request];
}

//自驾车路经查询
-(void)carsearch:(MAUserLocation *)userLocation
{
    //构造AMapDrivingRouteSearchRequest对象，设置驾车路径规划请求参数
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude: userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//    request.origin = [AMapGeoPoint locationWithLatitude:36.6638938989 longitude: 117.0613750594];
    
    NSLog(@"真正的%@====%@",self.model.latitude,self.model.longitude);
    request.destination = [AMapGeoPoint locationWithLatitude:[self.model.latitude doubleValue] longitude:[self.model.longitude doubleValue]];
    request.strategy = 2;//距离优先
    request.requireExtension = YES;
    //发起路径搜索
    [self.search AMapDrivingRouteSearch: request];
}

//公交路径查询
-(void)buszhansearch:(MAUserLocation *)userLocation
{
    AMapTransitRouteSearchRequest *stopRequest = [[AMapTransitRouteSearchRequest alloc] init];
    stopRequest.city = self.citystring;
    stopRequest.origin = [AMapGeoPoint locationWithLatitude: userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    stopRequest.destination = [AMapGeoPoint locationWithLatitude:[self.model.latitude doubleValue] longitude:[self.model.longitude doubleValue]];
    
    //发起公交站查询
    [self.search AMapTransitRouteSearch: stopRequest];
}

//发起查询的回调
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    NSLog(@"测试的-------%@",request);
    [ZBProssHud removeFrom:self.view];
    
    if ([request isKindOfClass:[AMapDrivingRouteSearchRequest class]]){
        
        [self.carArray removeAllObjects];
        [self.carArray addObjectsFromArray:response.route.paths];
        
        NSLog(@"%lu",(unsigned long)response.route.paths.count);
        
        if (response.route.paths.count>0) {
            AMapPath *path = response.route.paths[0];//选择一条路径
            
            self.maptimview.carlable.text = [Unit gavewmemiao:path.duration];

        }
        
 
    }else if ([request isKindOfClass:[AMapWalkingRouteSearchRequest class]]){
        NSLog(@"%ld",response.route.paths.count);
        
        [self.walkArray removeAllObjects];
        [self.walkArray addObjectsFromArray:response.route.paths];
        
        if (response.route.paths.count>0) {
            AMapPath *path = response.route.paths[0];
            
            //        for (AMapPath *amp in response.route.paths) {
            //
            //        }
            
            //        AMapStep *stap =  path.steps[1];
            //
            //        NSLog(@"%@",stap.road);
            
            self.maptimview.personlable.text = [Unit gavewmemiao:path.duration];//选择一条路径

        }
        
        
    
    }else if ([request isKindOfClass:[AMapTransitRouteSearchRequest class]]){
        [self.busArray removeAllObjects];
        NSArray *array = response.route.transits;
        [self.busArray addObjectsFromArray:array];
        
        NSLog(@"周宾地图测试%lu",(unsigned long)array.count);
        
        if (array.count>0) {
            AMapTransit *transsit =array[0];
            self.maptimview.busLable.text = [Unit gavewmemiao:transsit.duration];
            
            AMapSegment *seg = transsit.segments[0];
            
            AMapBusLine *lin = seg.buslines[0];
        
            NSLog(@"=-----=-=-=%@",lin.name);
        }
    }
}

//定位用户位置
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    
    self.location = userLocation;
    
    if (updatingLocation) {
        if (self.citystring) {
            [self carsearch:userLocation];
            [self buxingsearch:userLocation];
            [self buszhansearch:userLocation];
        }else{
            [self searchcity];
        }
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [ZBProssHud showerrorFrom:self.view with:@"定位失败"];
}

//地理编码查询
-(void)searchcity
{
    AMapGeocodeSearchRequest *regeo = [[AMapGeocodeSearchRequest alloc] init];
    regeo.address = self.model.address;
    [self.search AMapGeocodeSearch:regeo];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    NSLog(@"kanakndingwie ");
    
    NSArray *array = response.geocodes;
    if (array.count==0) {
        [ZBProssHud showerrorFrom:self.view with:@"城市查询失败"];
    }else{
        AMapGeocode *cod = array[0];
        self.citystring = cod.city;
        
        [self carsearch:self.location];
        [self buxingsearch:self.location];
        [self buszhansearch:self.location];

    }
}

-(void)witchImageBtnClic:(NSInteger )btnclic
{
    loadViewController *vc = [[loadViewController alloc]init];

    if (btnclic ==2) {
//        vc.array = self.walkArray;
        vc.loadtype =loadTypeWalk;
    }else if (btnclic==1){
//        vc.array =self.carArray;
        vc.loadtype=loadTypeCar;
    }else{
//        vc.array = self.busArray;
        vc.loadtype = loadTypeBus;
    }
    
    vc.walkarray = self.walkArray;
    vc.busarray = self.busArray;
    vc.cararray = self.carArray;
    
    vc.model = self.model;

    [self.navigationController pushViewController:vc animated:YES];
}
//-(void)onBusStopSearchDone:(AMapBusStopSearchRequest*)request response:(AMapBusStopSearchResponse *)response
//{
//    if(response.busstops.count == 0)
//    {
//        return;
//    }
//    
//    
//    
//    //通过AMapBusStopSearchResponse对象处理搜索结果
////    NSString *strStop = @"";
//    for (AMapBusStop *p in response.busstops) {
////        strStop = [NSString stringWithFormat:@"%@\nStop: %@", strStop, p.description];
//        NSLog(@"%@",p.name);
//        
//    }
//}

//- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
//{
//    if(response.route == nil)
//    {
//        return;
//    }
//    
//    //通过AMapNavigationSearchResponse对象处理搜索结果
//    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
//    
//    AMapPath *path = response.route.paths[0]; //选择一条路径
//    AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
//    NSLog(@"%@",step.polyline);   //此路段坐标点字符串
//    
////    if (response.count > 0)
////    {
////        //移除地图原本的遮盖
////        [self.mamapview removeOverlays:_pathPolylines];
////        _pathPolylines = nil;
////        
////        // 只显⽰示第⼀条 规划的路径
////        _pathPolylines = [self polylinesForPath:response.route.paths[0]];
////        NSLog(@"%@",response.route.paths[0]);
////        //添加新的遮盖，然后会触发代理方法进行绘制
////        [_mapView addOverlays:_pathPolylines];
////    }
//}



//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
//{
//    /* 自定义定位精度对应的MACircleView. */
//    
//    //画路线
//    if ([overlay isKindOfClass:[MAPolyline class]])
//    {
//        //初始化一个路线类型的view
//        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
//        //设置线宽颜色等
//        polygonView.lineWidth = 8.f;
//        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
//        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
////        polygonView.lineJoinType = kMALineJoinRound;//连接类型
//        //返回view，就进行了添加
//        return polygonView;
//    }
//    return nil;
//    
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
