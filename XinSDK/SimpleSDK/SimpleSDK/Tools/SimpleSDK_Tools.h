//
//  SimpleSDK_Tools.h
//  SimpleSDK
//
//  Created by XYL on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSDK_Tools : NSObject

+ (instancetype)manager;

//初始化参数
+ (NSDictionary *)func_InitParams;


//判断图片是否为空
+(bool)func_judgeUIimageForNil:(UIImage *)image;

//获取手机型号
+ (NSString *)func_getDeviceString;

//获取app版本号
+ (NSString *)func_getOSVersion;

//获取UUid并且保存到钥匙串中
+(NSString *)func_getUUIDString;

//获取时间戳
+(NSString *) func_getTimesTamp;

//获取32位随机数
+(NSString *)func_get32BitStr;

//截取md5加密后16位
+(NSString *)func_getMd5_16BitStr:(NSString *)str;

//转义字符
+(NSString*)encodeStr:(NSString*)unencodedString;

//文字添加下划线
+(NSMutableAttributedString *)func_strAddUnderline:(NSString *)contentStr UnderLineColor:(UIColor *)lineColor;

//获取String 的MD5值
+(NSString *)func_getStrMD5:(NSString *)str;

//设置Res256 hash value值
+(NSString *)func_set256HashValue:(NSString *)sha256Str;

//拼接请求参数
+(NSString *)func_sortOfDictionary:(NSDictionary *)dictionary;



/// 字典转Json
/// @param params 字典
+(NSString *)func_dictionaryToJsonOfParams:(NSDictionary *)params;

/// Json字符串转字典
/// @param jsonString Json字符串
+(NSDictionary *)func_jsonToDictionaryOfJsonString:(NSString *)jsonString;

//生成账号密码随机数（后期应该后台返回）
+(NSString *)func_getRandomStrWithNum:(NSInteger )nubr;

//文本输入框验证
+(NSString *)func_validationInputText:(NSString *)str;

//验证手机格式
+(BOOL)func_isMobileNumber:(NSString *)phoneStr;

//判断是否超时
+(BOOL)func_timeout:(NSString *)loginType;

//判断名字合法性(正常名字在2～8个中文)
+ (BOOL)func_isVaildRealName:(NSString *)realName;

//验证身份证号
+(BOOL)func_verifyIDCard:(NSString *)idCard;

//路径格式化
+(NSString *)func_urlUTF8Encoding:(NSString *)urlstr;

//获取当前界面最上曾View
+(UIWindow *) func_getTopViewControlle;


@end

NS_ASSUME_NONNULL_END
