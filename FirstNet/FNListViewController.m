//
//  FNListViewController.m
//  FirstNet
//
//  Created by 山田 宏道 on 2014/06/07.
//  Copyright (c) 2014年 Torques Inc. All rights reserved.
//

#import "FNListViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface FNListViewController ()

@end

@implementation FNListViewController
{
	NSMutableArray*	feeds;
}

#pragma mark - methods

- (void) loadJsonForTable
{
	NSURL *url = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/search/images?"
								"v=1.0&q=japan&userip=INSERT-USER-IP"];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	
	__weak typeof(self) weakSelf = self;
	[NSURLConnection sendAsynchronousRequest:req
																		 queue:queue
												 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
	 {
		 if(error){
			 // 失敗.
			 NSLog(@"an error occurred. reason = %@", error);
		 }
		 else {
			 int httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
			 if (httpStatusCode == 404) {
				 // 失敗.
				 NSLog(@"404 NOT FOUND ERROR. targetURL=%@", url);
			 }
			 else {
				 // 成功.
				 NSLog(@"success request!!");
				 NSString*	dataString	= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				 NSLog(@"responseText = %@", dataString);
				 
				 
				 // --- NSData→JSON
				 NSError *error;
				 NSData *jsonData = [dataString dataUsingEncoding:NSUnicodeStringEncoding];
				 NSDictionary*	dicJson	= [NSJSONSerialization JSONObjectWithData:jsonData
																																 options:NSJSONReadingAllowFragments
																																	 error:&error];
				 
									
				 if( dicJson && [dicJson isKindOfClass:[NSDictionary class]] ){
					 // 取得成功時.
					 NSLog(@"valid result!");
					 NSArray*	feedItems = dicJson[@"responseData"][@"results"];
					 feeds	= [NSMutableArray array];
					 for( NSDictionary* feed in feedItems ){
						 NSLog(@"feed --> %@", feed);
						 [feeds addObject:feed];
					 }
				 }
				 else{
					 // 取得失敗時.
					 NSLog(@"invalid result..");
					 
				 }
				 
				 dispatch_async(dispatch_get_main_queue(), ^{
					 NSLog(@"load done!!");
					 [weakSelf.tableView reloadData];
				 });
			 }
		 }
	 }];
	
}

- (IBAction)buttonRefreshPressed:(id)sender
{
	[self loadJsonForTable];
}


- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( feeds ){
		return [feeds count];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString	*FNCellIdentifier	= @"FNCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FNCellIdentifier
																													forIndexPath:indexPath];
	
	NSDictionary*	dicFeed	= [feeds objectAtIndex:indexPath.row];
	
	// -- ＜画像：ここから＞
	
//	cell.imageView.image	= nil;
//	[cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
	
	// step 1.
//	cell.imageView.image	= [UIImage imageNamed:@"cartoon-Elephant"];
	
	// step 2.
	NSString*	urlString	= dicFeed[@"url"];
	NSURL *url = [NSURL URLWithString:urlString];
//	cell.imageView.image	= [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	
	// step 3.
	
	[cell.imageView setImageWithURL:url
	 placeholderImage:[UIImage imageNamed:@"cartoon-Elephant"]
	 ];
	// -- ＜画像：ここまで＞
	
	cell.detailTextLabel.text	= dicFeed[@"url"];
	cell.detailTextLabel.text	= dicFeed[@"published"];
	cell.textLabel.text	= dicFeed[@"title"];
	
	return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
