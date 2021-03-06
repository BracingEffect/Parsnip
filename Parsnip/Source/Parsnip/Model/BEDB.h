//
//  BEDB.h
//
//  Copyright (c) 2015 Bracing Effect, LLC. See LICENSE for details.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "BEModel.h"


@interface BEDB : NSObject

+ (void)setDebug:(BOOL)debug;
+ (BOOL)needsInitialData;

+ (FMDatabaseQueue *)queue;
+ (NSString *)pathForFiles;
+ (NSString *)pathForDB;

+ (void)loadInitialData;

+ (void)register:(Class)cls;

+ (NSString *)sqlForCreateTable:(Class)cls;
+ (NSString *)sqlForDelete:(BEModel *)model;
+ (NSString *)sqlForInsertOrReplace:(BEModel *)model;
+ (NSString *)sqlForSelect:(Class)cls parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy asc:(BOOL)asc limit:(NSUInteger)limit offset:(NSUInteger)offset;

+ (void)query:(NSString *)sql results:(void (^)(FMResultSet *results))block;
+ (void)query:(NSString *)sql parameters:(NSDictionary *)parameters results:(void (^)(FMResultSet *results))block;
+ (NSInteger)count:(NSString *)sql;
+ (NSInteger)count:(NSString *)sql parameters:(NSDictionary *)parameters;
+ (BOOL)save:(id)models;
+ (BOOL)saveInDatabase:(FMDatabase *)db model:(BEModel *)model;
+ (BOOL)remove:(id)models;
+ (BOOL)removeInDatabase:(FMDatabase *)db model:(BEModel *)model removeFiles:(BOOL)removeFiles;
+ (id)get:(Class)cls pk:(id)pk;
+ (NSArray *)get:(Class)cls parameters:(NSDictionary *)parameters;
+ (NSArray *)get:(Class)cls parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;
+ (NSArray *)get:(Class)cls parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy asc:(BOOL)asc;
+ (NSArray *)get:(Class)cls parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy asc:(BOOL)asc limit:(NSUInteger)limit offset:(NSUInteger)offset;
+ (NSArray *)getInDatabase:(FMDatabase *)db modelClass:(Class)cls parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy asc:(BOOL)asc limit:(NSUInteger)limit offset:(NSUInteger)offset;

@end
