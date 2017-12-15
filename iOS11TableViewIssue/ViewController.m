//
//  ViewController.m
//  iOS11TableViewIssue
//
//  Created by Demid Merzlyakov on 15.12.2017.
//  Copyright © 2017 Demid Merzlyakov. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSString *> *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [NSMutableArray new];
}

- (IBAction)generateDataPressed:(id)sender {
    NSLog(@"Generate data pressed.");
    static int startIndex = 0;
    
    const NSUInteger numberOfRecordsToGenerate = 30;
    NSString *lorem = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut purus nibh. Pellentesque at justo blandit, dignissim ipsum sit amet, finibus mauris. Curabitur sit amet libero ac justo facilisis suscipit. Suspendisse laoreet nulla lacus, quis venenatis nibh tempor vel. Suspendisse ac posuere lectus, non congue quam. Proin luctus tincidunt libero nec fringilla. Mauris ut lorem lorem. Ut metus justo, rutrum sit amet viverra ut, sodales id odio. Maecenas volutpat vel leo ullamcorper suscipit. Nam odio diam, bibendum et nibh in, sollicitudin hendrerit metus. Duis consequat sit amet quam sit amet pellentesque. Etiam semper tellus ac augue ultricies, eu blandit massa ultricies. Mauris eget eros risus. Morbi sit amet purus ornare, fermentum nisl in, cursus velit. Suspendisse in finibus tellus. Suspendisse convallis tincidunt leo vitae porta.";
    
    NSString *loremShort = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. ";
    
    for (int i = 0; i < numberOfRecordsToGenerate; ++i) {
        NSString *messageText = loremShort;
        if (i % 3 == 1) {
            messageText = lorem;
        }
        
        NSString *message = [NSString stringWithFormat:@"%d %@", startIndex + i, messageText];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.items addObject:message];
                NSIndexPath *firstCell = [NSIndexPath indexPathForRow:0 inSection:0];
                __weak typeof(self) weakSelf = self;
                [self.tableView performBatchUpdates:^{
                    [weakSelf.tableView insertRowsAtIndexPaths:@[firstCell] withRowAnimation:UITableViewRowAnimationNone];
                } completion:^(BOOL finished) {
                    
                    //Here's a way to detect such cells:
                    
//                    for (UIView *subview in self.tableView.subviews) {
//                        if ([subview isKindOfClass:[TableViewCell class]]) {
//                            TableViewCell *cell = (TableViewCell *)subview;
//                            if (![weakSelf.tableView indexPathForCell:cell]) {
//                                NSLog(@"Garbage cell detected. Highlighting red.");
//                                cell.backgroundColor = cell.contentView.backgroundColor = [UIColor redColor];
//                            }
//                        }
//                    }
                    
                    
                }];
            });
        });
        
        startIndex += numberOfRecordsToGenerate;
    }
}

- (IBAction)clearTablePressed:(id)sender {
    NSLog(@"Clear data pressed.");
    [self.items removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate & DataSource implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.labText.text = self.items[self.items.count - 1 - indexPath.row];
    return cell;
}

@end
