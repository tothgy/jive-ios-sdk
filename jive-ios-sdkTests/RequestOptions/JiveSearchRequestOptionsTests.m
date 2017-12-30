//
//  JiveSearchRequestOptionsTests.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchRequestOptionsTests.h"

@interface JiveSearchRequestOptions (JiveSearchRequestOptionsTests)
+ (void)setOrigin:(NSString *)origin;
@end

@implementation JiveSearchRequestOptionsTests

- (JiveSearchRequestOptions *)searchOptions {
    
    return (JiveSearchRequestOptions *)self.options;
}

- (void)setUp {
    [super setUp];
    [JiveSearchRequestOptions load];
    self.options = [[JiveSearchRequestOptions alloc] init];
}

- (void)tearDown {
    [super tearDown];
    [JiveSearchRequestOptions load];
}

- (void)testSearch {
    
    [self.searchOptions addSearchTerm:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertEqualObjects(@"origin=unknown&filter=search(dm)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    XCTAssertEqualObjects(@"origin=unknown&filter=search(dm,mention)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"(sh,a\\re)"];
    asString = [self.options toQueryString];
    XCTAssertEqualObjects(@"origin=unknown&filter=search(dm,mention,%5C%28sh%5C%2Ca%5C%5Cre%5C%29)", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"h)e(j,m"];
    asString = [self.options toQueryString];
    XCTAssertEqualObjects(@"origin=unknown&filter=search(dm,mention,%5C%28sh%5C%2Ca%5C%5Cre%5C%29,h%5C%29e%5C%28j%5C%2Cm)", asString, @"Wrong string contents");
}

- (void)testSearchWithFields {
    
    [self.searchOptions addSearchTerm:@"dm"];
    [self.searchOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertEqualObjects(@"fields=name&origin=unknown&filter=search(dm)", asString, @"Wrong string contents");
}

- (void)testSearchOrigins {
    NSString *asString;
    
    [JiveSearchRequestOptions setOrigin:@"otherOrigin"];
    
    asString = [self.options toQueryString];
    XCTAssertEqualObjects(@"origin=otherOrigin", asString, @"Wrong string contents");
    
    [self.searchOptions addSearchTerm:@"dm"];
    [self.searchOptions addField:@"name"];
    
    asString = [self.options toQueryString];
    
    XCTAssertEqualObjects(@"fields=name&origin=otherOrigin&filter=search(dm)", asString, @"Wrong string contents");
    
    [JiveSearchRequestOptions setOrigin:nil];
    
    asString = [self.options toQueryString];
    
    XCTAssertEqualObjects(@"fields=name&filter=search(dm)", asString, @"Wrong string contents");
}

- (void)testCount {
    
    NSUInteger value = 5;
    
    self.pageOptions.count = value;
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"count=5&origin=unknown", asString, @"Wrong string contents");
    
    value = 7;
    self.pageOptions.count = value;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"count=7&origin=unknown", asString, @"Wrong string contents");
}

- (void)testCountWithField {
    
    NSUInteger value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pageOptions.count = value;
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"fields=name&count=5&origin=unknown", asString, @"Wrong string contents");
}

- (void)testSort {
    
    self.sortedOptions.sort = JiveSortOrderDefault;
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedDesc;
    NSString *asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=dateCreatedDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateCreatedAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=dateCreatedAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=latestActivityDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLatestActivityAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=latestActivityAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderTitleAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=titleAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderFirstNameAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=firstNameAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLastNameAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=lastNameAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=dateJoinedDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderDateJoinedAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=dateJoinedAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderStatusLevelDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=statusLevelDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderRelevanceDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=relevanceDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderUpdatedAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=updatedAsc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderUpdatedDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"sort=updatedDesc&origin=unknown", asString, @"Wrong string contents");
    
    self.sortedOptions.sort = JiveSortOrderLastProfileUpdateDesc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString);
    XCTAssertEqualObjects(@"sort=lastProfileUpdateDesc&origin=unknown", asString);
    
    self.sortedOptions.sort = JiveSortOrderLastProfileUpdateAsc;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString);
    XCTAssertEqualObjects(@"sort=lastProfileUpdateAsc&origin=unknown", asString);
}

- (void)testSortWithField {
    
    NSString *testField = @"name";
    [self.pageOptions addField:testField];
    self.sortedOptions.sort = JiveSortOrderDateCreatedAsc;
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"fields=name&sort=dateCreatedAsc&origin=unknown", asString, @"Wrong string contents");
}

- (void)testInvalidSort {
}

- (void)testNoFields {
}

- (void)testSingleField {
    
    NSString *testField = @"name";
    
    [self.options addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"fields=name&origin=unknown", asString, @"Wrong string contents");
}

- (void)testMultipleFields {
    
    NSString *testField1 = @"familyName";
    NSString *testField2 = @"givenName";
    NSString *testField3 = @"emails";
    
    [self.options addField:testField1];
    [self.options addField:testField2];
    [self.options addField:testField3];
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"fields=familyName,givenName,emails&origin=unknown", asString, @"Wrong string contents");
}

- (void)testStartIndex {
    
    NSUInteger value = 5;
    
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"startIndex=5&origin=unknown", asString, @"Wrong string contents");
    
    value = 7;
    self.pagedOptions.startIndex = value;
    asString = [self.options toQueryString];
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"startIndex=7&origin=unknown", asString, @"Wrong string contents");
}

- (void)testStartIndexWithField {
    
    NSUInteger value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    XCTAssertNotNil(asString, @"Invalid string returned");
    XCTAssertEqualObjects(@"fields=name&startIndex=5&origin=unknown", asString, @"Wrong string contents");
}

@end
