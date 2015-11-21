//
//  iKCollectionViewController.m
//  iKatha
//
//  Created by Boove Software on 28/11/13.
//  Copyright (c) 2013 Boove Software. All rights reserved.
//

#import "iKCollectionViewController.h"
#import "iKDetailViewController.h"
#import "iKAppDelegate.h"
#import "StoryObject.h"

@interface iKCollectionViewController ()
{
    iKAppDelegate *appDelegate;
}

@end

@implementation iKCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [appDelegate getStories];
    self.collectionView.delegate = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        self.numberOfStories = appDelegate.storiesArray.count;
        self.collectionView.delegate = self;
        // NSLog(@"parameter1: %d parameter2: %f", parameter1, parameter2);
        [self.collectionView reloadData];
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
   
    self.title = @"Select a Story";
    
   
    
    self.numberOfStories = appDelegate.storiesArray.count;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        //  AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        //  self.lblMusicName.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
        //NSLog(@"New music name: %@", self.lblMusicName.text);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"inside count");
    return appDelegate.storiesArray.count;
    
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  I'm using a custom cell here as it allows me to customize the look and feel.
     */
    
    iKCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor grayColor];
    
    
    
    StoryObject *obj = [appDelegate.storiesArray objectAtIndex:indexPath.row];
    
    cell.cellImageView.image = [appDelegate loadImageWithName:[obj.arrImagePaths objectAtIndex:0]];
    
    //[UIImage imageNamed:[obj.arrImagePaths objectAtIndex:0]];
    cell.cellLabel.text=obj.strTitle;
    // NSLog(@"%@",cell.lbl1.text);
    
    return cell;
    
    
    
    
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@", indexPath);
}

#pragma mark - Prepare for Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if (![segue.identifier isEqualToString:@"add"]) {
        
    
    UICollectionViewCell *selectedCell = (UICollectionViewCell *)sender;
    NSInteger selectedRow = [self.collectionView indexPathForCell:selectedCell].row;
    
    /**
     *  This is where I transfer data from the CollectionViewController to the DetailViewController
     */
    iKDetailViewController *dVC = [segue destinationViewController];
    dVC.storyObj = [appDelegate.storiesArray objectAtIndex:selectedRow];
    }
    //dVC.storyDictionary = contents;
}


@end

