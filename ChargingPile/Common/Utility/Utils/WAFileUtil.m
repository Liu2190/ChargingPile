/*!
 @class
 @abstract 文件操作工具类
 */

#import "WAFileUtil.h"
#import "WAStringUtil.h"

static NSFileManager *iNSFileManager;

@implementation CWAFileUtil

+ (NSFileManager *)getNSFileManager
{
  if (!iNSFileManager)
  {
    iNSFileManager = [NSFileManager defaultManager];
  }
  return iNSFileManager;
}

+ (NSString *)getQYSystemPath
{
	NSString *dumPath = [CWAFileUtil getDocumentPath];
	NSString *cacahePAth = @"cache";
	NSString *Path = nil;
	if([CWAFileUtil createDirectoryAtDocument:cacahePAth])
	{
		Path = [CWAFileUtil addSubPath:cacahePAth toPath:dumPath];
	}
	return Path;
}

#pragma mark 判断文件是否存在 

+ (BOOL)fileExistsAtPath:(NSString *)aPath
{
  BOOL result = NO;
  if (aPath)
  {
    result = [[self getNSFileManager] fileExistsAtPath:aPath];
  }
  return result;
}

+ (BOOL)fileExistsAtDocumentsWithFileName:(NSString *)aFileName{
  BOOL result = NO;
  if (aFileName)
  {
    NSString *fullFileName = [self getFullDocumentPathWithName:aFileName];
    
    result = [[self getNSFileManager] fileExistsAtPath:fullFileName];
  }
  return result;
}


#pragma mark 判断文件夹是否存在 
+ (BOOL)dirExistsAtPath:(NSString *)aPath
{
  BOOL isDir = NO;
  BOOL result = [[self getNSFileManager] fileExistsAtPath:aPath 
                                              isDirectory:&isDir];
  return result && isDir;
}

#pragma mark 获取上级目录
+ (NSString *) getParentPath:(NSString *)aPath
{  
  return [aPath stringByDeletingLastPathComponent]; 

}

#pragma mark 创建目录的上级目录
+ (BOOL)createParentDirectory:(NSString *)aPath
{
  //存在上级目录，并且上级目录不存在的创建所有的上级目录
  BOOL result = NO;
  NSString *parentPath = [self getParentPath:aPath];
  if (parentPath && ![self dirExistsAtPath:parentPath])
  {
    result = [[self getNSFileManager] createDirectoryAtPath:parentPath 
                       withIntermediateDirectories:YES
                                        attributes:nil 
                                             error:nil]; 
  }
  else if ([self dirExistsAtPath:parentPath]){
    result = YES;
  }
  return result;
}

#pragma mark 创建目录
+ (BOOL)createPath:(NSString *)aPath
{
  NSFileManager *tempFileManager = [self getNSFileManager];
  BOOL result = NO;
  result = [self createParentDirectory:aPath];
  if (result)
  {
    result = [tempFileManager createDirectoryAtPath:aPath 
                        withIntermediateDirectories:YES 
                                         attributes:nil 
                                              error:nil];
                                         
  }
  return result;
}

#pragma mark 目录下创建文件
+ (BOOL)createFileWithPath:(NSString *)aPath content:(NSData *)aContent
{
  NSFileManager *tempFileManager = [self getNSFileManager];
  BOOL result = NO;
  result = [self createParentDirectory:aPath];
  if (result)
  {
    result = [tempFileManager createFileAtPath:aPath 
                                      contents:aContent 
                                    attributes:nil];
  }
  return result;
}

#pragma mark documents下创建文件
+ (BOOL)createFileAtDocumentsWithName:(NSString *)aFilename 
                              content:(NSData *)aContent
{
  NSString *filePath =[self getFullDocumentPathWithName:aFilename];
  BOOL result = [self createFileWithPath:filePath
                                 content:aContent];
  return result;
}

+ (NSString *)createFileAtTmpWithName:(NSString *)aFilename 
                        content:(NSData *)aContent
{
  NSString *filePath =[self getFullTmpPathWithName:aFilename];
  BOOL result = [self createFileWithPath:filePath
                                 content:aContent];
  if(!result)
  {
    filePath = nil;
  }
  return filePath;

}

+ (NSString *)createFileWithName:(NSString *)aFilename 
                              content:(NSData *)aContent
{
  NSString *filePath =[self getFullDocumentPathWithName:aFilename];
  BOOL result = [self createFileWithPath:filePath
                                 content:aContent];
  if(!result)
  {
    filePath = nil;
  }
  return filePath;
}

#pragma mark Caches下创建文件
+ (BOOL)createFileAtCachesWithName:(NSString *)aFilename 
                              content:(NSData *)aContent
{
  NSString *filePath =[self getFullCachesPathWithName:aFilename];
  BOOL result = [self createFileWithPath:filePath
                                 content:aContent];
  return result;
}
#pragma mark 根据文件名称获取Caches的文件名的全路径,需要自己释放
+ (NSString *)getFullCachesPathWithName:(NSString *)aFileName
{  
  return [[self getCachesPath] stringByAppendingPathComponent:aFileName];
}


+ (NSString *)addSubPath:(NSString *)aSubPath
                toPath:(NSString *)aPath 
{  
  return [aPath stringByAppendingPathComponent:aSubPath];
}

#pragma mark 根据文件名称获取documents的文件名的全路径,需要自己释放
+ (NSString *)getFullDocumentPathWithName:(NSString *)aFileName
{  
   return [[self getDocumentPath] stringByAppendingPathComponent:aFileName];
}

#pragma mark 根据文件名称获取tmp的文件名的全路径,需要自己释放
+ (NSString *)getFullTmpPathWithName:(NSString *)aFileName
{  
  return [[self getTmpPath] stringByAppendingPathComponent:aFileName];
}


#pragma mark 获取documents的全路径
+ (NSString *)getDocumentPath
{
  NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString *result = [pathArray objectAtIndex:0];
  return result;
  
}

+ (NSString *)getHomePath
{
  NSString *home = [@"~" stringByExpandingTildeInPath]; 
  return home;
}

#pragma mark 删除文件
+ (BOOL)deleteFileWithName:(NSString *)aFileName 
                   error:(NSError **)aError
{
  NSFileManager *tempFileManager = [self getNSFileManager];
  return [tempFileManager removeItemAtPath:aFileName 
                                     error:aError];
}

+ (BOOL)deleteFileWithUrl:(NSURL *)aUrl error:(NSError **)aError
{
  return [[self getNSFileManager] removeItemAtURL:aUrl error:aError];
}

#pragma mark 删除文件夹下的所有文件
+ (BOOL)deleteAllFileAtPath:(NSString *)aPath
{
  BOOL result = NO;
  NSArray *fileArray = [self getContentsOfDirectoryAtPath:aPath];

  
  NSString *filePath = nil;
  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  for (int i = 0; i<[fileArray count]; i++)
  {   
    filePath = [aPath stringByAppendingPathComponent:[fileArray objectAtIndex:i]];  
    result = [[self getNSFileManager] removeItemAtPath:filePath 
                                                 error:nil];
    if (!result)
    {
       break;
    }
    filePath = nil;
  }
  [pool drain];
  return result;
}

#pragma mark 根据文件名删除document下的文件
+ (BOOL)deleteFileAtDocumentsWithName:(NSString *)aFilename  
                                error:(NSError **)aError
{
  NSString *filePath = [self getFullDocumentPathWithName:aFilename];
  return [self deleteFileWithName:filePath
                            error:aError];
}

#pragma mark 获取tmp路径
+ (NSString *)getTmpPath
{
  NSString *pathName = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
  return pathName;
}

#pragma mark 获取caches路径
+ (NSString *)getCachesPath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
  return [paths objectAtIndex:0];
}

#pragma mark 在Document下创建文件目录
+ (BOOL)createDirectoryAtDocument:(NSString *)aDirectory
{
  NSFileManager *tempFileManager = [self getNSFileManager];
  NSString * directoryAll = [self getFullDocumentPathWithName:aDirectory];
 
  BOOL result = [tempFileManager createDirectoryAtPath:directoryAll
                           withIntermediateDirectories:YES 
                                            attributes:nil
                                                 error:nil];
  return result;
}

#pragma mark 读取文件
+ (NSData *)readFileWithPath:(NSString *)aPath
{
  NSData *data = [NSData dataWithContentsOfFile:aPath];
  return data;
}

+ (NSData *)readFileAtDocumentsWithFileName:(NSString *)aFileName
{
  NSString *fullPathWithName =  [self getFullDocumentPathWithName:aFileName];
  NSData *data = [NSData dataWithContentsOfFile:fullPathWithName];
  return data;
}

#pragma mark 遍历文件夹下的所有文件,不含子文件
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)aDirString

{
  NSFileManager *tempFileManager = [self getNSFileManager];
  return [tempFileManager contentsOfDirectoryAtPath:aDirString 
                                              error:nil];
}

+ (NSArray *)getContentsOfDirectoryByTimeOrderAtPath:(NSString *)aDireString
{
  
  if (![NSURL URLWithString:aDireString])
  {
    return nil;
  }
  NSFileManager *tempFileManager = [self getNSFileManager];
  
  NSMutableArray *fileArray = [[NSMutableArray alloc] initWithCapacity:1];
  NSDirectoryEnumerator *dirEnumerator = [tempFileManager enumeratorAtURL:[[NSURL URLWithString:aDireString] URLByResolvingSymlinksInPath] 
                                               includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLCreationDateKey,NSURLIsDirectoryKey,nil] 
                                                                  options:NSDirectoryEnumerationSkipsHiddenFiles 
                                                             errorHandler:nil];
  
  for (NSURL *theURL in dirEnumerator) 
  {
    NSNumber *isDirectory;
    [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
    
    if ([isDirectory boolValue]== NO)
    {
      [fileArray addObject:theURL];
    }
  }

  
  NSArray *sortedFiles = [fileArray sortedArrayUsingComparator:^(NSURL *url1, NSURL *url2) 
                          {
                            NSDate *date1, *date2;
                            
                            // This works on iOS 5.
                            [url1 getResourceValue:&date1 forKey:NSURLCreationDateKey error:nil];
                            [url2 getResourceValue:&date2 forKey:NSURLCreationDateKey error:nil];
                            if (date1 != nil && date2 != nil) 
                            {
                              return [date2 compare:date1];
                            }
                            
                            // On iOS 4 or earlier, the above getResourceValue won't work.
                            date1 = [[tempFileManager attributesOfItemAtPath:url1.path error:nil]
                                     objectForKey:NSFileCreationDate];
                            date2 = [[tempFileManager attributesOfItemAtPath:url2.path error:nil]
                                     objectForKey:NSFileCreationDate];
                            return [date2 compare:date1];
                          }];
  [fileArray release];
  return sortedFiles;
}

+ (NSArray *)getContentsOfTmpDirectorByTimeOrder
{
  return [self getContentsOfDirectoryByTimeOrderAtPath:[self getTmpPath]];
}

+ (unsigned long long)fileSizeAtPaht:(NSString *)aPath
{
  return  [[[self getNSFileManager] attributesOfItemAtPath:aPath  error:nil] fileSize];
}


#pragma mark 遍历文件夹下的所有文件,含子文件
+ (NSArray *)getAllFilesAtPath:(NSString *)aDirString
{
  NSMutableArray *temPathArray = [NSMutableArray array];
  
  NSFileManager *tempFileManager =  [self getNSFileManager];
  NSArray *tempArray = [self getContentsOfDirectoryAtPath:aDirString];
  NSString *fullPath = nil;
  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  for (NSString *fileName in tempArray)
  {
    
    BOOL flag = YES;
    fullPath = [aDirString stringByAppendingPathComponent:fileName];
  
    //判断是否存在
    if ([tempFileManager fileExistsAtPath:fullPath 
                              isDirectory:&flag])
    {
      //不是目录，直接添加
      if (!flag)
      {
        // ignore .DS_Store
        if (![[fileName substringToIndex:1] isEqualToString:@"."])
        {
         [temPathArray addObject:fullPath];
        }
      }
      //如果是目录的话，以当前文件夹为key,文件夹下的子文件名为value,递归调用
      else
      {
        NSArray *subPathArray = [self getAllFilesAtPath:fullPath];
        NSDictionary *subPathDic = [[NSDictionary alloc] initWithObjectsAndKeys:subPathArray,fullPath,nil];
        [temPathArray addObject:subPathDic];
        [subPathDic release];
      }
    }
    fullPath = nil;
   
  }
  [pool drain];
  NSArray *resultArray = [NSArray arrayWithArray:temPathArray];
  

  return resultArray;
  
}

#pragma mark 复制一个目录下的文件到另外一个目录,前后两个必须一致，要么都是目录，要么都是文件
+ (BOOL) copyItemAtPath:(NSString *)aPath 
                 toPath:(NSString *)aDestinationPath
                  error:(NSError **)aError
{
  NSFileManager *tempFileManager = [self getNSFileManager];
  return [tempFileManager copyItemAtPath:aPath
                                  toPath:aDestinationPath 
                                   error:aError];
}

#pragma mark 重命名文件
+ (BOOL)renameFileNameFrom:(NSString *)aOldName 
                    toPath:(NSString *)aNewName 
                     error:(NSError **)aError{
  NSFileManager *tempFileManager = [self getNSFileManager];
  BOOL result =  [tempFileManager moveItemAtPath:aOldName 
                                          toPath:aNewName 
                                           error:aError];
  return result;
}

+(BOOL) deleteAllFilesAtTmpPath
{
  return [self deleteAllFileAtPath:[self getTmpPath]];
}

@end
