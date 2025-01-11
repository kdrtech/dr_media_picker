#import "DrMediaPickerPlugin.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@interface DrMediaPickerPlugin () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) FlutterResult result;
@end

@implementation DrMediaPickerPlugin

NSString *pemissionTitle = @"Permission Required";
NSString *pemissionMessage = @"We need access to your photos to proceed. Please enable permissions in the app settings.";
NSString *btnSettings = @"Open Settings";
NSString *btnCancel = @"Cancel";
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"dr_media_picker"
              binaryMessenger:[registrar messenger]];
    DrMediaPickerPlugin* instance = [[DrMediaPickerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)checkPhotoLibraryPermission:(void (^)(BOOL granted))completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus newStatus) {
            completion(newStatus == PHAuthorizationStatusAuthorized);
        }];
    } else if (status == PHAuthorizationStatusDenied) {
        // Permission denied - prompt to open settings
        [self promptToOpenSettings];
        completion(NO);
    } else {
        completion(status == PHAuthorizationStatusAuthorized);
    }
}
- (void)promptToOpenSettings {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: pemissionTitle
                                                                             message: pemissionMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:btnSettings
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
            [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:nil];
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:btnCancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alertController addAction:settingsAction];
    [alertController addAction:cancelAction];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)getAllImages:(FlutterResult)result {
    NSMutableArray *images = [NSMutableArray array];

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];

    [fetchResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
            if (contentEditingInput.fullSizeImageURL) {
                NSDictionary *imageInfo = @{
                    @"path": contentEditingInput.fullSizeImageURL.absoluteString,
                    @"name": asset.localIdentifier,
                    @"type": @"image/jpeg" // Adjust based on actual type
                };
                [images addObject:imageInfo];
            }
        }];
    }];

    result(images);
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
   NSURL *mediaURL = info[UIImagePickerControllerMediaURL]; // Use this for videos
   NSURL *imageURL = info[UIImagePickerControllerImageURL]; // Use this for images
   NSString *mediaType;
   NSString *filePath;
   NSString *fileName;
   NSString *fileExtension;
   NSString *mineType;

   NSMutableDictionary *resultData;
   if (mediaURL) {
        mediaType = @"video";
        filePath = mediaURL.path;
        fileName = mediaURL.lastPathComponent;
        fileExtension = mediaURL.pathExtension;
        
         NSDictionary *data  = @{
            @"path": filePath,
            @"media_type": mediaType,
            @"name": fileName,
            @"extension": fileExtension
        };
        // Convert NSDictionary to Map<String, dynamic>
         resultData = [NSMutableDictionary dictionary];
         for (NSString *key in data) {
            resultData[key] = data[key];
         }
    } else if (imageURL) {
        mediaType = @"photo";
        filePath = imageURL.path;
        fileName = imageURL.lastPathComponent;
        fileExtension = imageURL.pathExtension;
        NSString *mimeType = nil;
        if (fileExtension) {
        // Use UTType to find the MIME type
        
        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
        if (uti != NULL) {
            CFStringRef mimeTypeCF = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
            if (mimeTypeCF != NULL) {
                mimeType = (__bridge_transfer NSString *)mimeTypeCF;
            }
            CFRelease(uti);
        }
            NSLog(@"MIME Type: %@", mimeType);
        } else {
            NSLog(@"Could not determine file extension from URL.");
        }

         NSDictionary *data  = @{
            @"path": filePath,
            @"media_type": mediaType,
            @"name": fileName,
            @"mine_type": mimeType,
            @"extension": fileExtension
        };
        // Convert NSDictionary to Map<String, dynamic>
         resultData = [NSMutableDictionary dictionary];
        for (NSString *key in data) {
            resultData[key] = data[key];
        }
    }
    if (filePath) {
        self.result(resultData); // Return the image path to Flutter
        self.result = nil;      // Clear the result to avoid multiple callbacks
        //self.result(@{@"path": filePath, @"type": mediaType});  // Returning both path and type to Flutter
    } else {
        self.result([FlutterError errorWithCode:@"UNEXPECTED_ERROR" message:@"Unexpected error occurred while picking media" details:nil]);
    }
   [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
   if (self.result) {
        self.result([FlutterError errorWithCode:@"CANCELLED" message:@"User cancelled the operation" details:nil]);
        self.result = nil; // Clear the result callback
    }
  [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.result = result;
    
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"pickPhoto" isEqualToString:call.method]) {
       [self checkPhotoLibraryPermission:^(BOOL granted) {
        if (granted) {
  
            [self pickImage];
        } else {
            if (self.result) {
                self.result([FlutterError errorWithCode:@"PERMISSION_DENIED"
                                              message:@"Photo library access denied."
                                              details:nil]);
            }
        }
      }];
      //[self pickImage];
    } else if ([@"pickVideo" isEqualToString:call.method]) {
        [self pickVideo];
    } else if ([@"getAllImages" isEqualToString:call.method]) {
        [self getAllImages:result];
    } else if ([@"onConfig" isEqualToString:call.method]) {
        NSDictionary *receivedData = call.arguments;
        pemissionTitle = receivedData[@"pemission_title"];
        pemissionMessage = receivedData[@"pemission_message"];
        btnCancel = receivedData[@"btn_cancel"];
        btnSettings = receivedData[@"btn_setting"];
        result(@"Data processed");
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
