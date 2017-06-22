//
//  CPDynamicBannerTableViewCell.m
//  ChargingPile
//
//  Created by RobinLiu on 16/9/5.
//  Copyright © 2016年 chargingPile. All rights reserved.
//

#import "CPDynamicBannerTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface CPDynamicBannerTableViewCell()<UIScrollViewDelegate>
{
    UIScrollView *bannerScrollView;
    NSTimer *bannerTimer;
    UIPageControl *bannerPageControl;
    int currentPageIndex;
    CGFloat bannerTimeInterval;
}
@end
@implementation CPDynamicBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CPDynamicBannerTableViewCellIdentifier";
    CPDynamicBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[CPDynamicBannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        UIImageView *placeHolerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homepage_placeHolderImage"]];
        placeHolerImage.frame = CGRectMake(0, 0, kScreenW, kBannerHeight);
        [self addSubview:placeHolerImage];
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
    CGRect frame = CGRectMake(0, 0, kScreenW, kBannerHeight);
    if(imagesArray.count == 1)
    {
        UIImageView *bannerImage = [[UIImageView alloc]init];
        bannerImage.userInteractionEnabled = YES;
        NSURL *imageUrl = [NSURL URLWithString:[[imagesArray firstObject]objectForKey:@"img"]];
        [bannerImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"homepage_placeHolderImage"]];
        bannerImage.frame = frame;
        [self addSubview:bannerImage];
        [bannerTimer invalidate];
        return;
    }
    [_imagesArray insertObject:[imagesArray objectAtIndex:(imagesArray.count-1)] atIndex:0];
    [_imagesArray addObject:[imagesArray objectAtIndex:0]];
    
    currentPageIndex = 1;
    bannerScrollView = [[UIScrollView alloc]initWithFrame:frame];
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
        NSURL *imageUrl = [NSURL URLWithString:[[_imagesArray objectAtIndex:i]objectForKey:@"img"]];
        [bannerImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"homepage_placeHolderImage"]];
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
    bannerPageControl.pageIndicatorTintColor = [UIColor blackColor];
    bannerPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:bannerPageControl];
    bannerTimeInterval = 5.0f;
    [self addTimer];
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
    if(self.delegate && [self.delegate respondsToSelector:@selector(homeBannerViewDidClick:)])
    {
        [self.delegate homeBannerViewDidClick:[[_imagesArray objectAtIndex:tapIndex]objectForKey:@"url"]];
    }
}
- (void)setTimeInterval:(CGFloat)timeInterval
{
    bannerTimeInterval = timeInterval;
    [bannerTimer invalidate];
    [self addTimer];
}
@end

