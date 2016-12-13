//
//  mapDetailViewController.m
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "mapDetailViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAMapKit.h"
#import "bussinessModel.h"
#import "mapTimeView.h"
#import "loadViewController.h"
#import "loadMapCell.h"
#import "bleHeaview.h"
#import <MapKit/MapKit.h>

@interface mapDetailViewController ()<AMapSearchDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,bleHeaviewDeleget>
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)MAMapView *mamapview;


@property(nonatomic,strong)MAUserLocation *location;
//headview用的
@property(nonatomic,strong)AMapTransit *trans;
@property(nonatomic,strong)AMapPath *path;
@property(nonatomic,assign)BOOL upimage;



@property(nonatomic,strong)NSString *citystring;

@property (nonatomic,retain) NSArray *pathPolylines;

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *array;

@end

@implementation mapDetailViewController
-(NSMutableArray *)array
{
    if (!_array) {
        _array =[NSMutableArray array];
    }
    return _array;
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, KscrH-KBar1-bleHeaviewH, KscrW, 400)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 60*Kscr;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;

}

- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapSearchServices sharedServices].apiKey = MapAppKey;
    [self setNavTitle:@"路径规划"];
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self searchcity];
    
    [self creatmap];
    [self.view addSubview:self.tableview];
    
    self.upimage  =NO;
    
    [self addtarget:self witiTItle:@"导航" with:@selector(benjidaohang)];
    
    [ZBProssHud showFrom:self.view withtetxt:@"路径规划中.."];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadMapCell *cell = (loadMapCell *)[loadMapCell tableview:tableView cellFromXib:@"loadMapCell" inderfier:@"loadMapCell"];
    [cell gavemestr:self.array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return bleHeaviewH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    bleHeaview *view = (bleHeaview*)[bleHeaview viewFromXib:@"bleHeaview"];
    view.deleget = self;
    view.ischange = self.upimage;
    if (self.linetype==lineTypeBuss) {
        [view gaveBusMe:self.trans];
    }else
    {
        [view gaveme:self.path];
    }
    
    return view;
}

-(void)uptableviewwithtime:(bleHeaview *)blview
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.tableview.top>=KscrH-KBar1-bleHeaviewH) {
            self.tableview.transform =CGAffineTransformMakeTranslation(0, bleHeaviewH-400);
            self.upimage = YES;
            [blview upimage];
        }else{
            self.tableview.transform =CGAffineTransformMakeTranslation(0, 0);
            self.upimage = NO;
            [blview downimage];
        }
    }];
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
    
    self.mamapview.userTrackingMode =MAUserTrackingModeFollow;
    
    self.mamapview.centerCoordinate = CLLocationCoordinate2DMake([self.model.latitude doubleValue], [self.model.longitude doubleValue]);
    
    [self.mamapview selectAnnotation:point animated:YES];
    [self.view insertSubview:self.mamapview atIndex:0];
}

//标注的回调
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    //
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
    [ZBProssHud removeFrom:self.view];
    
    NSLog(@"%@",request);
    
    if ([request isKindOfClass:[AMapDrivingRouteSearchRequest class]]){
        NSLog(@"%lu",(unsigned long)response.route.paths.count);
        
        AMapPath *path = response.route.paths[0];//选择一条路径
        self.path = path;
        [self.array removeAllObjects];
        for (AMapStep *atao in path.steps) {
            
            
            [self.array addObject:atao.instruction];
            
            NSLog(@"此处为测试 %@  %ld  %@",atao.road,(long)atao.distance,atao.instruction);

        }
        [self.tableview reloadData];

        
        
        
        if (response.count > 0)
        {
            [self.mamapview removeOverlays:_pathPolylines];
            _pathPolylines = nil;
            
            // 只显⽰示第⼀条 规划的路径
            _pathPolylines = [self polylinesForPath:response.route.paths[0]];
            
            
            NSLog(@"%@",response.route.paths[0]);
            
            [self.mamapview addOverlays:_pathPolylines];
        }
        
    }else if ([request isKindOfClass:[AMapWalkingRouteSearchRequest class]])
    {
        
        NSLog(@"%ld",(unsigned long)response.route.paths.count);
        AMapPath *path = response.route.paths[0];
        
        self.path = path;
        [self.array removeAllObjects];
        
        for (AMapStep *atao in path.steps) {
            [self.array addObject:atao.instruction];
            
            NSLog(@"此处为测试 %@  %ld  %@",atao.road,(long)atao.distance,atao.instruction);
            
        }
        [self.tableview reloadData];

        
        if (response.count > 0)
        {
            [self.mamapview removeOverlays:_pathPolylines];
            _pathPolylines = nil;
            
            // 只显⽰示第⼀条 规划的路径
            _pathPolylines = [self polylinesForPath:response.route.paths[0]];
            
            
            NSLog(@"%@",response.route.paths[0]);
            
            [self.mamapview addOverlays:_pathPolylines];
            
        }
        

        
        NSLog(@"步行%ld",(long)path.duration);
        
    }else if ([request isKindOfClass:[AMapTransitRouteSearchRequest class]])
    {
        
        
//        [self.busArray removeAllObjects];
        NSArray *array = response.route.transits;
        
        AMapTransit *sit = array[self.inter];
        
        self.trans =sit;

        
        
        [self.array removeAllObjects];
        for (AMapSegment *seg in sit.segments) {
            
            
            for (AMapStep *sta in seg.walking.steps ) {
                
                [self.array addObject:sta.instruction];
                
                NSLog(@"导航的情况%@",sta.instruction);
                
            }


            for (AMapBusLine *busline in seg.buslines) {
                
                NSString *str = [NSString stringWithFormat:@"乘%@ 经过%lu站 到%@下车",busline.name,(unsigned long)busline.viaBusStops.count,busline.arrivalStop.name];
                [self.array addObject:str];
                
            }
            
            
            
        }
        
        [self.tableview reloadData];
        
//        [self.busArray addObjectsFromArray:array];
        
//        AMapTransit
//        AMapSegment
//        AMapBusLine
        
        
        
        
        
        
        if (response.count > 0)
        {
            [self.mamapview removeOverlays:_pathPolylines];
            _pathPolylines = nil;
            
            // 只显⽰示第⼀条 规划的路径
            _pathPolylines = [self buspolylinesForPath:response.route.transits[self.inter]];
            [self.mamapview addOverlays:_pathPolylines];
        }
        

        
        
        
        if (array) {
            AMapTransit *transsit =array[1];
//            self.maptimview.busLable.text = [Unit gavewmemiao:transsit.duration];
            
            
            AMapSegment *seg = transsit.segments[1];
            
            AMapBusLine *lin = seg.buslines[0];
            
            NSLog(@"=-----=-=-=%@",lin.name);
        }
        
        
    }
    
}
//定位用户位置
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        
        if (self.citystring) {
            
            if (self.linetype==lineTypeWalk) {
                [self buxingsearch:userLocation];

            }else if (self.linetype==lineTypeCar)
            {
                [self carsearch:userLocation];

            }else
            {
                [self buszhansearch:userLocation];

            }
            
            
        }else
        {
            [self searchcity];
            
            [self carsearch:self.location];
            [self buxingsearch:self.location];
            [self buszhansearch:self.location];

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
    
    NSArray *array = response.geocodes;
    
    AMapGeocode *cod = array[0];
    
    self.citystring = cod.city;
    
}
//公交路径解析
-(NSArray *)buspolylinesForPath:(AMapTransit *)transit
{
    if (transit == nil || transit.segments.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    
    for (AMapSegment *seg in transit.segments) {
        
        for (AMapBusLine *lines in seg.buslines ) {
            
            NSUInteger count = 0;
            
            
            
            CLLocationCoordinate2D *coordinates = [self coordinatesForString:lines.polyline
                                                             coordinateCount:&count
                                                                  parseToken:@";"];
            
            
            MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
            
            //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
            
            [polylines addObject:polyline];
            free(coordinates), coordinates = NULL;
            
        }
        
        
        
    }
    
    
    
    
    return polylines;



}

//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        
        
        
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        
        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}

//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
//        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        
        return polygonView;
    }
    return nil;
}

#pragma mark 调用本机地图进行导航
- (void)benjidaohang
{
    //获取当前位置
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    
    //当前经维度
    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    //目的地位置
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake([self.model.latitude floatValue], [self.model.longitude floatValue]);
//    coordinate.latitude = [self.model.latitude floatValue];
//    coordinate.longitude = [self.model.longitude floatValue];
    
    
//    CLLocationCoordinate2D coords2 = coordinate;
    
    // ios6以下，调用google map
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0)
    {
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", coords1.latitude,coords1.longitude,coords2.latitude,coords2.longitude];
        NSURL *aURL = [NSURL URLWithString:urlString];
        //打开网页google地图
        [[UIApplication sharedApplication] openURL:aURL];
    }
    else
        // 直接调用ios自己带的apple map
    {
        //当前的位置
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //起点
        //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
        
        toLocation.name = @"目的地";
        NSString *myname = self.model.business_name;
        if (![Unit stringIsEmpty:myname])
        {
            toLocation.name =myname;
        }
        
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
}

@end
