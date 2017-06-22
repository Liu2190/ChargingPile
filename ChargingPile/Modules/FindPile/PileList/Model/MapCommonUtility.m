//
//  CommonUtility.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-22.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "MapCommonUtility.h"
//#import "LineDashPolyline.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "UIActionSheet+Block.h"
#import "AppDelegate.h"
static MapCommonUtility *_instance = nil;
@implementation MapCommonUtility
+ (MapCommonUtility *)sharedInstance
{
    if(_instance == nil)
    {
        @synchronized(self)
        {
            _instance = [[MapCommonUtility alloc]init];
        }
    }
    return _instance;
}
+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil) {
        return NULL;
    }
    if (token == nil) {
        token = @",";
    }
    NSString *str = @"";
    if (![token isEqualToString:@","]) {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else {
        str = [NSString stringWithString:string];
    }
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL) {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++) {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString
{
    if (coordinateString.length == 0)
    {
        return nil;
    }
    
    NSUInteger count = 0;
    
    CLLocationCoordinate2D *coordinates = [self coordinatesForString:coordinateString
                                                     coordinateCount:&count
                                                          parseToken:@";"];
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
    
    free(coordinates), coordinates = NULL;
    
    return polyline;
}
/*
+ (MAPolyline *)polylineForStep:(AMapStep *)step
{
    if (step == nil)
    {
        return nil;
    }
    
    return [self polylineForCoordinateString:step.polyline];
}

+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine
{
    if (busLine == nil)
    {
        return nil;
    }
    
    return [self polylineForCoordinateString:busLine.polyline];
}

+(void)replenishPolylinesForWalkingWiht:(MAPolyline *)stepPolyline
                           LastPolyline:(MAPolyline *)lastPolyline
                              Polylines:(NSMutableArray *)polylines
                                Walking:(AMapWalking *)walking
{
    CLLocationCoordinate2D startCoor ;
    CLLocationCoordinate2D endCoor;
    
    CLLocationCoordinate2D points[2];
    
    [stepPolyline getCoordinates:&endCoor   range:NSMakeRange(0, 1)];
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    if (endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude)
    {
        points[0] = startCoor;
        points[1] = endCoor;
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
        LineDashPolyline *dathPolyline = [[LineDashPolyline alloc] initWithPolyline:polyline];
        dathPolyline.polyline = polyline;
        [polylines addObject:dathPolyline];
        
    }
    
}

+ (NSArray *)polylinesForWalking:(AMapWalking *)walking
{
    if (walking == nil || walking.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    [walking.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        MAPolyline *stepPolyline = [self polylineForStep:step];
        
        
        if (stepPolyline != nil)
        {
            [polylines addObject:stepPolyline];
            if (idx > 0)
            {
                [self replenishPolylinesForWalkingWiht:stepPolyline LastPolyline:[self polylineForStep:[walking.steps objectAtIndex:idx - 1]] Polylines:polylines Walking:walking];
            }
        }
        
    }];
    
    return polylines;
}

+ (void)replenishPolylinesForSegment:(NSArray *)walkingPolylines
                     busLinePolyline:(MAPolyline *)busLinePolyline
                             Segment:(AMapSegment *)segment
                           polylines:(NSMutableArray *)polylines
{
    if (walkingPolylines.count != 0)
    {
        AMapGeoPoint *walkingEndPoint = segment.walking.destination ;
        
        if (busLinePolyline)
        {
            CLLocationCoordinate2D startCoor;
            CLLocationCoordinate2D endCoor ;
            [busLinePolyline getCoordinates:&startCoor range:NSMakeRange(0, 1)];
            [busLinePolyline getCoordinates:&endCoor range:NSMakeRange(busLinePolyline.pointCount-1, 1)];
            
            if (startCoor.latitude != walkingEndPoint.latitude || startCoor.longitude != walkingEndPoint.longitude)
            {
                CLLocationCoordinate2D points[2];
                points[0] = CLLocationCoordinate2DMake(walkingEndPoint.latitude, walkingEndPoint.longitude);
                points[1] = startCoor ;
                
                MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
                LineDashPolyline *dathPolyline = [[LineDashPolyline alloc] initWithPolyline:polyline];
                dathPolyline.polyline = polyline;
                [polylines addObject:dathPolyline];
            }
        }
    }
    
}

+ (NSArray *)polylinesForSegment:(AMapSegment *)segment
{
    if (segment == nil)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    NSArray *walkingPolylines = [self polylinesForWalking:segment.walking];
    if (walkingPolylines.count != 0)
    {
        [polylines addObjectsFromArray:walkingPolylines];
    }
    
    MAPolyline *busLinePolyline = [self polylineForBusLine:[segment.buslines firstObject]];
    if (busLinePolyline != nil)
    {
        [polylines addObject:busLinePolyline];
    }
    [self replenishPolylinesForSegment:walkingPolylines busLinePolyline:busLinePolyline Segment:segment polylines:polylines];
    
    return polylines;
}

+ (void)replenishPolylinesForPathWith:(MAPolyline *)stepPolyline
                         lastPolyline:(MAPolyline *)lastPolyline
                            Polylines:(NSMutableArray *)polylines
{
    CLLocationCoordinate2D startCoor ;
    CLLocationCoordinate2D endCoor;
    
    [stepPolyline getCoordinates:&endCoor range:NSMakeRange(0, 1)];
    
    [lastPolyline getCoordinates:&startCoor range:NSMakeRange(lastPolyline.pointCount -1, 1)];
    
    
    if ((endCoor.latitude != startCoor.latitude || endCoor.longitude != startCoor.longitude ))
    {
        CLLocationCoordinate2D points[2];
        points[0] = startCoor;
        points[1] = endCoor;
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
        LineDashPolyline *dathPolyline = [[LineDashPolyline alloc] initWithPolyline:polyline];
        dathPolyline.polyline = polyline;
        [polylines addObject:dathPolyline];
    }
}

+ (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        MAPolyline *stepPolyline = [self polylineForStep:step];
        
        if (stepPolyline != nil)
        {
            [polylines addObject:stepPolyline];
            
            if (idx > 0 )
            {
                [self replenishPolylinesForPathWith:stepPolyline lastPolyline:[self polylineForStep:[path.steps objectAtIndex:idx-1]]  Polylines:polylines];
            }
        }
    }];
    
    return polylines;
}

+ (void)replenishPolylinesForTransit:(AMapSegment *)lastSegment
                      CurrentSegment:(AMapSegment * )segment
                           Polylines:(NSMutableArray *)polylines
{
    if (lastSegment)
    {
        CLLocationCoordinate2D startCoor;
        CLLocationCoordinate2D endCoor;
        
        MAPolyline *busLinePolyline = [self polylineForBusLine:[(lastSegment).buslines firstObject]];
        if (busLinePolyline != nil)
        {
            [busLinePolyline getCoordinates:&startCoor range:NSMakeRange(busLinePolyline.pointCount-1, 1)];
        }
        else
        {
            if ((lastSegment).walking && [(lastSegment).walking.steps count] != 0)
            {
                startCoor.latitude  = (lastSegment).walking.destination.latitude;
                startCoor.longitude = (lastSegment).walking.destination.longitude;
            }
            else
            {
                return;
            }
        }
        
        if ((segment).walking && [(segment).walking.steps count] != 0)
        {
            AMapStep *step = [(segment).walking.steps objectAtIndex:0];
            MAPolyline *stepPolyline = [self polylineForStep:step];
            
            [stepPolyline getCoordinates:&endCoor range:NSMakeRange(0 , 1)];
        }
        else
        {
            
            MAPolyline *busLinePolyline = [self polylineForBusLine:[(segment).buslines firstObject]];
            if (busLinePolyline != nil)
            {
                [busLinePolyline getCoordinates:&endCoor range:NSMakeRange(0 , 1)];
            }
            else
            {
                return;
            }
        }
        
        CLLocationCoordinate2D points[2];
        points[0] = startCoor;
        points[1] = endCoor ;
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:points count:2];
        LineDashPolyline *dathPolyline = [[LineDashPolyline alloc] initWithPolyline:polyline];
        dathPolyline.polyline = polyline;
        [polylines addObject:dathPolyline];
    }
}

+ (NSArray *)polylinesForTransit:(AMapTransit *)transit
{
    if (transit == nil || transit.segments.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    [transit.segments enumerateObjectsUsingBlock:^(AMapSegment *segment, NSUInteger idx, BOOL *stop) {
        
        NSArray *segmentPolylines = [self polylinesForSegment:segment];
        
        if (segmentPolylines.count != 0)
        {
            [polylines addObjectsFromArray:segmentPolylines];
        }
        if (idx >0)
        {
            [self replenishPolylinesForTransit:[transit.segments objectAtIndex:idx-1] CurrentSegment:segment Polylines:polylines];
            
        }
    }];
    
    return polylines;
}
*/
+ (MAMapRect)unionMapRect1:(MAMapRect)mapRect1 mapRect2:(MAMapRect)mapRect2
{
    CGRect rect1 = CGRectMake(mapRect1.origin.x, mapRect1.origin.y, mapRect1.size.width, mapRect1.size.height);
    CGRect rect2 = CGRectMake(mapRect2.origin.x, mapRect2.origin.y, mapRect2.size.width, mapRect2.size.height);
    
    CGRect unionRect = CGRectUnion(rect1, rect2);
    
    return MAMapRectMake(unionRect.origin.x, unionRect.origin.y, unionRect.size.width, unionRect.size.height);
}

+ (MAMapRect)mapRectUnion:(MAMapRect *)mapRects count:(NSUInteger)count
{
    if (mapRects == NULL || count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapRect unionMapRect = mapRects[0];
    
    for (int i = 1; i < count; i++)
    {
        unionMapRect = [self unionMapRect1:unionMapRect mapRect2:mapRects[i]];
    }
    
    return unionMapRect;
}

+ (MAMapRect)mapRectForOverlays:(NSArray *)overlays
{
    if (overlays.count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapRect mapRect;
    
    MAMapRect *buffer = (MAMapRect*)malloc(overlays.count * sizeof(MAMapRect));
    
    [overlays enumerateObjectsUsingBlock:^(id<MAOverlay> obj, NSUInteger idx, BOOL *stop) {
        buffer[idx] = [obj boundingMapRect];
    }];
    
    mapRect = [self mapRectUnion:buffer count:overlays.count];
    
    free(buffer), buffer = NULL;
    
    return mapRect;
}

+ (MAMapRect)minMapRectForMapPoints:(MAMapPoint *)mapPoints count:(NSUInteger)count
{
    if (mapPoints == NULL || count <= 1)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    CGFloat minX = mapPoints[0].x, minY = mapPoints[0].y;
    CGFloat maxX = minX, maxY = minY;
    
    /* Traverse and find the min, max. */
    for (int i = 1; i < count; i++)
    {
        MAMapPoint point = mapPoints[i];
        
        if (point.x < minX)
        {
            minX = point.x;
        }
        
        if (point.x > maxX)
        {
            maxX = point.x;
        }
        
        if (point.y < minY)
        {
            minY = point.y;
        }
        
        if (point.y > maxY)
        {
            maxY = point.y;
        }
    }
    
    /* Construct outside min rectangle. */
    return MAMapRectMake(minX, minY, fabs(maxX - minX), fabs(maxY - minY));
}

+ (MAMapRect)minMapRectForAnnotations:(NSArray *)annotations
{
    if (annotations.count <= 1)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapPoint *mapPoints = (MAMapPoint*)malloc(annotations.count * sizeof(MAMapPoint));
    
    [annotations enumerateObjectsUsingBlock:^(id<MAAnnotation> obj, NSUInteger idx, BOOL *stop) {
        mapPoints[idx] = MAMapPointForCoordinate([obj coordinate]);
    }];
    
    MAMapRect minMapRect = [self minMapRectForMapPoints:mapPoints count:annotations.count];
    
    free(mapPoints), mapPoints = NULL;
    
    return minMapRect;
}
- (void)showNavigationSheetWithCurrentLocation:(CLLocationCoordinate2D )currentL andDestinationLocaiton:(CLLocationCoordinate2D )destiL andDestinationTitle:(NSString *)title
{
    UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil,nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [ac addButtonWithTitle:@"高德地图"];
    }
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        [ac addButtonWithTitle:@"腾讯地图"];
    }
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        [ac addButtonWithTitle:@"百度地图"];
    }
    [ac addButtonWithTitle:@"苹果地图"];
    [ac showActionSheetWithClickBlock:^(NSInteger index)
    {
        CLLocationCoordinate2D coords2 = destiL; // 直接调用ios自己带的apple map
        if([[ac buttonTitleAtIndex: index] isEqualToString:@"高德地图"])
        {
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey], @"YGche", title, destiL.latitude, destiL.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }
        else if ([[ac buttonTitleAtIndex: index] isEqualToString:@"腾讯地图"])
        {
            NSString *urlStr = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",destiL.latitude, destiL.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];NSURL *r = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:r];
        }
        else if ([[ac buttonTitleAtIndex: index] isEqualToString:@"百度地图"])
        {
            NSString *urlString = [[NSString  stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",currentL.latitude, currentL.longitude,destiL.latitude, destiL.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }
        else if ([[ac buttonTitleAtIndex: index] isEqualToString:@"苹果地图"])
        {
            //当前的位置
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation]; //起点
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
            toLocation.name = title;
            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
            NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES}; //打开苹果自身地图应用，并呈现特定的item
            [MKMapItem openMapsWithItems:items launchOptions:   options];
        }
    }];
}
@end
