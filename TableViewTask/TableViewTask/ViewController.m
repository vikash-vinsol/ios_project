//
//  ViewController.m
//  TableViewTask
//
//  Created by Vikash Soni on 04/07/13.
//  Copyright (c) 2013 Vikash Soni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    self.navigationItem.leftBarButtonItem = left;
    
    initArr = [[NSMutableArray alloc] init];
    indexArray =[[NSMutableArray alloc] init];
    for(char a = 'A'; a <= 'Z'; a++)
        [indexArray addObject:[NSString stringWithFormat:@"%c", a]];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (tabView.editing)
    {
        tabView.editing = !tabView.editing;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [finalArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [finalArray objectAtIndex:section];
    
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)edit:(id)sender
{
      tabView.editing = !tabView.editing;
    
}

-(IBAction)add:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Title For New Cell" message:@"\n \n" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ADD", nil];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 50, 190, 28)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [alert addSubview:textField];
    [alert show];
    [textField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[dictionary objectForKey:[finalArray objectAtIndex:section]] count];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(textField.text.length<1)
        return;
    
   [initArr addObject:textField.text];
   [initArr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
   dictionary =[[NSMutableDictionary alloc] init];
   finalArray = [[NSMutableArray alloc] init];
   
    for(NSString *var in indexArray)
   {
       NSMutableArray *arrs = [[NSMutableArray alloc] init];
       for(NSString *data in initArr)
       {
           if([[data uppercaseString] hasPrefix:var])
           {
               if(![finalArray containsObject:var])
                   [finalArray addObject:var];
               [arrs addObject:data];
           }
       }
        if([arrs count]>0)
            [dictionary setObject:arrs forKey:var];
    }
    NSLog(@"%@",dictionary);
   NSLog(@"%@",finalArray);
    [tabView reloadData];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"%@",[[dictionary objectForKey:[finalArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);
        [initArr removeObject:[[dictionary objectForKey:[finalArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
        [[dictionary objectForKey:[finalArray objectAtIndex:indexPath.section]] removeObjectAtIndex:indexPath.row];
        finalArray= [[NSMutableArray alloc] init];
        for(NSString *var in indexArray)
        {
            for(NSString *data in initArr)
            {
                if([[data uppercaseString] hasPrefix:var])
                {
                    if(![finalArray containsObject:var])
                        [finalArray addObject:var];
                }
            }
        }

        [tableView reloadData];
    }
    
  
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(100,10,200,30)];
    name.text = [[dictionary objectForKey:[finalArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [cell addSubview:name];
    
//    UIImageView *subView = [[UIImageView alloc]init];
//    subView.frame = CGRectMake(40, 8, 30, 30);
//    subView.image= [UIImage imageNamed:@"images.jpg"];
//    [name setBackgroundColor:[UIColor clearColor]];                          // Can Also use this method to add image in table view.
//    
//    [cell addSubview:subView];
   
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[dictionary objectForKey:@"images.jpg"] ofType:@"jpg"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    [name setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *name = [[dictionary objectForKey:[finalArray objectAtIndex:sourceIndexPath.section]] objectAtIndex:sourceIndexPath.row];
    [[dictionary objectForKey:[finalArray objectAtIndex:sourceIndexPath.section]] removeObjectAtIndex:sourceIndexPath.row];
    [[dictionary objectForKey:[finalArray objectAtIndex:destinationIndexPath.section]] insertObject:name atIndex:destinationIndexPath.row];
    
}

@end
