
#import "MKNetworkEngine.h"

@interface VEngine : MKNetworkEngine

//属性设置，接口引擎

//是否开启接口cache功能
//true:代表开启cache
//false:关闭接口cache
@property (nonatomic,assign) BOOL cache_on;

//配置cache 文件路径
@property (nonatomic,strong) NSString *cache_path;

@end
