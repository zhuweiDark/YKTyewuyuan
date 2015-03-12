
#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
#import "MKNetworkOperation.h"
#import "VEngine.h"

@interface VObjectInterface : NSObject


@property (nonatomic,retain) VEngine *engine;
@property (nonatomic,strong) MKNetworkOperation *netoperator;
@property (nonatomic,assign) BOOL   cache_on;
@property (nonatomic,strong) NSString *cacheid;

-(id)initWithEngine:(VEngine *)_engine;
-(void) cancel;
-(void) cleanNetOperation;


@end
