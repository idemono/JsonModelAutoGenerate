//
//  ViewController.m
//  JsonModelAutoGenerate
//
//  Created by 泓杉mini on 2018/7/30.
//  Copyright © 2018年 HS. All rights reserved.
//

#import "ViewController.h"
#import "HSGoods.h"
#import "NSString+Extensoin.h"
#define YYModelIMPORT @"#if __has_include(<YYModel/YYModel.h>)\n\
  #import <YYModel/YYModel.h>\n\
#else\n\
  #import \"YYModel.h\"\n\
#endif\n"

#define YYModelSynthCoderAndHashStr @"#define YYModelSynthCoderAndHash \\\n\
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \\\n\
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \\\n\
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \\\n\
- (NSUInteger)hash { return [self yy_modelHash]; } \\\n\
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }\n\n"

#define YYModelCustomPropertyMapper @"\n\
+ (NSDictionary *)modelCustomPropertyMapper {\n\
    \\*return @{@\"newKey\":@\"oldKey\"};*\\\n\
    return @{};\n\
}\n\n\
"

#define YYModelContainerPropertyGenericClass @"\n\
+ (NSDictionary *)modelContainerPropertyGenericClass {\n\
    \\*return @{@\"key\":[**** class]};*\\\n\
    return @{};\n\
}\n\n\
"



#define CopyingCodingDeleteStr @"NSCoding, NSCopying"


@interface ViewController()
@property (weak) IBOutlet NSScrollView *scrollView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *fileNameTextField;
@property (unsafe_unretained) IBOutlet NSTextView *ntextView;//.h文件
@property (unsafe_unretained) IBOutlet NSTextView *mtextView;//.m文件

@property (nonatomic, strong)NSMutableString *allHFileContent;
@property (nonatomic, strong)NSMutableString *allMFileContent;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}
#pragma mark - Action

#pragma mark 转换.h.m内容
- (IBAction)loadJson:(id)sender {
    
    NSData *data = [NSData dataWithData:[self.textView.string dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
//    HSGoods *goods =  
//    return;

    
    NSString *modelFileName = _fileNameTextField.stringValue;
    if (modelFileName.length == 0){
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setInformativeText:@"文件名不能为空!!!"];
        [alert runModal];
        return;
    }
    _allHFileContent = [NSMutableString string];
    _allMFileContent = [NSMutableString string];

    if ([json isKindOfClass:[NSArray  class]]){
        [self loadDicData:[((NSArray *)json) firstObject] keyName:modelFileName];
    }else if ([json isKindOfClass:[NSDictionary class]]){
        [self loadDicData:json keyName:modelFileName];
    }else{
        NSLog(@"JOSN 有问题");
        return;
    }
    [self setHContent];
    [self setMContent];

}

#pragma mark 导出.h.m文件
- (IBAction)exportFile:(id)sender {

    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        NSError *herr = nil;
        NSError *merr = nil;
        NSString *basePath = [[panel URL] path];
        NSString *hfilePath = [NSString stringWithFormat:@"%@/%@.h",basePath,_fileNameTextField.stringValue];
        BOOL hresult = [_ntextView.string writeToFile:hfilePath
                               atomically:YES
                                 encoding:NSUTF8StringEncoding
                                    error:&herr];
        NSString *mfilePath = [NSString stringWithFormat:@"%@/%@.m",basePath,_fileNameTextField.stringValue];
        BOOL mresult = [_mtextView.string writeToFile:mfilePath
                                         atomically:YES
                                           encoding:NSUTF8StringEncoding
                                              error:&merr];
        if (hresult && mresult){
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setInformativeText:@"文件导出成功!!!"];
            [alert runModal];
        }else{
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setInformativeText:[herr.description stringByAppendingString:merr.description] ];
            [alert runModal];
        }
    }];
}

#pragma mark - Method
#pragma mark 设置.h所有内容
- (void)setHContent{
    NSString *copyRightStr = [NSString copyingRightWithFileName:[_fileNameTextField.stringValue stringByAppendingString:@".h"]];
    NSMutableString *tStr = [NSMutableString string];
    [tStr appendString:copyRightStr];
    [tStr appendString:@"#import <Foundation/Foundation.h>\n"];
    [tStr appendString:YYModelIMPORT];

    [tStr appendString:@"\n\n"];
    [tStr appendString:_allHFileContent];
    _ntextView.string = tStr;
}
#pragma mark 设置.m所有内容
- (void)setMContent{
    NSString *copyRightStr = [NSString copyingRightWithFileName:[_fileNameTextField.stringValue stringByAppendingString:@".m"]];
    NSMutableString *tStr = [NSMutableString string];
    [tStr appendString:copyRightStr];
    [tStr appendString:YYModelSynthCoderAndHashStr];
    [tStr appendString:[NSString stringWithFormat:@"#import \"%@.h\"",_fileNameTextField.stringValue]];
    [tStr appendString:@"\n"];
    [tStr appendString:_allMFileContent];
    _mtextView.string = tStr;
}
#pragma mark .h文件 所有类的声明
- (NSString *)createHContent:(NSString *)className data:(NSDictionary *)data{
    NSMutableString * value = [NSMutableString string];
    [value appendString:[NSString stringWithFormat:@"@interface %@ : NSObject<%@>\n\n",className,CopyingCodingDeleteStr]];
    
    NSArray *allKeys = [data allKeys];
    for (NSString *key in allKeys) {
        NSString *propertyStr = [NSString getPropertyDescStr:key type:data[key]];
        [value appendString:propertyStr];
    }
    
    [value appendString:@"\n\n@end\n\n"];
    return value;
}

#pragma mark .m文件 所有类的实现
- (NSString *)createMContent:(NSString *)className data:(NSDictionary *)data{
    NSMutableString * value = [NSMutableString string];
    
    [value appendString:[NSString stringWithFormat:@"@implementation %@ \n",className]];
    [value appendString:YYModelCustomPropertyMapper];
    [value appendString:YYModelContainerPropertyGenericClass];
    [value appendString:@"YYModelSynthCoderAndHash"];
    [value appendString:@"\n\n@end\n\n"];
    return value;
}

#pragma mark 解析用户输入的JSON

- (void)loadDicData:(NSDictionary *)dicData keyName:(NSString *)keyName{
    if (![dicData isKindOfClass:[NSDictionary class]]){
        return;
    }
    NSArray *allKeys = [dicData allKeys];
    NSString *OBJClassName = keyName;
    if (!keyName){
        OBJClassName = @"ROOT";
    }
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    
    for (NSString *key in allKeys) {
        id obj = [dicData objectForKey:key];
        NSString *className = [NSString getClassName:obj];
        NSString *nClassName = [OBJClassName stringByAppendingString:[key capitalizedString]];
        if ([obj isKindOfClass:[NSArray  class]]){
            //数组类型
            [self loadDicData:[((NSArray *)obj) firstObject] keyName:nClassName];
            [mutDict setValue:className forKey:key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            //字典类型
            [self loadDicData:obj keyName:nClassName];
            //直接以类名作为类型
            [mutDict setValue:nClassName forKey:key];
        }else{
            //其他类型(String,Number,Bool)
            [mutDict setValue:className forKey:key];
        }
        
    }
    NSLog(@"\n▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼\nFILE NAME :%@\n PROPERTY:\n%@\n▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲",OBJClassName,mutDict);
    NSString *hFileStr = [self createHContent:OBJClassName data:mutDict];
    NSString *mFileStr = [self createMContent:OBJClassName data:mutDict];
    [_allHFileContent appendString:hFileStr];
    [_allMFileContent appendString:mFileStr];
}








@end
