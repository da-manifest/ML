//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "MyAlbum+TableRepresentation.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
}
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    currentAlbumIndex = 0;
    allAlbums = [[LibraryAPI sharedInstance] albums];
    CGRect frame = CGRectMake(0.0f, 120.0f, self.view.frame.size.width, self.view.frame.size.height - 120.0f);
    dataTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    [self showDataFromAlbumAtIndex:currentAlbumIndex];
}

-(void)showDataFromAlbumAtIndex:(int)albumIndex
{
    if (albumIndex <= allAlbums.count)
    {
        MyAlbum *myAlbum = allAlbums[albumIndex];
        currentAlbumData = [myAlbum tr_tableRepresentation];
    }
    else
        currentAlbumData = nil;
    
    [dataTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentAlbumData[@"titles"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    return cell;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
