//
//  UZHomeScaningVC.m
//  Uzai
//
//  Created by Uzai on 15/12/29.
//  Copyright © 2015年 悠哉旅游网. All rights reserved.
//

#import "UZHomeScaningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UZQRCodeReaderView.h"
#import "UZHomeScaningLayerView.h"
@interface UZHomeScaningVC ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}
@property (nonatomic,strong) void (^scaningResults)(NSString *urlStr);
@property (nonatomic,strong) UZQRCodeReaderView *codeReaderView;
@property (nonatomic,assign) BOOL isOpen;

@end

@implementation UZHomeScaningVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
}
- (id)initWithSelect:(void(^)(NSString *urlStr))selectCityBlock
{
    self = [super init];
    if (self) {
        self.scaningResults  = selectCityBlock;
    }
    return self;
}
+ (void)showWithController:(UIViewController *)controller
                    select:(void(^)(NSString *urlStr))scaningResults

{
    UZHomeScaningVC *vc = [[UZHomeScaningVC alloc] initWithSelect:scaningResults];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    naVC.navigationBarHidden = false;
     [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [controller.navigationController presentViewController:naVC animated:YES completion:nil];
    
}

/*
 //    UZHomeScaningVC *vc=[[UZHomeScaningVC alloc]init];
 //    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
 //
 //    nav.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
 //    [self presentViewController:nav animated:true completion:nil];
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor ColorRGBWithString:bgWithTextColor]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    
    self.codeReaderView=[[UZQRCodeReaderView alloc]initWithFrame:CGRectMake(ceil(125*Main_Screen_Width/375/2), ceil((Main_Screen_Height-(Main_Screen_Width -125*Main_Screen_Width/375))/2)-64-30, (Main_Screen_Width -125*Main_Screen_Width/375), (Main_Screen_Width -125*Main_Screen_Width/375))];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]colorTransformToImage]  forBarMetrics:UIBarMetricsDefault];
    
    UZHomeScaningLayerView *layerView=[[UZHomeScaningLayerView alloc]initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height-64)];
    layerView.contextrect=self.codeReaderView.frame;
    [layerView addSubview:self.codeReaderView];
    layerView.backgroundColor=RGBACOLOR(0, 0, 0, 0.3);
    [self.view addSubview:layerView];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(X(self.codeReaderView), Y(self.codeReaderView)+HEIGHT(self.codeReaderView)+17, Main_Screen_Width-X(self.codeReaderView)*2, 20)];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16.0];
    label.text=@"请将二维码对准扫描框";
    [layerView addSubview:label];
    
    
    
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [layer insertSublayer:layerView.layer above:0];
    
    [output setRectOfInterest:[self getScanCrop:_codeReaderView.frame readerViewBounds:self.view.bounds]];
    //开始捕获
    [session startRunning];
    
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_left_scaning_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(bsBackBarClicked)];
    
    
    UIBarButtonItem *album=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_scaningAblum"] style:UIBarButtonItemStyleDone target:self action:@selector(myAlbum)];
    
    
    UIBarButtonItem *doorItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_scaning_colseDoor"] style:UIBarButtonItemStyleDone target:self action:@selector(openTorchOn:)];
    self.navigationItem.rightBarButtonItems=@[doorItem,album];

}


-(void)bsBackBarClicked
{
    [self dismissViewControllerAnimated:true completion:nil];
    [self.codeReaderView stopTimer];
    self.codeReaderView=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if ([self validateUrl:stringValue]&&[stringValue.lowercaseString rangeOfString:@"uzai.com"].location!=NSNotFound) {
            [self.codeReaderView stopTimer];
             self.scaningResults(stringValue);
            [self dismissViewControllerAnimated:false completion:nil];
           
        }else
        {
            if ([self validateUrl:stringValue]) {
                [self.codeReaderView stopTimer];
                self.scaningResults(stringValue);
                [self dismissViewControllerAnimated:false completion:nil];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:[NSString stringWithFormat:@"当前的内容是:%@",stringValue]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
    
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

#pragma mark-> 我的相册
-(void)myAlbum{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma mark-> imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    __weak UZHomeScaningVC *weakSelf=self;
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            if ([weakSelf validateUrl:scannedResult]&&[scannedResult.lowercaseString rangeOfString:@"uzai.com"].location!=NSNotFound) {
                [weakSelf.codeReaderView stopTimer];
                weakSelf.scaningResults(scannedResult);
                [weakSelf dismissViewControllerAnimated:false completion:nil];
            }else
            {
                if ([weakSelf validateUrl:scannedResult]) {
                    [weakSelf.codeReaderView stopTimer];
                   weakSelf.scaningResults(scannedResult);
                    [weakSelf dismissViewControllerAnimated:false completion:nil];
                }else
                {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:[NSString stringWithFormat:@"当前的内容是:%@",scannedResult]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    
}
#pragma mark-> 开关闪光灯

-(void)openTorchOn:(UIBarButtonItem *)item
{
    self.isOpen=!self.isOpen;
    if (_isOpen==false) {
        item.image=[UIImage imageNamed:@"btn_scaning_colseDoor"];
    }else
    {
        item.image=[UIImage imageNamed:@"btn_scaning_openDoor"];
    }
    [self turnTorchOn:self.isOpen];
}
- (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


- (BOOL)validateUrl:(NSString *) textString
{
    if ([textString hasPrefix:@"https://"]||[textString hasPrefix:@"http://"]||[textString rangeOfString:@"qianduan"].location!=NSNotFound) {
        return YES;
    }
    return false;
}

-(void)dealloc
{
    
    NSLog(@"%@类被释放了",NSStringFromClass([self class]));
    self.codeReaderView=nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.codeReaderView timerFired];
    [session startRunning];
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
