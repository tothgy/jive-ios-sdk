//
//  JiveCategory.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveCategoryTests.h"
#import "JiveResourceEntry.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveCategoryTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveCategory alloc] init];
}

- (JiveCategory *)category {
    return (JiveCategory *)self.typedObject;
}

- (void)testToJSON {
    NSString *description = @"description";
    NSNumber *followerCount = [NSNumber numberWithInt:7];
    NSString *jiveId = @"1234";
    NSNumber *likeCount = [NSNumber numberWithInt:4];
    NSString *name = @"name";
    NSString *place = @"/place/54321";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *tag = @"First";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSDictionary *JSON = [self.category toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], @"category", @"Wrong type");
    
    [self.category setValue:description forKey:@"jiveDescription"];
    [self.category setValue:followerCount forKey:@"followerCount"];
    [self.category setValue:jiveId forKey:@"jiveId"];
    [self.category setValue:likeCount forKey:@"likeCount"];
    [self.category setValue:name forKey:@"name"];
    [self.category setValue:place forKey:@"place"];
    [self.category setValue:published forKey:@"published"];
    [self.category setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.category setValue:@"type" forKey:@"type"];
    [self.category setValue:updated forKey:@"updated"];
    
    JSON = [self.category toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"description"], description, @"Wrong description.");
    XCTAssertEqualObjects([JSON objectForKey:@"name"], name, @"Wrong name.");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.category.type, @"Wrong type");
}

- (void)testToJSON_alternate {
    NSString *description = @"alternate";
    NSNumber *followerCount = [NSNumber numberWithInt:17];
    NSString *jiveId = @"5432";
    NSNumber *likeCount = [NSNumber numberWithInt:40];
    NSString *name = @"place";
    NSString *place = @"/content/76543";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSString *tag = @"Gigantic";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:0];
    
    [self.category setValue:description forKey:@"jiveDescription"];
    [self.category setValue:followerCount forKey:@"followerCount"];
    [self.category setValue:jiveId forKey:@"jiveId"];
    [self.category setValue:likeCount forKey:@"likeCount"];
    [self.category setValue:name forKey:@"name"];
    [self.category setValue:place forKey:@"place"];
    [self.category setValue:published forKey:@"published"];
    [self.category setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.category setValue:updated forKey:@"updated"];
    
    NSDictionary *JSON = [self.category toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"description"], description, @"Wrong description.");
    XCTAssertEqualObjects([JSON objectForKey:@"name"], name, @"Wrong name.");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.category.type, @"Wrong type");
}

- (void)testCategoryParsing {
    NSString *photoURI = @"http://dummy.com/photo.png";
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:11];
    NSString *description = @"description";
    NSNumber *followerCount = [NSNumber numberWithInt:7];
    NSString *jiveId = @"1234";
    NSNumber *likeCount = [NSNumber numberWithInt:4];
    NSString *name = @"name";
    NSString *place = @"/place/54321";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *tag = @"First";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [JSON setValue:description forKey:@"description"];
    [JSON setValue:followerCount forKey:@"followerCount"];
    [JSON setValue:jiveId forKey:@"jiveId"];
    [JSON setValue:likeCount forKey:@"likeCount"];
    [JSON setValue:name forKey:@"name"];
    [JSON setValue:place forKey:@"place"];
    [JSON setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [JSON setValue:@"type" forKey:@"type"];
    [JSON setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    self.object = [JiveCategory objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([self.category class], [JiveCategory class], @"Wrong item class");
    XCTAssertEqualObjects(self.category.jiveDescription, description, @"Wrong description");
    XCTAssertEqualObjects(self.category.followerCount, followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(self.category.jiveId, jiveId, @"Wrong id");
    XCTAssertEqualObjects(self.category.likeCount, likeCount, @"Wrong likeCount");
    XCTAssertEqualObjects(self.category.name, name, @"Wrong name");
    XCTAssertEqualObjects(self.category.place, place, @"Wrong place");
    XCTAssertEqualObjects(self.category.published, published, @"Wrong published date");
    XCTAssertEqualObjects(self.category.type, @"category", @"Wrong type");
    XCTAssertEqualObjects(self.category.updated, updated, @"Wrong updated date");
    XCTAssertEqual([self.category.tags count], (NSUInteger)1, @"Wrong number of tag objects");
    XCTAssertEqualObjects([self.category.tags objectAtIndex:0], tag, @"Wrong tag object");
    XCTAssertEqual([self.category.resources count], (NSUInteger)1, @"Wrong number of resource objects");
    XCTAssertEqualObjects([[(JiveResourceEntry *)[self.category.resources objectForKey:resourceKey] ref] absoluteString], photoURI, @"Wrong resource object");
}

- (void)testCategoryParsingAlternate {
    NSString *photoURI = @"http://com.dummy/png.photo";
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    NSMutableDictionary *JSON = [NSMutableDictionary dictionaryWithCapacity:11];
    NSString *description = @"alternate";
    NSNumber *followerCount = [NSNumber numberWithInt:17];
    NSString *jiveId = @"5432";
    NSNumber *likeCount = [NSNumber numberWithInt:40];
    NSString *name = @"place";
    NSString *place = @"/content/76543";
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:1000.123];
    NSString *tag = @"Gigantic";
    NSDate *updated = [NSDate dateWithTimeIntervalSince1970:0];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [JSON setValue:description forKey:@"description"];
    [JSON setValue:followerCount forKey:@"followerCount"];
    [JSON setValue:jiveId forKey:@"jiveId"];
    [JSON setValue:likeCount forKey:@"likeCount"];
    [JSON setValue:name forKey:@"name"];
    [JSON setValue:place forKey:@"place"];
    [JSON setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [JSON setValue:@"type" forKey:@"type"];
    [JSON setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    self.object = [JiveCategory objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([self.category class], [JiveCategory class], @"Wrong item class");
    XCTAssertEqualObjects(self.category.jiveDescription, description, @"Wrong description");
    XCTAssertEqualObjects(self.category.followerCount, followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(self.category.jiveId, jiveId, @"Wrong id");
    XCTAssertEqualObjects(self.category.likeCount, likeCount, @"Wrong likeCount");
    XCTAssertEqualObjects(self.category.name, name, @"Wrong name");
    XCTAssertEqualObjects(self.category.place, place, @"Wrong place");
    XCTAssertEqualObjects(self.category.published, published, @"Wrong published date");
    XCTAssertEqualObjects(self.category.type, @"category", @"Wrong type");
    XCTAssertEqualObjects(self.category.updated, updated, @"Wrong updated date");
    XCTAssertEqual([self.category.tags count], (NSUInteger)1, @"Wrong number of tag objects");
    XCTAssertEqualObjects([self.category.tags objectAtIndex:0], tag, @"Wrong tag object");
    XCTAssertEqual([self.category.resources count], (NSUInteger)1, @"Wrong number of resource objects");
    XCTAssertEqualObjects([[(JiveResourceEntry *)[self.category.resources objectForKey:resourceKey] ref] absoluteString], photoURI, @"Wrong resource object");
}

@end
