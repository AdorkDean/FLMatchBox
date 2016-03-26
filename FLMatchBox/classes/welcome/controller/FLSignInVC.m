//
//  FLSignInVC.m
//  FLMatchBox
//
//  Created by asddfg on 16/3/15.
//  Copyright © 2016年 fabian. All rights reserved.
//

#import "FLSignInVC.h"
#import "FLSignUpVC.h"
#import "FLLogin.h"

#import "FLThreeSignInView.h"
#import "FLLoginRespoParam.h"

#import "FLHttpTool.h"
#import <MJExtension/MJExtension.h>



#define APPW [UIScreen mainScreen].bounds.size.width
#define APPH [UIScreen mainScreen].bounds.size.height

@interface FLSignInVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UITextField *PSWtf;

@property (weak, nonatomic) IBOutlet UIButton *LogInBtn;

@property (weak, nonatomic) IBOutlet UIButton *pswHelpBtn;

@property (weak, nonatomic) IBOutlet FLLogin *customView;

@property (copy, nonatomic) NSString *psw;
@property (copy, nonatomic) NSString *phoneNum;


@property (nonatomic, weak) FLThreeSignInView *threeView;

@end

@implementation FLSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    self.customView.phoneNum.delegate = self;
    self.PSWtf.delegate = self;
    
   // [self setUpThreeView];
    
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.rightBarButtonItem.customView.hidden = self.hideRightBarItem;
   
}


- (void)gotoRegister
{
    FLSignUpVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FLSignUpVC"];
    [vc setValue:@YES forKey:@"hideRightBarItem"];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)setUpThreeView
{
    FLThreeSignInView *threeView = [[[NSBundle mainBundle]loadNibNamed:@"FLThreeSignInView" owner:nil options:nil] lastObject];
    threeView.frame = CGRectMake(0,self.view.bounds.size.height - 100 ,self.view.bounds.size.width , 100);
    self.threeView = threeView;
    [self.view addSubview:threeView];
}
- (IBAction)loginBtnClick:(id)sender
{
    //
    NSDictionary *param = @{@"password":self.PSWtf.text,
                             @"name":_customView.phoneNum.text };
    
    [FLHttpTool postWithUrlString:[NSString stringWithFormat:@"%@/Matchbox/useruserlogin",BaseUrl] param:param success:^(id responseObject) {
        FLLog(@"%@",responseObject);
        NSDictionary *result = responseObject;
        if ([result[@"result"] integerValue] == 0) {
            
           // FLLoginRespoParam *loginRespoParam = [FLLoginRespoParam paramWithDict:result];
            
          
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FLTabBarController"];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:result[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
   }



- (void)dealloc
{
     FLLog(@"%s",__func__);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.PSWtf) {
        self.psw = tempStr;
    }else if (textField == self.customView.phoneNum){
        self.phoneNum = tempStr;
        
    }
    
    
    if (self.psw.length >= 6 && self.phoneNum.length == 11) {
        
        self.LogInBtn.enabled = YES;
        self.LogInBtn.backgroundColor = [UIColor colorWithRed:66/255.0 green:83/255.0 blue:86/255.0 alpha:1];
        
        
    }else{
        self.LogInBtn.enabled = NO;
        self.LogInBtn.backgroundColor = [UIColor colorWithRed:196/255.0 green:204/255.0 blue:203/255.0 alpha:1];
        
    }
    
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
