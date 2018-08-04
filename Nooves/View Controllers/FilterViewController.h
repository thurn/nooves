#import <UIKit/UIKit.h>

@class FilterViewController;
@protocol FilterViewDelegate

- (void)filteredArray: (NSArray *)array;
@end


@interface FilterViewController : UIViewController
- (instancetype)initWithArray:(NSArray *)array;
@property(weak, nonatomic) id <FilterViewDelegate> filterDelegate;

@end
