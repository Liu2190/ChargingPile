//
//  BaseTableViewCell.m
//  ChargingPile
//
//  Created by chargingPile on 15/1/28.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "BaseTableViewCell.h"
#define kDEFAULT_TABLEVIEW_CELL_HEIGHT 44.0F
#define kTABLEVIEWCELLDEBUG 0
@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionBlockSafe = NO;
    }
    return self;
}
- (void)dealloc
{
    self.indexPath = nil;
}
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    return kDEFAULT_TABLEVIEW_CELL_HEIGHT;
}
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    //debug
    if (kTABLEVIEWCELLDEBUG) {
        //[self markBorderWithRandomColorRecursive];
    }
}
#pragma mark - properties

- (void)setObject:(id)object
{
    if (object != _object) {
        if (_object) {
            [self finishObserveObjectProperty];
        }
        
        _object = object;
        if (_object)
            [self startObserveObjectProperty];
    }
}

#pragma mark Object Property Observer

- (void)startObserveObjectProperty
{
    
}

- (void)finishObserveObjectProperty
{
    
}

- (void)addObservedProperty:(NSString *)property {
    
    [_object addObserver:self forKeyPath:property
                 options:NSKeyValueObservingOptionNew
                 context:nil];
}

- (void)removeObservedProperty:(NSString *)property {
    
    [_object removeObserver:self forKeyPath:property];
}

- (void)objectPropertyChanged:(NSString *)property {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object != _object) {
        [object removeObserver:self forKeyPath:keyPath];
    }
    else {
        [self objectPropertyChanged:keyPath];
    }
}

- (void)detachInteractionBlock
{
    self.userInteractionEnabled = NO;
    [NSThread detachNewThreadSelector:@selector(cancelInteractionBlock) toTarget:self withObject:nil];
}

- (void)cancelInteractionBlock
{
    if (![NSThread isMainThread]) {
        [NSThread sleepForTimeInterval:RESET_CELL_INTERACTION_BLOCK_DURATION];
        self.userInteractionEnabled = YES;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.userInteractionBlockSafe) {
        [self detachInteractionBlock];
    }
    [super touchesEnded:touches withEvent:event];
}

@end
