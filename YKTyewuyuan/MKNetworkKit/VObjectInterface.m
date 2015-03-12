
#import "VObjectInterface.h"

@implementation VObjectInterface


@synthesize engine = _engine;
@synthesize netoperator = _netoperator;

@synthesize cacheid = _cacheid;

-(id)initWithEngine:(VEngine *)__engine
{
    if(self=[super init])
    {
        NSLog(@"__engine:%@",__engine);
        //NSLog(@"engine:%@",self.engine);
        self.engine = __engine;
        
        self.cache_on = NO;
        
    }
    return self;
}
-(void) setCache_on:(BOOL)enableCache
{
    _cache_on = enableCache;
}

-(void) cancel
{
    [self cleanNetOperation];
}
-(void) cleanNetOperation
{
    if(self.netoperator!=nil)
    {
        [self.netoperator cancel];
        self.netoperator = nil;
    }
}

@end
