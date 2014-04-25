//
//  ViewController.h
//  aes256
//
//  Created by Rock Kang(cserock@gmail.com) on 2014. 4. 25..
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *plainTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultEncrypt;
@property (weak, nonatomic) IBOutlet UITextView *resultData;
- (IBAction)encrypt:(UIButton *)sender;
- (IBAction)send:(UIButton *)sender;
@end
