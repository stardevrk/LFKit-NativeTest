//
//  Channel.m
//  PARtmp
//
//  Created by DevMaster on 8/13/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import "Channel.h"

@implementation Channel

@synthesize name = _name;
@synthesize urlAddress = _urlAddress;
@synthesize description = _description;
@synthesize options = _options;

+ (id)channelWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description options:(NSDictionary *)options {
    return [[self alloc] initWithName:name addr:addr description:description options:options];
}

- (id)initWithName:(NSString *)name addr:(NSString *)addr description:(NSString *)description options:(NSDictionary *)options {
    self = [super init];
    if (self) {
        _name = name;
        _urlAddress = addr ;
        _description = description;
        _options = options;
    }
    return self;
}

@end
