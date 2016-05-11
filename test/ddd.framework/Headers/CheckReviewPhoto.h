//
//  CheckReviewPhoto.h
//  Uzai
//
//  Created by UZAI on 13-7-17.
//
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@protocol CheckReviewPhotoDelegate <NSObject>
- (void)deleteReviewPhotoAtIndex:(NSInteger)index;
@end

@interface CheckReviewPhoto : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate>
{
    ALAsset *photoAsset;
    
    UIImage* picImage;
    NSInteger photoIndex;
    
    UIScrollView *imageScroll;
    UIImageView *imageView;
}

@property (nonatomic, retain)  UIImage* picImage;
@property (nonatomic, retain) ALAsset *photoAsset;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, assign) id<CheckReviewPhotoDelegate> delegate;

//- (id)initwithAssets:(ALAsset *)asset atIndex:(NSInteger)index;

@end
