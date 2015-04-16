//
//  statusListInterfaceController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "statusListInterfaceController.h"
#import "listRowController.h"


@interface statusListInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *statusTable;

@property (strong,nonatomic) NSArray *rowItemsNames;
@end


@implementation statusListInterfaceController
- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        self.rowItemsNames = @[NSLocalizedString(@"In process",nil),NSLocalizedString(@"Finished",nil),NSLocalizedString(@"Scheduled",nil),NSLocalizedString(@"Abandoned",nil)];
        NSLog(@"02");

    }
    
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.

    
    NSLog(@"01");
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self loadTableRows];
    NSLog(@"03");


}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSString *rowData = self.rowItemsNames[rowIndex];
    
    [self pushControllerWithName:@"GoalsInterfaceController" context:rowData];
}

- (void)loadTableRows {
    [self.statusTable setNumberOfRows:self.rowItemsNames.count withRowType:@"listRow"];
    
    // Create all of the table rows.
    [self.rowItemsNames enumerateObjectsUsingBlock:^(NSString *rowData, NSUInteger idx, BOOL *stop) {
        listRowController *elementRow = [self.statusTable rowControllerAtIndex:idx];
        
        [elementRow.rowTitle setText:rowData];
    }];
}



@end



