
@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "Superclass.j"

/*
    I'm commenting this class 
*/
@implementation Class : Superclass
{
    var x @accessors;
}

+ (void)classMethod
{
    return self; // this is a comment
}

- (void)instanceMethod
{
    return self;
}

@end
