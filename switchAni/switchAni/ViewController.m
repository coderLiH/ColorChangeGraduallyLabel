//
//  ViewController.m
//  switchAni
//
//  Created by 李允 on 15/12/7.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "LHAniLabel.h"

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet LHAniLabel *left;
@property (weak, nonatomic) IBOutlet LHAniLabel *middle;
@property (weak, nonatomic) IBOutlet LHAniLabel *right;

@property (nonatomic, strong) UIView *trView;

@property (nonatomic, weak) LHAniLabel *selLabel;

@property (nonatomic, strong) NSArray *labels;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.left addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContent:)]];
    [self.middle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContent:)]];
    [self.right addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchContent:)]];
    self.selLabel = self.middle;
    self.left.aniDuration = 0.4;
    self.middle.aniDuration = 0.4;
    self.right.aniDuration = 0.4;
    self.left.fromColor = self.middle.fromColor = self.right.fromColor = [UIColor colorWithRed:1. green:226./255 blue:226./255 alpha:1.];
    self.left.toColor = self.middle.toColor = self.right.toColor = [UIColor colorWithRed:1. green:111./255 blue:55./255 alpha:1.];
    
    self.trView = [[UIView alloc] init];
    [self.scrollView addSubview:self.trView];
    self.trView.width = self.middle.width;
    self.trView.height = 3;
    self.trView.centerX = self.view.centerX;
    self.trView.y = self.scrollView.height-self.trView.height;
    self.trView.backgroundColor = [UIColor colorWithRed:1. green:111./255 blue:55./255 alpha:1.0];
    
    self.labels = @[self.left,self.middle,self.right];
}

- (void)switchContent:(UITapGestureRecognizer *)tap {
    LHAniLabel *label = (LHAniLabel *)tap.view;
    [UIView animateWithDuration:0.4 animations:^{
        self.trView.x = tap.view.x;
        self.trView.width = tap.view.width;
    } completion:^(BOOL finished) {
        self.selLabel = label;
    }];
    
    [self.selLabel autoChangeTextColor:self.selLabel.fromColor];
    [label autoChangeTextColor:label.toColor];
    
    if ([label isEqual:self.left]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else if ([label isEqual:self.middle]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    cell.backgroundColor = indexPath.item?(indexPath.item>1?[UIColor groupTableViewBackgroundColor]:[UIColor purpleColor]):[UIColor lightGrayColor];
    return cell;
}

BOOL mark = 0;

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 && !mark) {
        mark = 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width) {
        return;
    }
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < 2*[UIScreen mainScreen].bounds.size.width) {
        NSInteger page1 = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        NSInteger page2 = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width + 1;
        
        LHAniLabel *label1 = self.labels[page1];
        LHAniLabel *label2 = self.labels[page2];
        
        CGFloat scaleX = scrollView.contentOffset.x-page1*[UIScreen mainScreen].bounds.size.width;
        
        CGFloat scale = scaleX/[UIScreen mainScreen].bounds.size.width;
        
        CGFloat eveR1 = (1-scale) * (label1.tR - label1.fR);
        CGFloat eveG1 = (1-scale) * (label1.tG - label1.fG);
        CGFloat eveB1 = (1-scale) * (label1.tB - label1.fB);

        CGFloat eveR2 = scale * (label2.tR - label2.fR);
        CGFloat eveG2 = scale * (label2.tG - label2.fG);
        CGFloat eveB2 = scale * (label2.tB - label2.fB);
        
        label1.textColor = [UIColor colorWithRed:label1.fR+eveR1 green:label1.fR+eveG1 blue:label1.fR+eveB1 alpha:1.];
        label2.textColor = [UIColor colorWithRed:label2.tR+eveR2 green:label2.tR+eveG2 blue:label2.tR+eveB2 alpha:1.];
        
        
        
        self.trView.width = label1.width+scale*(label2.width-label1.width);
        
        self.trView.x = label1.x + scale*(label2.x-label1.x);
    } else if (scrollView.contentOffset.x < 0) {
        CGFloat scaleX = -scrollView.contentOffset.x;
        CGFloat scale = 2*scaleX/[UIScreen mainScreen].bounds.size.width;
        if (scale>0.9) {
            scale=0.9;
        }
        self.trView.width = self.left.width*(1-scale);
    } else if (scrollView.contentOffset.x > 2*[UIScreen mainScreen].bounds.size.width) {
        CGFloat scaleX = scrollView.contentOffset.x-2*[UIScreen mainScreen].bounds.size.width;
        CGFloat scale = 2*scaleX/[UIScreen mainScreen].bounds.size.width;
        if (scale>0.9) {
            scale=0.9;
        }
        self.trView.width = self.right.width*(1-scale);
        self.trView.x = self.right.x+(self.right.width-self.trView.width);
    }
}
@end
