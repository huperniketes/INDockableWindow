//
//  INDockableViewController.m
//  INDockableWindow
//
// Copyright (c) 2013, Indragie Karunaratne. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "INDockableViewController.h"
#import "INDockablePrimaryWindow.h"
#import "INDockableWindowController.h"

@interface INDockableViewController ()
@property (nonatomic, assign, readwrite) INDockableWindowController *dockableWindowController;
@property (nonatomic, assign, readwrite) NSUInteger index;
@property (nonatomic, strong, readonly) NSString *UUID;
@end

@interface INDockableDetachControl (Private)
@property (nonatomic, assign, readwrite) INDockableViewController *viewController;
@end

@implementation INDockableViewController
@synthesize uniqueIdentifier = _uniqueIdentifier;

- (void)commonInitForINDockableViewController
{
	_detachControl = [[INDockableDetachControl alloc] initWithFrame:NSZeroRect];
	_detachControl.viewController = self;
	_UUID = [[NSUUID UUID] UUIDString];
	_index = NSNotFound;
	_uniqueIdentifier = self.defaultIdentifier;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self commonInitForINDockableViewController];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self commonInitForINDockableViewController];
	}
	return self;
}

#pragma mark - Public API

- (void)viewControllerWillDetach
{
	
}

- (void)viewControllerDidDetach
{
	[self.detachControl setHidden:YES];
}

- (void)viewControllerWillAttach
{
	
}

- (void)viewControllerDidAttach
{
	[self.detachControl setHidden:NO];
}

- (void)detach
{
	[self.dockableWindowController detachViewController:self];
}

- (void)attach
{
	[self.dockableWindowController attachViewController:self];
}

#pragma mark - Accessors

- (void)setView:(NSView *)view
{
	[super setView:view];
	view.identifier = self.uniqueIdentifier;
}

- (BOOL)isAttached
{
	return self.index != NSNotFound;
}

- (NSWindow *)window
{
	return self.view.window;
}

- (void)setUniqueIdentifier:(NSString *)uniqueIdentifier
{
	uniqueIdentifier = uniqueIdentifier ?: self.defaultIdentifier;
	if (_uniqueIdentifier != uniqueIdentifier) {
		_uniqueIdentifier = uniqueIdentifier;
		self.view.identifier = uniqueIdentifier;
	}
}

- (NSString *)defaultIdentifier
{
	NSString *indexString = self.attached ? @(self.index).stringValue : nil;
	return indexString ?: self.UUID;
}

@end
