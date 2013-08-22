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
    {
        [indexArray addObject:[NSString stringWithFormat:@"%c", a]];
    }
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

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"%i",[finalArray indexOfObject:title]);
    return [finalArray indexOfObject:title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)edit:(id)sender
{
    [tabView setEditing:!tabView.editing animated:YES];
    
}

-(IBAction)add:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Title For New Cell" message:@"\n \n" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ADD", nil];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 50, 190, 30)];
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
    NSLog(@"%@",finalArray);
    [tabView reloadData];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = [[dictionary objectForKey:[finalArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
   
    UIImage* theImage = [UIImage imageNamed:@"images.jpg"];
    
    cell.imageView.image = theImage;
    return cell;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *name = [[dictionary objectForKey:[finalArray objectAtIndex:sourceIndexPath.section]] objectAtIndex:sourceIndexPath.row];
    [[dictionary objectForKey:[finalArray objectAtIndex:sourceIndexPath.section]] removeObjectAtIndex:sourceIndexPath.row];
    [[dictionary objectForKey:[finalArray objectAtIndex:destinationIndexPath.section]] insertObject:name atIndex:destinationIndexPath.row];
}
@end
