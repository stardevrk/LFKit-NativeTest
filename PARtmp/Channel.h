//
//  Channel.h
//  PARtmp
//
//  Created by DevMaster on 8/13/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Channel : NSObject {
    NSString *_name;
    NSString *_urlAddress;
    NSString *_description;
    NSDictionary *_options;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *urlAddress;
@property (nonatomic, readonly) NSString *description;
@property (nonatomic, readonly) NSDictionary *options;

+ (id)channelWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description options:(NSDictionary *)options;
- (id)initWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description options:(NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
