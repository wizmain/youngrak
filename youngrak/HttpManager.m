//
//  HttpManager.m
//  youngrak
//
//  Created by 김규완 on 13. 6. 5..
//  Copyright (c) 2013년 coelsoft. All rights reserved.
//

#import "HttpManager.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Constant.h"
#import "AppDelegate.h"



@implementation HttpManager

@synthesize httpClient;
@synthesize delegate;

- (id)init {
    self = [super init];
    
    if(self != nil) {
        NSURL *url = [NSURL URLWithString:kServerUrl];
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (void)dealloc {
    [httpClient release];
    [super dealloc];
}

+ (HttpManager *)sharedManager {
    static HttpManager *manager;
    
    if (manager == nil) {
        @synchronized (self) {
            manager = [[HttpManager alloc] init];
            assert(manager != nil);
        }
    }
    
    return manager;
}

- (void)login:(NSString*)userid password:(NSString*)password {
    
    NSLog(@"HttpManager login");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kLoginUrl];
    //NSLog(@"urlString=%@", urlString);
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSDictionary *result = [[NSDictionary alloc] init];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"mb_id", password,@"mb_password", nil];
    
    //[httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kLoginUrl parameters:param];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"userSession=%@",[JSON valueForKeyPath:@"userSession"]);
        
        
        if ([delegate respondsToSelector:@selector(loginResult:)]) {
            [delegate loginResult:[JSON valueForKeyPath:@"userSession"]];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"login fail");
        NSLog(@"userSession=%@",[JSON valueForKeyPath:@"userSession"]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(loginResult:)]) {
            [delegate loginResult:[JSON valueForKeyPath:@"userSession"]];
        }
    }];
    
    [operation start];
}

- (void)logout {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerUrl, kLoginUrl];
    //NSLog(@"urlString=%@", urlString);
    //NSURL *url = [NSURL URLWithString:urlString];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSDictionary *result = [[NSDictionary alloc] init];

    
    //[httpClient setParameterEncoding:AFJSONParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:kLogoutUrl parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"logout=%@",[JSON valueForKeyPath:@"userSession"]);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"logout fail");
        NSLog(@"userSession=%@",[JSON valueForKeyPath:@"userSession"]);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    
    [operation start];
}


- (void)searchUser:(NSString *)userName areaType:(NSString *)areaType {
    NSLog(@"HttpManager searchUser");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?area_type=%@&dead_name=%@", kUserSearchUrl, areaType, userName];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[entry valueForKeyPath:@"area_type"], @"area_type",
                                 [entry valueForKeyPath:@"bury_date"], @"bury_date",
                                 [entry valueForKeyPath:@"bury_no"], @"bury_no",
                                 [entry valueForKeyPath:@"dead_sex"], @"dead_sex",
                                 [entry valueForKeyPath:@"dead_name"], @"dead_name",
                                 [entry valueForKeyPath:@"dead_date"], @"dead_date",
                                 [entry valueForKeyPath:@"pay_name"], @"pay_name",
                                 [entry valueForKeyPath:@"dead_id"], @"dead_id",
                                 [entry valueForKeyPath:@"s_type"], @"s_type",
                                 [entry valueForKeyPath:@"check_type"], @"check_type", nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(searchUserResult:)]) {
            [delegate searchUserResult:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(searchUserResult:)]) {
            [delegate searchUserResult:resultList];
        }
    }];
        
    [operation start];
}

- (void)searchTribute:(NSString *)userName areaType:(NSString *)areaType {
    NSLog(@"HttpManager searchUser");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?check_type=%@&dead_name=%@", kTributeSearchUrl, areaType, userName];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"searchTribute success");
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [entry valueForKeyPath:@"image"], @"image",
                                 [entry valueForKeyPath:@"dead_name"], @"dead_name",
                                 [entry valueForKeyPath:@"dead_date"], @"dead_date",
                                 [entry valueForKeyPath:@"maker_name"], @"maker_name",
                                 [entry valueForKeyPath:@"cm1_id"], @"cm1_id",
                                 [entry valueForKeyPath:@"cm1_img"], @"cm1_img",
                                 nil];
            NSLog(@"searchTribute dic=%@", dic);
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(searchTributeResult:)]) {
            [delegate searchTributeResult:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(searchTributeResult:)]) {
            [delegate searchTributeResult:resultList];
        }
    }];
    
    [operation start];
}

- (void)requestTribute:(NSString *)deadID checkType:(NSString *)checkType areaType:(NSString *)areaType memID:(NSString *)memID {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //String query = "?ht_id=cyber_04_1&dead_id="+tomb.getDeadID()+"&mode=ins&check_type="+tomb.getCheckType()+"&area_type="+tomb.getAreaType()+"&ss_mem_id="+appEx.getUserID();
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?ht_id=cyber_04_1&dead_id=%@&mode=ins&check_type=%@&area_type=%@&ss_mem_id=%@"
                           , kTributeInsertUrl, deadID, checkType, areaType, memID];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"request result=%@",[JSON valueForKeyPath:@"result"]);
        
        if ([delegate respondsToSelector:@selector(requestTributeResult: message:)]) {
            [delegate requestTributeResult:[JSON valueForKeyPath:@"result"] message:[JSON valueForKeyPath:@"message"]];
        } else {
            NSLog(@"resposeToSelector null");
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(requestTributeResult: message:)]) {
            [delegate requestTributeResult:[JSON valueForKeyPath:@"result"] message:[JSON valueForKeyPath:@"message"]];
        } else {
            NSLog(@"resposeToSelector null");
        }
    }];
    
    [operation start];
}

- (void)requestMemoryList:(NSString *)cm1ID {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?cm1_id2=%@", kMemoryListUrl, cm1ID];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"searchTribute success");
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [entry valueForKeyPath:@"cm1_id2"], @"cm1_id2",
                                 [entry valueForKeyPath:@"cm2_id"], @"cm2_id",
                                 [entry valueForKeyPath:@"cm2_title"], @"cm2_title",
                                 [entry valueForKeyPath:@"cm2_date"], @"cm2_date",
                                 [entry valueForKeyPath:@"mb_name"], @"mb_name",
                                 [entry valueForKeyPath:@"cm2_contents"], @"cm2_contents",
                                 nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(requestMemoryListResult:)]) {
            [delegate requestMemoryListResult:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(requestMemoryListResult:)]) {
            [delegate requestMemoryListResult:resultList];
        }
    }];
    
    [operation start];

}

- (void)requestMyTributeRoom {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@", kMyTributeRoomUrl];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"searchTribute success");
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [entry valueForKeyPath:@"image"], @"image",
                                 [entry valueForKeyPath:@"dead_name"], @"dead_name",
                                 [entry valueForKeyPath:@"cm1_code"], @"cm1_code",
                                 [entry valueForKeyPath:@"dead_date"], @"dead_date",
                                 [entry valueForKeyPath:@"cm1_id"], @"cm1_id",
                                 nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(requestMyTributeRoomResult:)]) {
            [delegate requestMyTributeRoomResult:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(requestMyTributeRoomResult:)]) {
            [delegate requestMyTributeRoomResult:resultList];
        }
    }];
    
    [operation start];
}


- (void)deleteTributeRoom:(NSString *)cm1ID {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //String query = "?ht_id=cyber_04_1&dead_id="+tomb.getDeadID()+"&mode=ins&check_type="+tomb.getCheckType()+"&area_type="+tomb.getAreaType()+"&ss_mem_id="+appEx.getUserID();
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?cm1_id=%@", kTributeDeleteUrl, cm1ID];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"request result=%@",[JSON valueForKeyPath:@"result"]);
        
        if ([delegate respondsToSelector:@selector(deleteTributeRoomResult: message:)]) {
            [delegate deleteTributeRoomResult:[JSON valueForKeyPath:@"result"] message:[JSON valueForKeyPath:@"message"]];
        } else {
            NSLog(@"respondsToSelect null");
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(deleteTributeRoomResult: message:)]) {
            [delegate deleteTributeRoomResult:[JSON valueForKeyPath:@"result"] message:[JSON valueForKeyPath:@"message"]];
        } else {
            NSLog(@"respondsToSelect null");
        }
    }];
    
    [operation start];
}

- (void)requestAlbum:(NSString *)cm1ID {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = [kServerUrl stringByAppendingFormat:@"%@?cm1_id2=%@", kTributeAlbumUrl, cm1ID];
    NSString *urlStringEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@ urlStringEncoding=%@",urlString, urlStringEncoding);
    NSURL *url = [NSURL URLWithString:urlStringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"searchTribute success");
        for(id entry in JSON)
        {
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [entry valueForKeyPath:@"album_name"], @"album_name",
                                 [entry valueForKeyPath:@"id_no"], @"id_no",
                                 nil];
            
            [resultList addObject:dic];
            
        }
        
        if ([delegate respondsToSelector:@selector(requestAlbumResult:)]) {
            [delegate requestAlbumResult:resultList];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //NSLog(@"requestInterviewData fail JSON=%@", JSON);
        NSLog(@"error=%@ code=%d", error, error.code);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ([delegate respondsToSelector:@selector(requestAlbumResult:)]) {
            [delegate requestAlbumResult:resultList];
        }
    }];
    
    [operation start];
}


@end
