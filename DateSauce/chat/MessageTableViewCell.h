#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, readwrite, strong) IBOutlet UITextView *message;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *timestampLabel;

@end
