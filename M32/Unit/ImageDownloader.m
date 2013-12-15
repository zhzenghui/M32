//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "ImageDownloader.h"
#import "ZHFileCache.h"


// 1: Declare a private interface, so you can change the attributes of instance variables to read-write.
@interface ImageDownloader () {
    double totalTime;
}
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) Images *imageRecord;
@property (nonatomic, readwrite, strong) Picture *pictureRecord;
@property (nonatomic, readwrite, strong) Content *contentRecord;

@end


@implementation ImageDownloader
@synthesize delegate = _delegate;
@synthesize imageRecord = _imageRecord;

#pragma mark -
#pragma mark - Life Cycle

static int down_count = 0;

- (id)initWithPhotoRecord:(Images *)record  delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.imageRecord = record;
    }
    return self;
}


- (id)initWithPictureRecord:(Picture *)record  delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.pictureRecord = record;
    }
    return self;
}



- (id)initWithContentRecord:(Content *)record  delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.contentRecord = record;
    }
    return self;
}


- (void)haroFinish:(NSData *)data content:(Content *)content
{
    
    ZHFileCache *zfc = [[ZHFileCache alloc] init];
    
    [zfc saveFile:data fileName:content.name];
    
    

}


- (void)haroFinish:(NSData *)data picture:(Picture *)picture
{
    
    ZHFileCache *zfc = [[ZHFileCache alloc] init];
    
    [zfc saveFile:data fileName:picture.name];
    
    

}

- (void)dyrsFinish:(NSData *)data image:(Images *)image
{
    self.imageRecord.status = 2;
    
    
    ZHFileCache *zfc = [[ZHFileCache alloc] init];
    
    [zfc saveFile:data image:self.imageRecord];
    
    

    
}

- (NSData *)downLoad:(NSString *)pathUrlString
{
    
//    double startTime = CACurrentMediaTime(); // Start measuring time

    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: pathUrlString]];
    
    if (self.isCancelled) {

        imageData = nil;
        return nil;
    }
//
//    
//    double elapsedTime = (CACurrentMediaTime() - startTime); // Measuring time
//    totalTime += elapsedTime; // Measuring total time HERE!
//    //      速度
//    //
//    
//    //        DLog(@"%d", @"%d", [imageData length] , totalTime);
//    
//    
//    
    if (imageData) {
//
//        if (KisHaro) {
//            if (self.pictureRecord) {
//                [self haroFinish:imageData picture:self.pictureRecord];
//            }
//            if (self.contentRecord) {
//                [self haroFinish:imageData content:self.contentRecord];
//            }
//            
//        }
//        else if (KisDyrs) {
//            
            [self dyrsFinish:imageData image:self.imageRecord];
            return imageData;
//        }
        
    }
    else {
        imageData = nil;
        return nil;

        DLog(@"下载失败 %d：%@：%@", down_count,self.imageRecord.name, self.imageRecord.url);
    }

    imageData = nil;
    
    return nil;
}

#pragma mark -
#pragma mark - Downloading image

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main {
    
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        if (self.isCancelled)
            return;

        
        
        NSString *pathUrlString = [NSString string];
        
        if (self.imageRecord) {
            pathUrlString = self.imageRecord.url;
        }
        
        if (self.pictureRecord) {
            pathUrlString = self.pictureRecord.url;
        }
        
        if (self.contentRecord) {
            pathUrlString = [NSString stringWithFormat:@""];
        }
        
        if (  ! [self downLoad:pathUrlString]) {
                down_count  = 1;
            if (  ! [self downLoad:pathUrlString]) {
                    down_count  = 2;
                if (  ! [self downLoad:pathUrlString]) {
                    down_count  = 3;
                    if (  ! [self downLoad:pathUrlString]) {
                        down_count  = 4;
                        [self downLoad:pathUrlString];
                        
                    }
                }
                
            }
                    
        }


        
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end


