//
//  iKStoryListingController.m
//  iKatha
//
//  Created by M on 13/08/15.
//  Copyright (c) 2015 Boove Software. All rights reserved.
//

#import "iKStoryListingController.h"
#import "iKAppDelegate.h"
#import "iKCustomCell.h"
#import "StoryObject.h"
#import "iKAddEditStoryController.h"

@interface iKStoryListingController ()
{
    iKAppDelegate *appDelegate;
}

@end

@implementation iKStoryListingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication] delegate];
   // appDelegate.stor
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return appDelegate.storiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"list_cell";
    
    iKCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    StoryObject *obj = [appDelegate.storiesArray objectAtIndex:indexPath.row];
    cell.btnEdit.tag = indexPath.row;
    cell.btnDelete.tag = indexPath.row;
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        cell.btnDelete.hidden = YES;
    }
    else
    {
         cell.btnDelete.hidden = NO;
    }
    
    [cell.btnEdit addTarget:self action:@selector(onEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [cell.btnDelete addTarget:self action:@selector(onDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.lblName.text = obj.strTitle;
    
    
    return cell;
}


- (void)onEditBtnClick:(id)sender
{
    NSInteger index = [sender tag];
    StoryObject *obj = [appDelegate.storiesArray objectAtIndex:index];
    
    iKAddEditStoryController *controller = (iKAddEditStoryController *)[iKAppDelegate getViewControllerFromStoryboard:@"iKAddEditStoryController"];
    
    controller.storyObject = obj;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onDeleteBtnClick:(id)sender
{
    NSInteger index = [sender tag];
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Confirm"
                          message:@"Are you sure you want to delete the story ?"
                          delegate:self // <== changed from nil to self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    alert.tag = index;
    [alert show];
   
    
    //[self.navigationController pushViewController:controller animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        StoryObject *obj = [appDelegate.storiesArray objectAtIndex:alertView.tag];
        NSNumber  *storyId = [NSNumber numberWithInteger: obj.storyId];

        BOOL success = [appDelegate.fmdatabase executeUpdate:@"DELETE FROM story_master WHERE id = ?", storyId];
        
        NSLog(@"SUccess is %d",success);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
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
