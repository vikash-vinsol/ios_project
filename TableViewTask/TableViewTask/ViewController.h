//
//  ViewController.h
//  TableViewTask
//
//  Created by Vikash Soni on 04/07/13.
//  Copyright (c) 2013 Vikash Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UITableView *tabView;
    UITextField *textField;
    NSMutableArray *initArr,*finalArray,*PsudoArray,*indexArray;
    NSMutableDictionary *dictionary;
}

@end
