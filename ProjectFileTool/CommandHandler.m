//
//  CommandHandler.m
//  LocalisationTool
//
//  Created by Rob Jonson on 13/01/2015.
//  Copyright (c) 2015 HobbyistSoftware. All rights reserved.
//

#import "CommandHandler.h"
#import "ProjectParser.h"

@implementation CommandHandler

-(BOOL)runWithArguments:(NSArray*)arguments
{
    BOOL needHelp=[arguments containsObject:@"--help"];
    if (needHelp)
    {
        printf("%s\n",[self.helpString UTF8String]);
        return 0;
    }
    
    BOOL needVersion=[arguments containsObject:@"--version"];
    if (needVersion)
    {
        printf("1.00\n");
        return 0;
    }
    
    
    BOOL showTargets=[arguments containsObject:@"-showtargets"];
    
    NSString *xcodeProj=[[NSUserDefaults standardUserDefaults] objectForKey:@"xcproj"];
    NSString *targetsString=[[NSUserDefaults standardUserDefaults]   objectForKey:@"targets"];
    NSArray *targets=NULL;
    
    if (targetsString)
    {
        targets = [targetsString componentsSeparatedByString:@","];
    }
    
    ProjectParser *parser1 = [ProjectParser new];
    
    [parser1 setXcodeProjPath:xcodeProj];
    
    ProjectParser *parser2 = [ProjectParser new];
    
    [parser2 setXcodeProjPath:xcodeProj];
    
    if (targets) {
        [parser1 setAllowedTargets:@[[targets objectAtIndex:0]]];
        [parser2 setAllowedTargets:@[[targets objectAtIndex:1]]];
    }
    
    NSDictionary *filePaths1 = [parser1 pathsAndFiles];
    NSDictionary *filePaths2 = [parser2 pathsAndFiles];
    
//    for (NSString *path in [filePaths allKeys]) {
//        printf("%s\n",[path UTF8String]);
//    }
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:[filePaths1 allKeys]];
    NSMutableSet *set2 = [NSMutableSet setWithArray:[filePaths2 allKeys]];
    
    [set2 minusSet:set1];
    printf("%s",set2.description.UTF8String);
    set1 = [NSMutableSet setWithArray:[filePaths1 allKeys]];
    set2 = [NSMutableSet setWithArray:[filePaths2 allKeys]];
    [set1 minusSet:set2];
    printf("%s",set1.description.UTF8String);
    
    [parser1 release];
    [parser2 release];
    
    return 0;
}

-(NSString *)helpString
{
    return @"ProjectFileTool\n\
    \n\
    Synopsis\n\
    \n\
    ProjectFileTool [--help | --version |-c -xcproj xcodeproject [-targets targets] [-showtargets]\n\
    \n\
    Description\n\
    \n\
    Parse the xcodeproject file to manage included files\n\
    \n\
    the options are as follows:\n\
    \n\
    --help\n\
    output this help file\n\
    \n\
    -c run as command line tool (rather than cocoa app)\n\
    \n\
    -xcproj specify path of xcodeproject file\n\
    \n\
    -targets specify comma limited list of targets to parse for files (default is all targets)\n\
    \n\
    -showtargets output a list of target names\n\
    \n\
    Examples\n\
    \n\
    source files are ones with these extensions:\n\
    NSArray *interestingExtensions=@[@\"xib\",@\"m\",@\"storyboard\",@\"swift\"];\n\
    \n\
    ProjectFileTool -xcproj path/To/project.xcodeproj\n\
    output source files included in project.xcodeproj\n\
    \n\
    \n\
    ProjectFileTool -xcproj path/To/project.xcodeproj -targets target1,target2\n\
    output source files included in project.xcodeproj which are in target1 or target2";
}

@end
