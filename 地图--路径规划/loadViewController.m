//
//  loadViewController.m
//  meituan
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "loadViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MAMapKit.h"
#import "mapDetailViewController.h"

#import "loadCell.h"
#import "loadTableHeadView.h"
#import "bussinessModel.h"
@interface loadViewController ()<UITableViewDataSource,UITableViewDelegate,loadTableHeadViewDeleget>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)loadTableHeadView *heaview;
@property(nonatomic,strong)NSMutableArray *array;

@end

@implementation loadViewController
-(loadTableHeadView *)heaview
{
    if (!_heaview) {
        _heaview = (loadTableHeadView *)[loadTableHeadView viewFromXib:@"loadTableHeadView"];
        _heaview.deleget = self;
        _heaview.labe2.text = self.model.business_name;
        _heaview.frame = CGRectMake(0, 0, KscrW,145*Kscr );
        if (self.loadtype==loadTableViewTypeCar) {
            self.heaview.tableviewType=loadTableViewTypeCar;
            self.array = self.cararray;
        }else if (self.loadtype==loadTableViewTypeWalk)
        {   self.array = self.walkarray;
            self.heaview.tableviewType=loadTableViewTypeWalk;
        }else
        {
            self.array = self.busarray;
            self.heaview.tableviewType=loadTableViewTypeBus;
        }

    }
    return _heaview;
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KscrW, KscrH-KBar1)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 80*Kscr;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.tableHeaderView = self.heaview;
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
     [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadCell *cell = (loadCell*)[loadCell tableview:tableView cellFromXib:@"loadCell" inderfier:@"loadCell"];
    
    if (self.loadtype==loadTypeCar||self.loadtype==loadTypeWalk) {
        AMapPath *path = self.array[indexPath.row];
        
        [cell gaveme:path];

    }else
    {

        AMapTransit *transit = self.array[indexPath.row];
        [cell gaveBusMe:transit];
        
    
    }
    
    
//    AMapStep *atap = path.steps[0];

    
    
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mapDetailViewController *vc = [[mapDetailViewController alloc]init];
    if (self.loadtype==loadTypeWalk) {
        vc.linetype = lineTypeWalk;
    }else if (self.loadtype==loadTypeCar)
    {
        vc.linetype = lineTypeCar;
    }else
    {
        vc.linetype = lineTypeBuss;
        vc.inter = indexPath.row;
    }
    
    
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
//headview的代理
-(void)witchbtnclic:(NSInteger)inter
{
    if (inter==1) {
        self.heaview.tableviewType=loadTableViewTypeCar;
        self.loadtype =loadTableViewTypeCar;
        self.array = self.cararray;
    }else if (inter==2)
    {   self.array = self.walkarray;
        self.heaview.tableviewType=loadTableViewTypeWalk;
        self.loadtype = loadTableViewTypeWalk;
    }else
    {
        self.array = self.busarray;
        self.heaview.tableviewType=loadTableViewTypeBus;
        self.loadtype = loadTableViewTypeBus;
    }
    [self.tableview reloadData];

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
