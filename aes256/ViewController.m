//
//  ViewController.m
//  aes256
//
//  Created by Rock Kang(cserock@gmail.com) on 2014. 4. 25..
//
//

#import "ViewController.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import <CommonCrypto/CommonDigest.h>

// key for encrypt
static const NSString *ENCRYPT_KEY  = @"abcdefghijklmnopqrstuvwxyz012345";

// server url
static const NSString *SERVER_URL    = @"http://test.com";

// sample text
static const NSString *SAMPLE_PLAIN_TEXT    = @"[{\"id\":\"2\",\"nickname\":\"cserock\",\"gender\":\"M\",\"age\":\"33\"}]";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_plainTextField setText:(NSString*)SAMPLE_PLAIN_TEXT];
    
    _resultEncrypt.userInteractionEnabled = NO;
    _resultData.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * encrypt
 */
- (IBAction)encrypt:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [_resultEncrypt setText:@""];
    
    NSString *plainText = [_plainTextField.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
    
    NSString *encryptedText = @"";
    NSData *cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:(NSString*)ENCRYPT_KEY];
    NSString *tmpEncryptedText = [cipherData base64EncodedString];
    
    encryptedText = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (CFStringRef)tmpEncryptedText,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8 ));
    
    NSLog(@"encryptedText : %@", encryptedText);
    
    [_resultEncrypt setText:encryptedText];
}

/**
 * send to server
 */
- (IBAction)send:(UIButton *)sender {
    
    @try {
        
        [self.view endEditing:YES];
        [_resultData setText:@""];
        
        NSString *encryptedText = [_resultEncrypt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/aes_test.php?token=%@", SERVER_URL, encryptedText];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setHTTPMethod:@"GET"];
        
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSMutableData *d = [NSMutableData data];
        [d appendData:responseData];
        //NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
        NSString *returnData = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
        
        NSLog(@"resultText from server: : %@", returnData);
        
        [_resultData setText:returnData];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
        [self alertNetworkError];
    }
    
}

/**
 * alert network error
 */
- (void) alertNetworkError {
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Network connection" message:@"Please check your connection."
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Check",nil) otherButtonTitles: nil];
    [alert show];
}

/**
 * hide keyboard
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
