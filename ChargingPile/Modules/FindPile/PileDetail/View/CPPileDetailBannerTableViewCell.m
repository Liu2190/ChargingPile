//
//  CPPileDetailBannerTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/10/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPPileDetailBannerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ColorUtility.h"
#import "ColorConfigure.h"
#import "MWPhotoBrowser.h"

@interface CPPileDetailBannerTableViewCell()<UIScrollViewDelegate>
{
    UIScrollView *bannerScrollView;
    NSTimer *bannerTimer;
    UIPageControl *bannerPageControl;
    int currentPageIndex;
    CGFloat bannerTimeInterval;
}
@end
@implementation CPPileDetailBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+ (CGFloat)cellHeight
{
    return kBannerHeight;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPPileDetailBannerTableViewCellIdentifier";
    CPPileDetailBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPPileDetailBannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *placeHolerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePageTitle"]];
        placeHolerImage.frame = CGRectMake(0, 0, kScreenW, kBannerHeight);
        [self addSubview:placeHolerImage];
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake(kScreenW - 100, 10, 100, 20);
        [_collectButton setImage:[UIImage imageNamed:@"收藏-拷贝"] forState:UIControlStateNormal];
        [self addSubview:_collectButton];
        
    }
    return self;
}
- (void)setImagesArray:(NSMutableArray *)imagesArray
{
    if(imagesArray.count < 1)
    {
        return;
    }
    _imagesArray = [[NSMutableArray alloc]init];
    [_imagesArray addObjectsFromArray:imagesArray];
    if(_imagesArray.count == 1)
    {
        UIImageView *bannerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight)];
        bannerImage.backgroundColor = [UIColor lightGrayColor];
        bannerImage.clipsToBounds = YES;
        bannerImage.contentMode = UIViewContentModeScaleAspectFill;
        if([[_imagesArray firstObject] isKindOfClass:[MWPhoto class]])
        {
            MWPhoto *model = [_imagesArray firstObject];
            [bannerImage sd_setImageWithURL:model.photoURL placeholderImage:[UIImage imageNamed:@"homePageTitle"]];
        }
        bannerImage.userInteractionEnabled = YES;
        bannerImage.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerImageDidClick:)];
        [bannerImage addGestureRecognizer:tap];
        [self addSubview:bannerImage];
        [self bringSubviewToFront:_collectButton];
        return;
    }
    [_imagesArray insertObject:[imagesArray objectAtIndex:(imagesArray.count-1)] atIndex:0];
    [_imagesArray addObject:[imagesArray objectAtIndex:0]];
    
    currentPageIndex = 1;
    bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight)];
    bannerScrollView.delegate = self;
    bannerScrollView.showsHorizontalScrollIndicator = NO;
    bannerScrollView.showsVerticalScrollIndicator = NO;
    bannerScrollView.bounces = NO;
    bannerScrollView.userInteractionEnabled = YES;
    bannerScrollView.contentSize = CGSizeMake(kScreenW*[_imagesArray count], kBannerHeight);
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.scrollsToTop = NO;
    [self addSubview:bannerScrollView];
    for(int i = 0;i<_imagesArray.count;i++)
    {
        UIImageView *bannerImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, kBannerHeight)];
        bannerImage.clipsToBounds = YES;
        bannerImage.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *imageUrl = [NSURL URLWithString:[_imagesArray objectAtIndex:i]];
        [bannerImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"homePageTitle"]];
        bannerImage.userInteractionEnabled = YES;
        bannerImage.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerImageDidClick:)];
        [bannerImage addGestureRecognizer:tap];
        [bannerScrollView addSubview:bannerImage];
    }
    [bannerScrollView setContentOffset:CGPointMake(kScreenW, 0)];
    
    bannerPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(kScreenW/2, kBannerHeight- kBannerHeight/5, kScreenW/2, kBannerHeight/5)];
    bannerPageControl.numberOfPages = _imagesArray.count-2;
    bannerPageControl.currentPage = 0;
    bannerPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    bannerPageControl.currentPageIndicatorTintColor = [ColorConfigure globalGreenColor];
    [self addSubview:bannerPageControl];
    bannerTimeInterval = 5.0f;
    [self addTimer];
    [self bringSubviewToFront:_collectButton];
}
- (void)runImagePage
{
    int page = currentPageIndex;
    page ++;
    [bannerScrollView scrollRectToVisible:CGRectMake(kScreenW *page, 0,kScreenW,kBannerHeight) animated:YES];
    if(currentPageIndex == _imagesArray.count -1)
    {
        [bannerScrollView setContentOffset:CGPointMake(kScreenW, 0)];
        bannerPageControl.currentPage = 0;
        currentPageIndex = 1;
    }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = bannerScrollView.frame.size.width;
    int page = floor((bannerScrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    currentPageIndex = page;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    bannerPageControl.currentPage=currentPageIndex - 1;
    if (currentPageIndex==0) {
        bannerPageControl.currentPage = [_imagesArray count] - 2;
        [bannerScrollView setContentOffset:CGPointMake(([_imagesArray count]-2)*kScreenW, 0)];
    }
    if (currentPageIndex==([_imagesArray count]-1)) {
        
        [bannerScrollView setContentOffset:CGPointMake(kScreenW, 0)];
        bannerPageControl.currentPage = 0;
    }
    [bannerTimer invalidate];
    [self addTimer];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    bannerPageControl.currentPage=currentPageIndex - 1;
    if (currentPageIndex==0) {
        bannerPageControl.currentPage = [_imagesArray count] - 2;
        [bannerScrollView setContentOffset:CGPointMake(([_imagesArray count]-2)*kScreenW, 0)];
    }
    if (currentPageIndex==([_imagesArray count]-1)) {
        
        [bannerScrollView setContentOffset:CGPointMake(kScreenW, 0)];
        bannerPageControl.currentPage = 0;
    }
}
- (void)addTimer
{
    bannerTimer = [NSTimer scheduledTimerWithTimeInterval:bannerTimeInterval target:self selector:@selector(runImagePage) userInfo:nil repeats:YES];
}
- (void)removeTimer
{
    [bannerTimer invalidate];
}
- (void)bannerImageDidClick:(UITapGestureRecognizer *)gest
{
    int tapIndex = (int)gest.view.tag;
    if(self.delegate && [self.delegate respondsToSelector:@selector(bannerViewDidClick:)])
    {
        [self.delegate bannerViewDidClick:tapIndex];
    }
}
- (void)setTimeInterval:(CGFloat)timeInterval
{
    bannerTimeInterval = timeInterval;
    [bannerTimer invalidate];
    [self addTimer];
}
@end

