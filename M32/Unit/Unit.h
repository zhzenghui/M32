//
//  Unit.h
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//




//typedef NS_ENUM(NSInteger, statue) {
//    statue_success = 100,
//    statue_failure = 101
//};




typedef enum {
    FavType_News,
    FavType_Law = 1,
    FavType_Daily = 2,
    
    
} FavType;


typedef enum {
    //    dyrs
    AccessoriesTable     = -1,
    CasesTable           = 1,
    CategoryTable        = 2,
    ChannelTable         = 3,
    Channel_viewTable    = 4,
    DepartmentTable      = 5,
    ImagesTable          = 6,
    MemberTable          = 7,
    UserTable            = 8,
    ValuesTable          = 9,
    
    //    haro
    CategoryHaroTable,
    ContentTable,
    CustomTable,
    DistrictTable,
    FavoriteTable,
    LayerTable,
    PictureTable,
    ProductTable,
    SceneTable,
    UserHaroTable,
    User_loginTable
    
} Tables_name;



#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)?YES:NO

CG_INLINE CGRect
NavitionRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    if (iOS7) {
        rect.origin.x = x; rect.origin.y = y;
    }
    else {
        rect.origin.x = x; rect.origin.y = y-20;
        
    }
    rect.size.width = width; rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
RectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    if (iOS7) {
        rect.origin.x = x; rect.origin.y = y+20;
    }
    else {
        rect.origin.x = x; rect.origin.y = y;
        
    }
    rect.size.width = width; rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
NavitionRectMake2x(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    if (iOS7) {
        rect.origin.x = x/2; rect.origin.y = y/2;
    }
    else {
        rect.origin.x = x/2; rect.origin.y = (y/2)-40;
        
    }
    rect.size.width = width/2; rect.size.height = height/2;
    return rect;
}

CG_INLINE CGRect
RectMake2x(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    if (iOS7) {
        rect.origin.x = x/2; rect.origin.y = y/2;
    }
    else {
        rect.origin.x = x/2; rect.origin.y = y/2;
        
    }
    rect.size.width = width/2; rect.size.height = height/2;
    return rect;
}

CG_INLINE CGRect
RectMake_20_2x(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    if (iOS7) {
        rect.origin.x = x/2; rect.origin.y = y/2;
    }
    else {
        rect.origin.x = x/2; rect.origin.y = (y/2)-20;
        
    }
    rect.size.width = width/2; rect.size.height = height/2;
    return rect;
}


#define Statue_success @"100"
#define statue_failure @"101"


#define color(r, g, b) [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1]
#define colorAlpha(r, g, b, a) [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a]


#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height


#define CREEN   CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)
#define SCROLLVIEW_SIZE(NUM)       CGSizeMake(NUM*1024, 768)



#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

#define MAINBUNDLE [NSBundle mainBundle]


#define IMAGESIZEWIDTH(img) img.size.width/2
#define IMAGESIZEHEIGHT(img) img.size.height/2

#define IMAGEVIEWSIZEWIDTH(imgView) imgView.image.size.width/2
#define IMAGEVIEWSIZEHEIGHT(imgView) imgView.image.size.height/2

#define BUTTONSIZEWIDTH(BTN) BTN.frame.size.width
#define BUTTONSIZEHEIGHT(BTN) BTN.frame.size.height


#define KNSUserDefaults [NSUserDefaults standardUserDefaults] 

#define KCurrentUser @"currentUser"
#define KCurrentUser_version @"version"

#define KDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define KDocumentDirectoryFiles [KDocumentDirectory stringByAppendingPathComponent:@"/files"]
#define KDocumentName(fileName) [NSString stringWithFormat:@"%@/%@",  KDocumentDirectoryFiles ,fileName]


#define KProjectNameHaro @"haro"
#define KProjectNameDyrs @"Dyrs"

#define KCurrentProjectName @"Dyrs"


#define SDWIRetain(__v) ([__v retain]);
#define SDWIReturnRetained SDWIRetain

#define SDWIRelease(__v) ([__v release]);
#define SDWISafeRelease(__v) ([__v release], __v = nil);
#define SDWISuperDealoc [super dealloc];


#define KisHaro [KCurrentProjectName isEqualToString:KProjectNameHaro]
#define KisDyrs [KCurrentProjectName isEqualToString:KProjectNameDyrs]




#define SharedAppDelegate ((MMAppDelegate *)[[UIApplication sharedApplication] delegate])
#define SharedApplication [UIApplication sharedApplication]

#define SharedAppUser ((MMAppDelegate *)[[UIApplication sharedApplication] delegate]).user


#define Kinsert @"1"
#define Kdelete @"2"
#define Kupdate @"3"



#define KPageSize 10
#define KDuration .3
#define KLongDuration .8


#define KUrl @"http://115.29.37.109/"

#define KHomeUrl @"http://115.29.37.109/api/"
//#define KHomeUrl @"http://192.168.1.116:8080/"



//  淘宝

#define KTaoBaoAppKey @"21584394"
#define KTaoBaoSecert @"bbff717c92a7d3cdbe99e901cf8057d9"

#define KAppredirect_uri @"http://gediaoer.com"
#define KTaoBaoCallbackUrl @"gediaoercallback://"



#define KwxAppID @"wxcbbd54d946343054"
#define KwxAppKey @"2338c93f0688b3085753d1179ccdba5d"




#define kSinaAppKey         @"2211441265"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"



