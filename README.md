# Binary Targets with Dependencies

## The Problem

I'd like to know how I can efficiently cache and distribute prebuild (internal) frameworks with SPM. The goal is to have a Package.swift file that exposes a binary target while still providing information about it's dependencies.

## An Example

In the following example we assume that my project is split over multiple repositories where each repository provides its own package.

We have the following repositories:
- MainApp: The project that is used to build an iOS app. Depends on some version of LibraryA and some version of LibraryB
- LibraryA: Depends on some version of LibraryB. Produces a library that depends on a `.binaryTarget`.
- LibraryB: Does not have any dependencies on its own. Produces a library that depends on a `.binaryTarget`.

Links to the example projects:
- [MainProject](https://github.com/Ro-M/SPM-Versioning-MainProject)
- [MyLibraryA](https://github.com/Ro-M/SPM-Versioning-LibraryA)
- [MyLibraryB](https://github.com/Ro-M/SPM-Versioning-LibraryB)

Unlike with `.target` we cannot specify dependencies when we are declaring a `.binaryTarget`. So in this scenario LibraryA has no way of conveying that it depends on some version of LibraryB. Furthermore I might run into issues in the MainApp that the required version of LibraryB is different in LibraryA and the MainApp.

As a workaround I can define a wrapper target in LibraryA. This target depends on the actual (previously used) `.binaryTarget` and on some version of LibraryB. This already requires me to do the following:
- create a new empty wrapper target
- create a folder for that target in my project (otherwise SPM will not build)
- create a file within that folder with no content (otherwise SPM will not build)
- Added an additional target that will be visible from the main app (along with the actual target)

Aside from that I also cannot guarantee that the dependecy on LibraryB is the one actually required by the `.binaryTarget`. But for now let's just assume that I can put some automation in place which asures that the XCFramework is compatible with the declared dependency version.

Another issue is that when I build the main app it includes the `Frameworks` folder (as expected). That folder includes both `LibraryA` and `LibraryB` (as expected). But then `LibraryA` also has a `Frameworks` folder with another copy of `LibraryB` in it (not expected, has to be removed).

This setup works "good enough". My main concern with it however is that I basically have to maintain 2 Package.swift files for each library: One that exposes my project as a prebuild XCFramework (with the wrapper) and one that allows me to work on the library (building by source). The latter would also be the product to use when building the XCFramework (in this cases I am also required to set specify its type as `.dynamic`). I have to switch between those 2 because I cannot have 2 products with the same name and as of my understanding my XCFramework must use the same name as my exposed product.

## My Question

Is there a better way to achive my goal than the workaround(s) I described above? Aside from the drawback that I mentioned about requiring some form of automation is there anything else that I'm missing here? I.e. why is having dependencies on a binary target not already supported?

I'd also be open to other suggestions that I may be missing. Maybe an option that does not require me to use XCFrameworks at all while still enabling caching of each individually built source file?

Or maybe more general: Is what I'm trying to do something that SPM is actually meant to do? Or am I just shoehorning it into something it should not be?