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
    UIToolbar *toolBar;
    NSMutableArray *undoList;
}
@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    currentAlbumIndex = 0;
    
    toolBar = [UIToolbar new];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteMyAlbum)];
    [toolBar setItems:@[undoItem, space, deleteItem]];
    [self.view addSubview:toolBar];
    
    undoList = [NSMutableArray new];
    
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

-(void)viewWillLayoutSubviews
{
    toolBar.frame = CGRectMake(0.0f, self.view.frame.size.height - 40.0f, self.view.frame.size.width, 40.0f);
    dataTable.frame = CGRectMake(0.0f, 130.0f, self.view.frame.size.width, self.view.frame.size.height - 200.0f);
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
    [[LibraryAPI sharedInstance] saveMyAlbums];
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

#pragma mark add/delete albums, undo actions

-(void)addAlbum:(MyAlbum *)album atIndex:(int)index
{
    [[LibraryAPI sharedInstance] addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroll];
}

-(void)deleteAlbum
{
    MyAlbum *deletedAlbum = allAlbums[currentAlbumIndex];
    
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    NSInvocation *undoDeleteAction = [NSInvocation invocationWithMethodSignature:signature];
    
    [undoDeleteAction setTarget:self];
    [undoDeleteAction setSelector:@selector(addAlbum:atIndex:)];
    [undoDeleteAction setArgument:&deletedAlbum atIndex:2];
    [undoDeleteAction setArgument:&currentAlbumIndex atIndex:3];
    [undoDeleteAction retainArguments];
    
    [undoList addObject:undoDeleteAction];
    
    [[LibraryAPI sharedInstance] deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroll];
    
    [toolBar.items[0] setEnabled:YES];
}

@end
