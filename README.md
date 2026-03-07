# TabBar

A tvOS tab bar with support for categories, genres, search, and settings.

## Installation

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/resoul/TabBar.git", from: "1.0.0")
]
```

Or via Xcode: **File → Add Package Dependencies** → paste the repository URL.

---

## Quick Start

```swift
import TabBar

let config = TabBarConfiguration(
    items: [
        TabItem(id: "home",    title: "Home",     icon: "house.fill"),
        TabItem(id: "movies",  title: "Movies",   icon: "film.fill", genres: [
            GenreItem(id: "action", title: "Action"),
            GenreItem(id: "comedy", title: "Comedy"),
        ]),
        TabItem(id: "series",  title: "Series",   icon: "tv.fill"),
        TabItem(id: "favs",    title: "Favorites", icon: "heart.fill"),
    ]
)

let tabBar = TabBarView(configuration: config)
tabBar.delegate = self
view.addSubview(tabBar)
```

---

## Delegate

```swift
extension MyViewController: TabBarDelegate {

    func tabBar(_ tabBar: TabBarView, didSelectItem item: TabItem) {
        // item.id, item.title, item.genres
    }

    func tabBar(_ tabBar: TabBarView, didSelectGenre genre: GenreItem, inItem item: TabItem) {
        // genre.id, item.id
    }

    func tabBarDidSelectSearch(_ tabBar: TabBarView) { }

    func tabBarDidSelectSettings(_ tabBar: TabBarView) { }
}
```

---

## Configuration

```swift
TabBarConfiguration(
    items: [...],
    mainRowHeight: 76,       // height of the main tab row
    genreRowHeight: 58,      // height of the genre row
    backgroundColor: .black,
    separatorColor: UIColor(white: 1, alpha: 0.07),
    activeColor: .white,
    inactiveColor: UIColor(white: 0.45, alpha: 1),
    focusedBgAlpha: 0.18
)
```

---

## Focus After Modal Dismiss

Call `lockSettingsFocus()` before `present()` and `unlockSettingsFocus()` in the `dismiss` completion block. This prevents focus from returning to the settings button after the modal is closed.

```swift
tabBar.lockSettingsFocus()
present(settingsVC, animated: true)

// in dismiss completion:
tabBar.unlockSettingsFocus()
```

---

## Requirements

- tvOS 16+
- Swift 5.9+
