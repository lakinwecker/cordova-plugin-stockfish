#import "CordovaPluginStockfish.h"
#import "CordovaPluginStockfishios.h"
#import <Cordova/CDVPlugin.h>

@implementation CordovaPluginStockfish

NSString *outputCallback;
NSNumber *isInit = @FALSE;
NSTimer *onPauseTimer = nil;

- (void)pluginInitialize
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)onPause
{
  onPauseTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 * 60 * 10
    target: self
    selector:@selector(doStopOnPause)
    userInfo: nil repeats:NO];
}

- (void)onResume
{
  if(onPauseTimer) {
    [onPauseTimer invalidate];
    onPauseTimer = nil;
  }
}

- (void)init:(CDVInvokedUrlCommand*)command
{
  [self.commandDelegate runInBackground:^{
    if(![isInit boolValue]) {
      stockfishios::init((__bridge void*)self);
      isInit = @TRUE;
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

- (void)cmd:(CDVInvokedUrlCommand*)command
{
  if([isInit boolValue]) {
    [self.commandDelegate runInBackground:^{
      NSString* cmd = [command.arguments objectAtIndex:0];
      CDVPluginResult* pluginResult = nil;
      if (cmd != nil) {
        stockfishios::cmd(std::string([cmd UTF8String]));
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing cmd arg"];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
  } else {
    NSString *error = @"Please exec init before doing anything";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }
}

- (void)output:(CDVInvokedUrlCommand*)command
{
  outputCallback = command.callbackId;
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
}

- (void)exit:(CDVInvokedUrlCommand*)command
{
  if([isInit boolValue]) {
    [self.commandDelegate runInBackground:^{
      CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      stockfishios::cmd("stop");
      stockfishios::exit();
      isInit = @FALSE;
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
  } else {
    NSString *error = @"Stockfish isn't currently running!";
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }
}

- (void)sendOutput:(NSString *) output
{
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:output];
  [pluginResult setKeepCallbackAsBool:YES];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:outputCallback];
}

- (void)onAppTerminate
{
  if([isInit boolValue]) {
    stockfishios::cmd("stop");
    stockfishios::exit();
    isInit = @FALSE;
  }
}

- (void)doStopOnPause
{
  if([isInit boolValue]) {
    stockfishios::cmd("stop");
  }
}

void StockfishSendOutput (void *stockfish, const char *output)
{
  [(__bridge id) stockfish sendOutput:[NSString stringWithUTF8String:output]];
}

@end
