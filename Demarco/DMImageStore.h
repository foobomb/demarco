//
//  DMImageStore.h
//  Demarco
//
//  Created by Harris Tang on 5/1/14.
//  Copyright (c) 2014 Harris Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMImageStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
