//
//  JiveOutcomeTypeTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/5/13.
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

#import "JiveOutcomeTypeTests.h"
#import "JiveOutcomeType.h"
#import "JiveObject_internal.h"

@implementation JiveOutcomeTypeTests

- (void)testToJSON {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = @[@"field"];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = @{@"key": @"resource"};
    NSString *communityAudience = @"self";
    [outcomeType setValue:fields forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:JiveOutcomeTypeAttributes.resources];
    [outcomeType setValue:communityAudience forKey:JiveOutcomeTypeAttributes.communityAudience];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.confirmExclusion];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.confirmUnmark];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.generalNote];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.noteRequired];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.shareable];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.urlAllowed];
    
    NSDictionary *JSON = [outcomeType toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqual(JSON[JiveObjectConstants.id], outcomeTypesJiveId, @"ID wrong in JSON");
}

- (void)testPersistentJSON {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = @[@"field"];
    NSString *outcomeTypesJiveId = @"345";
    NSString *outcomeTypesName = @"name";
    NSDictionary *outcomeTypeResources = @{@"key": @"resource"};
    NSString *communityAudience = @"self";
    [outcomeType setValue:fields forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:JiveOutcomeTypeAttributes.resources];
    [outcomeType setValue:communityAudience forKey:JiveOutcomeTypeAttributes.communityAudience];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.confirmExclusion];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.confirmUnmark];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.generalNote];
    
    NSDictionary *JSON = [outcomeType persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.fields][0], @"field", @"Fields wrong in JSON");
    XCTAssertEqual(JSON[JiveObjectConstants.id], outcomeTypesJiveId, @"ID wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.name], outcomeTypesName, @"Name wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.resources][@"key"], @"resource", @"Resources wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.communityAudience], communityAudience);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.confirmExclusion], @YES);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.confirmUnmark], @YES);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.generalNote], @YES);
}

- (void)testToJSON_alternate {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = @[@"field2"];
    NSString *outcomeTypesJiveId = @"777";
    NSString *outcomeTypesName = @"typeName";
    NSDictionary *outcomeTypeResources = @{@"key": @"resource2"};
    NSString *communityAudience = @"others";
    [outcomeType setValue:fields forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:JiveOutcomeTypeAttributes.resources];
    [outcomeType setValue:communityAudience forKey:JiveOutcomeTypeAttributes.communityAudience];
    
    NSDictionary *JSON = [outcomeType toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqual(JSON[JiveObjectConstants.id], outcomeTypesJiveId, @"ID wrong in JSON");
}

- (void)testPersistentJSON_alternate {
    JiveOutcomeType *outcomeType = [[JiveOutcomeType alloc] init];
    NSArray *fields = @[@"field2"];
    NSString *outcomeTypesJiveId = @"777";
    NSString *outcomeTypesName = @"typeName";
    NSDictionary *outcomeTypeResources = @{@"key": @"resource2"};
    NSString *communityAudience = @"others";
    [outcomeType setValue:fields forKey:JiveOutcomeTypeAttributes.fields];
    [outcomeType setValue:outcomeTypesJiveId forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcomeType setValue:outcomeTypesName forKey:JiveOutcomeTypeAttributes.name];
    [outcomeType setValue:outcomeTypeResources forKey:JiveOutcomeTypeAttributes.resources];
    [outcomeType setValue:communityAudience forKey:JiveOutcomeTypeAttributes.communityAudience];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.noteRequired];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.shareable];
    [outcomeType setValue:@YES forKey:JiveOutcomeTypeAttributes.urlAllowed];
    
    NSDictionary *JSON = [outcomeType persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.fields][0], @"field2", @"Fields wrong in JSON");
    XCTAssertEqual(JSON[JiveObjectConstants.id], outcomeTypesJiveId, @"ID wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.name], outcomeTypesName, @"Name wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.resources][@"key"], @"resource2", @"Resources wrong in JSON");
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.communityAudience], communityAudience);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.noteRequired], @YES);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.shareable], @YES);
    XCTAssertEqual(JSON[JiveOutcomeTypeAttributes.urlAllowed], @YES);
}

@end
