//
//  BaseTableViewCell.h
//  ChargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define RESET_CELL_INTERACTION_BLOCK_DURATION 1.2f

@interface BaseTableViewCell : UITableViewCell
{
    id _object;
}
@property (nonatomic,weak)id delegate;
@property (nonatomic,copy)NSIndexPath *indexPath;
@property (nonatomic,assign)BOOL userInteractionBlockSafe;
@property (nonatomic,strong)id object;

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;
- (void)startObserveObjectProperty;
- (void)finishObserveObjectProperty;

- (void)addObservedProperty:(NSString *)property;
- (void)removeObservedProperty:(NSString *)property;
- (void)objectPropertyChanged:(NSString *)property;
- (void)detachInteractionBlock;
- (void)cancelInteractionBlock;

@end
