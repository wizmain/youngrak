//
//  HttpManager.h
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPClient;

@protocol HttpManagerDelegate <NSObject>

@required

@optional
- (void)loginResult:(NSDictionary *)result;
- (void)searchUserResult:(NSMutableArray *)result;
- (void)requestTributeResult:(NSString *)result message:(NSString*)message;
- (void)searchTributeResult:(NSMutableArray*)result;
- (void)requestMemoryListResult:(NSMutableArray*)result;
- (void)requestMyTributeRoomResult:(NSMutableArray*)result;
- (void)deleteTributeRoomResult:(NSString*)result message:(NSString*)message;
- (void)requestAlbumResult:(NSMutableArray *)result;

@end

@interface HttpManager : NSObject {
    id<HttpManagerDelegate> delegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain, readonly) AFHTTPClient *httpClient;

+ (HttpManager *)sharedManager;

- (void)login:(NSString*)userid password:(NSString*)password;
- (void)searchUser:(NSString *)userName areaType:(NSString*)areaType;
- (void)logout;
- (void)requestTribute:(NSString*)deadID checkType:(NSString*)checkType areaType:(NSString*)areaType memID:(NSString*)memID;
- (void)searchTribute:(NSString *)userName areaType:(NSString *)areaType;
- (void)requestMemoryList:(NSString*)cm1ID;
- (void)requestMyTributeRoom;
- (void)deleteTributeRoom:(NSString*)cm1ID;
- (void)requestAlbum:(NSString*)cm1ID;

@end
