/*!
 @header WAFileUtil.h
 @abstract 文件操作，包含写文件、删除文件等
 @discussion 
 @author huych
 @copyright UFIDA
 @version 
 */

#import <Foundation/Foundation.h>

@interface CWAFileUtil : NSObject

/*!
 @method
 @abstract 获取应用沙盒下的Document路径
 @discussion  此路径如无特殊设定，其他应用不能访问，卸载应用的时候，路径被删除,iTunes备份和恢复的时候会包括此目录
 @result 返回document路径,不需要释放,owned
 */
+ (NSString *)getDocumentPath;


//创建求应缓存路径，并返回路径，如果未创建成功，则返回nil
+ (NSString *)getQYSystemPath;


/*!
 @method
 @abstract 获取home路径
 @discussion
 @result 返回home路径,不需要释放,owned
 */
+ (NSString *)getHomePath;

/*!
 @method
 @abstract 文件的大小
 @param aPath文件的路径
 @discussion
 @result unsigned long long的文件大小
 */
+ (unsigned long long)fileSizeAtPaht:(NSString *)aPath;

/*!
 @method
 @abstract  为目录添加子目录全路径字符串
 @discussion 不添加子目录，只是字符串操作
 @result 返回全路径,不需要释放,owned
 */
+ (NSString *)addSubPath:(NSString *)aSubPath
                  toPath:(NSString *)aPath;
/*!
 @method
 @abstract 获取应用沙盒下的tmp路径
 @discussion  存放临时文件，iTunes不会备份和恢复此目录，此目录下文件会在应用退出后删除
 @result 返回tmp路径,不需要释放,owned
 */
+ (NSString *)getTmpPath;

/*!
 @method
 @abstract 获取应用沙盒下的caches路径
 @discussion  存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 @result 返回结果不需要释放,owned,返回caches路径
 */
+ (NSString *)getCachesPath;

/*!
 @method
 @abstract 获取给定路径的父路径
 @discussion  
 @param aPath  路径名，传入参数如：/Users/ufida/Library/Application Support/iPhone/
 @result 返回结果不需要释放,owned,有父路径返回父路径的路径，没有返回nil
 */
+ (NSString *)getParentPath:(NSString *)aPath;

/*!
 @method
 @abstract 在Document下创建路径
 @discussion  在Document下创建路径，不用加路径的前缀“/”
 @param aDirectory 需要添加的路径 传入参数如：test/test1/ 
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)createDirectoryAtDocument:(NSString *)aDirectory;

/*!
 @method
 @abstract 根据路径创建文件
 @discussion  如果文件已经存在，则覆盖
 @param aPath 文件的全路径，为nil则创建文件失败，如/Users/ufida/Library/Application Support/iPhone/testfile.txt
 @param aContent 文件的具体内容,为nil则创建文件内容为空
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)createFileWithPath:(NSString *)aPath 
                   content:(NSData *)aContent;

/*!
 @method
 @abstract 按照文件名称直接创建文件到Documents下
 @discussion 如果文件已经存在，则覆盖
 @param aFilename 文件名称
 @param aContent 文件的具体内容
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)createFileAtDocumentsWithName:(NSString *)aFilename 
                              content:(NSData *)aContent;


/*!
 @method
 @abstract 按照文件名称直接创建文件到tmp下
 @discussion 如果文件已经存在，则覆盖
 @param aFilename 文件名称
 @param aContent 文件的具体内容
 @result 返回成功创建文件后的路径，文件创建不成功，返回nil
 */
+ (NSString *)createFileAtTmpWithName:(NSString *)aFilename 
                              content:(NSData *)aContent;
/*!
 *	@method
 *	@abstract	获取原生的文件操作管理类
 *	@discussion	
 *	@result	返回原生的文件操作管理类
 */
+ (NSFileManager *)getNSFileManager;


/*!
 @method
 @abstract 按照文件名称直接创建文件到Documents下
 @discussion 如果文件已经存在，则覆盖
 @param aFilename 文件名称
 @param aContent 文件的具体内容
 @result 返回成功创建文件后的路径，文件创建不成功，返回nil
 */
+ (NSString *)createFileWithName:(NSString *)aFilename 
                         content:(NSData *)aContent;

/*!
 @method
 @abstract 按照文件夹路径创建文件夹
 @discussion 
 @param aPath 路径
 @result 返回成功创建文件后的路径，文件创建不成功，返回nil
 */
+ (BOOL)createPath:(NSString *)aPath;

/*!
 @method
 @abstract 根据文件名删除文件
 @discussion  
 @param aFileName 文件路径，包含名称
 @param aError 删除文件的错误信息
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)deleteFileWithName:(NSString *)aFileName 
                     error:(NSError **)aError;

/*!
 @method
 @abstract 根据文件url路径删除文件
 @discussion  
 @param aUrl 文件的url路径
 @param aError 删除文件的错误信息
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)deleteFileWithUrl:(NSURL *)aUrl error:(NSError **)aError;

/*!
 @method
 @abstract 删除目录下的所有文件，递归删除其下的子文件
 @discussion  
 @param path 文件目录,参数如：/user/test
 @result 文件全部删除成功，返回真；文件有一个删除不成功，返回假，并不删除不成功后的所有文件
 */
+ (BOOL)deleteAllFileAtPath:(NSString *)aPath;

/*!
 @method
 @abstract 按照文件名称删除Documents下的文件
 @discussion  文件直接保存在Documents下
 @param aFileName 文件名称 参数如：test.txt
 @param aError 文件的错误信息
 @result 成功，返回真；不成功，返回假
 */
+ (BOOL)deleteFileAtDocumentsWithName:(NSString *)aFileName 
                                error:(NSError **)aError;

/*!
 @method
 @abstract 按照路径文件名称读取文件
 @discussion  返回值的字符集等需要自己处理
 @param aPath 文件全路径，参数如：/Users/ufida/Library/Application Support/iPhone/testfile.txt
 @result 返回结果不需要释放,owned,文件内容
 */
+ (NSData *)readFileWithPath:(NSString *)aPath;

/*!
 @method
 @abstract 按照文件名称读取Documents下的文件
 @discussion  返回值的字符集等需要自己处理
 @param aFileName 文件名称，参数如：testfile.txt
 @result 返回结果不需要释放,owned,文件内容
 */
+ (NSData *)readFileAtDocumentsWithFileName:(NSString *)aFileName;

/*!
 @method  
 @abstract 遍历所有文件,不包含子文件夹下的文件
 @discussion  
 @param aDirString 文件路径，参数如：/Users/ufida
 @result 返回结果不需要释放,owned,字符串数组
 */
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)aDirString;

/*!
 @method  
 @abstract 遍历所有文件,不包含子文件夹下的文件(按创建的时间排序)
 @discussion  
 @param aDirString 文件路径，参数如：/Users/ufida
 @result 返回结果不需要释放,owned,字符串数组
 */
+ (NSArray *)getContentsOfDirectoryByTimeOrderAtPath:(NSString *)aDireString;

/*!
 @method  
 @abstract 遍历tmp文件夹,不包含子文件夹下的文件(按创建的时间排序)
 @discussion
 @result 返回结果不需要释放,owned,字符串数组
 */
+ (NSArray *)getContentsOfTmpDirectorByTimeOrder;

/*!
 @method  
 @abstract 遍历所有文件,包含子文件夹下的文件
 @discussion  
 @param aDirString 文件路径
 @result 返回结果不需要释放,owned,包含子文件夹下的文件,文件夹以字典的形式保存，文件以字符串保存
 */

+ (NSArray *)getAllFilesAtPath:(NSString *)aDirString;

/*!
 @method  
 @abstract 复制文件或文件夹到另外一个目录
 @discussion  前后两个路径必须一致，要么都是目录，要么都是文件，否则会有“Error Domain=NSPOSIXErrorDomain 
              Code=17”错误
 @param aPath 文件路径
 @param aDestinationPath  目标路径
 @param aError  错误信息
 @result 成功返回YES,失败返回NO
 */
+ (BOOL) copyItemAtPath:(NSString *)aPath 
                 toPath:(NSString *)aDestinationPath 
                  error:(NSError **)aError;

/*!
 @method  
 @abstract 判断文件是否存在
 @discussion  
 @param aPath 文件路径
 @result 存在返回真，否则返回假,参数为nil也返回假
 */
+ (BOOL)fileExistsAtPath:(NSString *)aPath;

/*!
 @method  
 @abstract 判断文件是否存在于documents文件夹下
 @discussion  
 @param aFileName 文件路径
 @result 存在返回真，否则返回假,参数为nil也返回假
 */
+ (BOOL)fileExistsAtDocumentsWithFileName:(NSString *)aFileName;

/*!
 @method  
 @abstract 判断文件夹是否存在
 @discussion  
 @param aPath 文件夹路径
 @result 存在返回真，否则返回假
 */
+ (BOOL)dirExistsAtPath:(NSString *)aPath;

/*!
 @method  
 @abstract 重命名文件
 @discussion  可重命名文件以及文件夹
 @param aOldName 原来的名字
 @param aNewName 新的名字
 @param aError 错误信息FileUtil
 @result 存在返回真，否则返回假
 */
+ (BOOL)renameFileNameFrom:(NSString *)aOldName 
                    toPath:(NSString *)aNewName 
                     error:(NSError **)aError;
/*!
 @method
 @abstract 得到Document下文件路径
 @discussion  得到Document下文件路径
 @param aFileName 文件名字
 @result 存在返回真，否则返回假
 */
+ (NSString *)getFullDocumentPathWithName:(NSString *)aFileName;
/*!
 @method
 @abstract 删除temp文件夹下的图片
 @discussion  删除temp文件夹下的图片
 @result 存在返回真，否则返回假
 */
+(BOOL) deleteAllFilesAtTmpPath;

/*!
 @method  
 @abstract 追加内容到文件的末尾(未实现)
 @discussion  
 @param aFileName 文件的名字
 @param aContent 文件的内容
 @result 成功返回YES,失败返回NO
 */
/*暂无实现
+ (BOOL)addContentAtFileEndWithName:(NSString *)aFileName 
                            content:(NSData *)aContent;
*/

@end

