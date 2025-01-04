#import "DrMediaPickerPlugin.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DrMediaPickerPlugin () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) FlutterResult result;
@end

@implementation DrMediaPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"dr_media_picker"
              binaryMessenger:[registrar messenger]];
    DrMediaPickerPlugin* instance = [[DrMediaPickerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)pickImage {
  UIImagePickerController* picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.mediaTypes = @[(NSString*)kUTTypeImage];
  picker.delegate = self;
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (void)pickVideo {
  UIImagePickerController* picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.mediaTypes = @[(NSString*)kUTTypeMovie];
  picker.delegate = self;
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString*, id>*)info {
  NSString* filePath = ((NSURL*)info[UIImagePickerControllerMediaURL]).path;
  self.result(filePath);
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
  self.result([FlutterError errorWithCode:@"CANCELLED" message:@"User cancelled the operation" details:nil]);
  [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.result = result;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"pickPhoto" isEqualToString:call.method]) {
        [self pickImage];
    } else if ([@"pickVideo" isEqualToString:call.method]) {
        [self pickVideo];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
