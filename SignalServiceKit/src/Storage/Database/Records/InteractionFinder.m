//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "InteractionFinder.h"
#import "OWSPrimaryStorage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation YapDatabaseViewTransaction (OWS)

- (void)safe_enumerateKeysAndObjectsInGroup:(NSString *)group
                              extensionName:(NSString *)extensionName
                                withOptions:(NSEnumerationOptions)options
                                 usingBlock:(void (^)(NSString *collection,
                                                NSString *key,
                                                id object,
                                                NSUInteger index,
                                                BOOL *stop))block
{

    if (group.length < 1) {
        OWSFail(@"Invalid group.");
        return;
    }

    [self enumerateKeysAndObjectsInGroup:group
                             withOptions:options
                              usingBlock:^(NSString *collection, NSString *key, id object, NSUInteger index, BOOL *stop) {
                                  if (collection.length < 1) {
                                      [OWSPrimaryStorage incrementVersionOfDatabaseExtension:extensionName];
                                      OWSFail(@"Invalid collection.");
                                      return;
                                  }
                                  if (key.length < 1) {
                                      [OWSPrimaryStorage incrementVersionOfDatabaseExtension:extensionName];
                                      OWSFail(@"Invalid key.");
                                      return;
                                  }
                                  if (object == nil) {
                                      [OWSPrimaryStorage incrementVersionOfDatabaseExtension:extensionName];
                                      OWSFail(@"Invalid object.");
                                      return;
                                  }
                                  if (stop == nil) {
                                      [OWSPrimaryStorage incrementVersionOfDatabaseExtension:extensionName];
                                      OWSFail(@"Invalid stop.");
                                      return;
                                  }

                                  block(collection, key, object, index, stop);
                              }];
}

@end

NS_ASSUME_NONNULL_END
