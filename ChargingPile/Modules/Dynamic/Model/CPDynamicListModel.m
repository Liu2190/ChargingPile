//
//  CPDynamicListModel.m
//  ChargingPile
//
//  Created by RobinLiu on 2016/10/11.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicListModel.h"
#import "NSDictionary+Additions.h"

@implementation CPDynamicListModel
- (id)initWith:(NSDictionary *)dict
{
    if(self = [super init])
    {
        /*
         content = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\naaaaaaaaaaaa";
         createTime = 1475933463000;
         id = 1;
         image = "D:/upload/images/2016/10/1475933462317_s.jpg";
         subTitle = aaaa;
         thumbnail = "D:/upload/images/2016/10/1475933462317_t.jpg";
         title = aaaa;
         */
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY.MM.dd"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dict stringValueForKey:@"createTime"] doubleValue]/1000];
        _createTime = [formatter stringFromDate:confromTimesp];
        _dynamicId = [dict stringValueForKey:@"id"];
        _title = [dict stringValueForKey:@"title"];
        _subTitle = [dict stringValueForKey:@"subTitle"];
        _content = [dict stringValueForKey:@"content"];
    }
    return self;
}
@end
