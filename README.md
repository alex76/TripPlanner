# TripPlanner
TUI Mobility Hub - Test Project Challenge

## Platforms

- iOS >= 15.0
- iPhone: Portrait mode
- Xcode Version 13.4.1 (13F100)

## Technologies
- Swift
- SwiftUI
- Combine

## Architecture & Patterns
- **MVVM** with **FlowCoordinators** (coordinators are responsible for navigating between screens)
- **Modular architecture** (modules are based on local swift packages)
  - `Core`: is a library which represents the smallest piece in modular ecosystem. It contains the project related shared codebase. The library can be imported into all internal module in ecosystem, but it have to be internally independent. Only external dependecies are allowed, but the count have to be as small as possible.
  - `Utilities`: is a library which represents the smallest independent piece of ecosystem. No dependency is allowed, either internal or external. The library contains utilities, extensions and functions which are helpers for building more flexible and readable code. No project specified constants are allowed here
  - `Repository`: is a library which is responsible to getting data into the target. Contains also data models and data-coding. Technologically is based on reactive programming (Combine). 
  - `DesignSystem`: is a library which contains the common pieces of the UI. Here are specified all the UI related constants, colors, icons, fonts... 
- **Atomic design** (https://atomicdesign.bradfrost.com)

## Path finding
The data holder is a `Directed Graph`. After connections are loaded from the API and parsed into the specified structures, the graph is constructed. Each path finding request then is going through the graph. The graph returns every possible connection between two vertices (even with multiple stops). Algorithmically this is a pathfinding between 2 vertices based on recursion where the visited vertices are marked. The result is a list of possible connections sorted by price.

## Tests
The repository module is highly covered with tests. Covered parts: 
- **graph** (construction, vertices, edges, path finding)
- **trip repository** (data loading from `Mock`, data validation, finding connection trough graph)

The local module tests are also linked into the main target, so it's enough to run tests from there.
