<h1 align="center"> Tradeasy </h1> <br>
<p align="center">
  <a href="https://github.com/saifKader/TradeasySwiftUI">
       <img alt="Tradeasy" title="Tradeasy" src="https://raw.githubusercontent.com/saifKader/TradeasySwiftUI/49c3b36539a085bb9f0d35c6d853c5b440b60212/tradeasy/Assets.xcassets/app_logo_48.imageset/app_logo_48.svg" width="100">
  </a>
</p>

<p align="center">
  Buy, sell, make auctions and a ton more !
</p>

<p align="center">
  <a href="#">
    <img alt="Download on the App Store" title="App Store" src="http://i.imgur.com/0n2zqHD.png" width="140">
  </a>

  <a href="https://appgallery.huawei.com/app/C107547423">
    <img alt="Get it on Google Play" title="Google Play" src="https://i.imgur.com/eiGqNZx.png" width="140">
  </a>
</p>

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Contributors](#contributors)
- [Build Process](#build-process)


<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction


Treadeasy allows you to find products that fits your needs , sell yours , make auctions and so on. This app will help you become a better reseller and start your shopping spree easily.

**Available for both [iOS](https://github.com/saifKader/TradeasySwiftUI) and  [Android](https://github.com/SouhailKrs/TradeasyAndroid).**

## App structure
Tradeasy is built using a **clean architecutre.** , with a focus on separation of concerns and maintainability. The clean architecture provides a clear structure and helps to keep the codebase organized and modular.

The application follows the principles of clean architecture by dividing the codebase into distinct layers, each with its own responsibilities and dependencies. These layers include:

* **Presentation Layer** : This layer handles the user interface components, such as activities, fragments, and views. It is responsible for displaying data to the user and capturing user interactions. The presentation layer communicates with the other layers through interfaces or abstractions.

* **Domain Layer** : The domain layer contains the core business logic of the application. It defines the use cases and business rules that govern the behavior of the application. This layer is independent of any framework or technology-specific implementation details.

* **Data Layer** : The data layer is responsible for managing data access and storage. It includes repositories, data sources, and network clients. The data layer abstracts the details of data retrieval and storage, allowing the domain layer to work with data through interfaces and models.




## Features

* Create and participate in auctions
* Browse and search for products and services
* Communicate with other users 
* Apply labels and categories to listings
* Track and manage your purchases and sales
* Follow and favorite sellers and listings
* Receive notifications for new listings and bids
* Easily search for any listing
<p align="center">
  <img src="https://i.imgur.com/GwuCGAj.png" width=200>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <img src="https://i.imgur.com/5iZwqPp.png" width=200>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <img src="https://i.imgur.com/307iGPk.png" width=200>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>





## Build Process

- Follow the [SwiftUI Guide](https://developer.apple.com/tutorials/swiftui) for getting started building a project with native code.
- Clone or download the repo 

```{r klippy, echo=FALSE, include=TRUE}
git clone https://github.com/saifKader/TradeasySwiftUI
```

- Additionally, to set up the backend , you can obtain the necessary resources and instructions [here](https://github.com/SouhailKrs/TradeasyBackend).


