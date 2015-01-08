//
//  JiveDocument.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveStructuredOutcomeContent.h"


extern NSString * const JiveDocumentType;


extern struct JiveDocumentAttributes {
    __unsafe_unretained NSString *approvers;
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *editingBy;
    __unsafe_unretained NSString *fromQuest;
    __unsafe_unretained NSString *restrictComments;
    __unsafe_unretained NSString *updater;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    
    // Deprecated attribute names. Please use the JiveStructuredOutcomeContentAttribute names.
    __unsafe_unretained NSString *outcomeCounts;
    __unsafe_unretained NSString *outcomeTypeNames;
    __unsafe_unretained NSString *outcomeTypes;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveDocumentAttributes;


//! \class JiveDocument
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/DocumentEntity.html
@interface JiveDocument : JiveStructuredOutcomeContent

//! List of people who are approvers on the content of this document. Person[]
@property(nonatomic, strong) NSArray* approvers;

//! List of attachments to this message (if any). Attachment[]
@property(nonatomic, strong) NSArray* attachments;

//! List of people who are authors on this content. Authors are allowed to edit the content. This value is used only when authorship is limited. Person[]
@property(nonatomic, strong) NSArray* authors;

//! The authorship policy for this content.
// * open - anyone with appropriate permissions can edit the content. Default when visibility is place.
// * author - only the author can edit the content. Default when visibility is hidden or all.
// * limited - only those users specified by authors can edit the content. If authors was not specified then users will be used instead when visibility is people. Default when visibility is people.
@property(nonatomic, copy) NSString* authorship;

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! The person currently editing this document, meaning that it's locked. If not present, nobody is editing.
@property(nonatomic, readonly) JivePerson *editingBy;

//! Flag indicating that this document was created as part of a quest.
@property(nonatomic, copy) NSString* fromQuest;

//! Flag indicating that old comments will be visible but new comments are not allowed. If not restricted then anyone with appropriate permissions can comment on the content.
@property(nonatomic, strong) NSNumber *restrictComments;

//! The last person that updated this document. If not present, the last person to update this document was the person referenced in the author property.
@property(nonatomic, readonly, strong) JivePerson* updater;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, strong) NSArray* users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

@end