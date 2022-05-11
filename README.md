# Beacon

## Requirements
* iOS 15+
* XCode 13+
* ARKit 5
* RealityKit 2

**Note:** This app cannot be run in the XCode simulator and needs an actual device to run due to ARKit

**Note:** Recommended to use with an iPhone 12 or 13 with LIDAR as these devices will have improved AR Experiences. Additionally, phones provide a better usability than iPads due to their cellular connectivity, therefore greater GPS accuracy. 

---

## Installation
1. Clone GitHub source code
2. Get the [Alan iOS SDK framework](https://alan.app/docs/client-api/ios/ios-api/#step-1-get-the-alan-ios-sdk-framework)
   1. Download and extract the AlanSDK.xcframework.zip file from the latest release and extract AlanSDK.xcframework
   2. Move the AlanSDK.xcframework to the root of the Xcode project.
   3. In the General tab, under the Frameworks -> Libraries -> Embedded Content section, select Embed & Sign for the AlanSDK.xcframework
3. Select the Beacon App top layer -> Targets (Beacon) -> Signing & Capabilities -> Choose a provisonal profile

## Source Files 
Below is our file structure for the Core Beacon App. The top level folders are organized as follows

### 📁 3D Assets & Assets
Our 3D models and thumbnails that are packaged into the application 

### 📁 Managers & ViewModels
In the MVVM architecture, these folders were for our View Models that managed our application data and state 

### 📁 Models
The Models in our MVVM architecture. This was used to create a custom model class that loaded our 
3D models

### 📁 Resources
Our custom Hand Pose Classifcation model

### 📁 Views
The views and subviews of our application

### Complete Tree Structure

```
Beacon
 ┣ 3Dassets
 ┣ Assets.xcassets
 ┣ Extensions
 ┃ ┗ View+Extensions.swift
 ┣ Managers
 ┃ ┣ ARSessionManager
 ┃ ┃ ┣ ARSessionManager.swift
 ┃ ┃ ┣ ARSessionManagerAnchors.swift
 ┃ ┃ ┣ ARSessionManagerDelegate.swift
 ┃ ┃ ┗ ARSessionManagerGestures.swift
 ┃ ┣ LocationBasedManager.swift
 ┃ ┣ ModelDeletionManager.swift
 ┃ ┗ PlacementSettings.swift
 ┣ Models
 ┃ ┗ Model.swift
 ┣ Resources
 ┃ ┗ HandPoseClassification.mlmodel
 ┣ ViewModels
 ┃ ┣ MapViewModel.swift
 ┃ ┗ ModelsViewModel.swift
 ┣ Views
 ┃ ┣ Map
 ┃ ┃ ┣ MapContainer.swift
 ┃ ┃ ┗ MapView.swift
 ┃ ┣ ARViewContainer.swift
 ┃ ┣ AlanView.swift
 ┃ ┣ BrowseView.swift
 ┃ ┣ CollectionView.swift
 ┃ ┣ ContentView.swift
 ┃ ┣ ControlView.swift
 ┃ ┣ CustomARView.swift
 ┃ ┣ DeletionView.swift
 ┃ ┗ PlacementView.swift
 ┣ BeaconApp.swift
 ┗ ScenePersistenceHelper.swift
```

Utilizing Alan AI SDK, we had to create a custom view controller that layered on top of the Beacon app so that way we could implement the universal microphone. We also needed to implement custom configuration code so it could work with our existing Swift UI Components

```
 Alan
 ┣ AlanSDK.framework
 ┣ AlanSDKButtonState+CustomStringConvertible.swift
 ┣ ObjectAssociation.swift
 ┣ UIApplication+Alan.swift
 ┣ UIApplication+KeyWindow.swift
 ┣ View+OnLoad.swift
 ┗ ViewDidLoadModifier.swift
```