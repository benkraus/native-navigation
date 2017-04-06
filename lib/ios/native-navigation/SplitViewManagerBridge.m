#import <React/RCTLog.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_REMAP_MODULE(NativeNavigationSplitViewManager, SplitViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(master, NSString);
RCT_EXPORT_VIEW_PROPERTY(detail, NSString);

@end
