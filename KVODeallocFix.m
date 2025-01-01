The solution involves ensuring that the observer is removed before the observed object is deallocated.  This is typically done within the `-dealloc` method of the observer class.  Here's an example:

```objectivec
@interface MyObserver : NSObject
@property (nonatomic, weak) ObservedObject *observedObject;
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // ... handle KVO notification ...
}

- (void)dealloc {
    [self.observedObject removeObserver:self forKeyPath:@"propertyToObserve"];
    [super dealloc]; // For non-ARC projects.  Remove in ARC projects.
}
@end

// Ensure that the observer is removed in ObservedObject's dealloc method as well (best practice)
@implementation ObservedObject
- (void)dealloc {
    [self removeObserver:observer forKeyPath:@"propertyToObserve"]; 
    [super dealloc]; //For non-ARC projects. Remove in ARC projects.
}
@end

```

By adding the `removeObserver` call in the `dealloc` method, we guarantee that the observer is released before the observed object, preventing the potential crash.