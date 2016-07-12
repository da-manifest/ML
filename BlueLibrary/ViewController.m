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
#import "HorizontalScroll.h"
#import "MyAlbumView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, HorizontalScrollDelegate>
{
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    int currentAlbumIndex;
    HorizontalScroll *scroll;
}
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentAlbumIndex = 0;
    allAlbums = [[LibraryAPI sharedInstance] albums];
    CGRect frame = CGRectMake(0.0f, 120.0f, self.view.frame.size.width, self.view.frame.size.height - 120.0f);
    dataTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self loadPreviuosState];
    
    scroll = [[HorizontalScroll alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.view.frame.size.width, 120.0f)];
    scroll.backgroundColor = [UIColor lightGrayColor];
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    [self reloadScroll];
    
    [self showDataFromAlbumAtIndex:currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
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

#pragma mark HorizontalScrollDelegate metods

-(void)horizontalScroll:(HorizontalScroll *)scroll clickedViewAtIndex:(int)index
{
    currentAlbumIndex = index;
    [self showDataFromAlbumAtIndex:index];
}

-(NSInteger)numberOfViewsForHorizontalScroll:(HorizontalScroll *)scroll
{
    return allAlbums.count;
}

-(UIView *)horizontalScroll:(HorizontalScroll *)scroll viewAtIndex:(int)index
{
    MyAlbum *myAlbum = allAlbums[index];
    return [[MyAlbumView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f) andAlbumCover:myAlbum.coverUrl];
}

-(void)reloadScroll
{
    allAlbums = [[LibraryAPI sharedInstance] albums];
    if (currentAlbumIndex < 0) currentAlbumIndex = 0;
    else if (currentAlbumIndex >= allAlbums.count) currentAlbumIndex = allAlbums.count - 1;
    
    [scroll reload];
    [self showDataFromAlbumAtIndex:currentAlbumIndex];
}

#pragma mark save/load current application state

-(void)saveCurrentState
{
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
}

-(void)loadPreviuosState
{
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
}

-(NSInteger)startViewIndexForHorizontalScroll:(HorizontalScroll *)scroll
{
    return currentAlbumIndex;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
