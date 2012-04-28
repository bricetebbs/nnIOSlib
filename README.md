# nnLib
===

This project is just a folder of common functions used in a few different iOS projects.

Some notable classes include

## Graphics


#### nnScrollingCGView
This is a subclass of UIScrollView which manages its own drawing during scrolling rather than using the pixel replication/filtering of the built in class. It is suitable for charts and other graphics rendered with the CGContext functions.

#### nnSceneObject (& friends)
A set of classes which can be used to create a scene hierarchy to render in an **nnScrollingCGView**.

## nnDV
A set of classes which implement an easy way to add UI elements and manage thier storage.

#### nnDVStoreProtocol
This is a protocol which a storage manager must implement. It includes functions such as setBool:forKey:, boolForKey:, etc. Each UI element is attached to a store protocol.

#### nnPreferenceManager
Implements nnDVStoreProtocol using **NSUserDefaults**. So nnDV UI elements bound to this preference manager get stored in that manner.

#### nnDVBoolUISwitch
Is an example nnDV UI element, A subclass of UISwitch which implements **nnDVUIBaseProtocol**, it can be placed in IB and then setup in for example **viewDidLoad**.

      [boolSwitchOne setupDvInfo: @"SwitchOne" handler: preferenceManager delegate:nil];
      
This will setup boolSwitchOne to automatically bind to the NSUserDefaults for the key @"SwitchOne" whenever the user clicks the switch. In **viewWillAppear** you just need.

      [boolSwitchOne populate];

To have the switch show the current saved state of @"SwitchOne". In order to save the value use

      [boolSwitchOne save];
      
Other data types work similarly. You can use any object for the key so that its also easy to make a manager which uses a CoreData backend rather than NSUserDefaults. As long as it implements **nnDVStoreProtocol** everything will work the same.

#### Other UIElements
Some other elements include **nnDVBoolUICheckbox**, **nnDVSliderTableViewCell**, and **nnDVStringUIText**. Check the sources.

## Core Data Stuff
nnLib contains several Core Data helper classes. Here's a few

#### nnCoreDataManager
Basically just a wrapper for **NSManagedObjectContext**, **NSManagedObjectModel**, and **managedObjectModel**. It includes some simple helper functions such as:

	// Create a new object in the context
	-(id) newObject: (NSString*) entityName;
	
	// Delete the specified object	
	-(void)deleteObject: (id)objectToDelete;
	
	// Save the context
	-(NSError*)saveContext;

There is also a simple search function
	
	// Search the context for the first occurance of the object
	-(id)findObject:(NSString*)entityName 
		withPredicate: (NSPredicate*)predicate 
		andSort:(NSArray*)sortDescriptors;
      
#### nnCoreDataAppDelegate
A base class for AppDelegates which includes a **nnCoreDataManager**.
#### nnCoreDataTableViewController
Wraps up most of the work you need to create a table view controller using CoreData


## Password Store
#### nnPasswordStore

## Audio

#### nnShortSound
Lets you play a simple sound resource (like an .aiff file). It has two methods


	-(id)initWithSoundName:(NSString*)name;
	-(void)playSound;



