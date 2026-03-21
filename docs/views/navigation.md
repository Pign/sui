# Navigation

## NavigationStack

Wraps content in a navigation container, enabling push/pop navigation with `NavigationLink`.

```haxe
new NavigationStack(
    new VStack([
        new Text("Home"),
        new NavigationLink("Go to Detail", new Text("Detail View"))
    ]).navigationTitle("My App")
)
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `content` | `View` | Root view of the navigation stack |

Always use `.navigationTitle()` on the content view to set the title bar.

## NavigationLink

A button that pushes a destination view onto the navigation stack.

```haxe
new NavigationLink("Settings", new SettingsView())
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String` | Link text |
| `destination` | `View` | View to navigate to |

### NavigationLink.withView

Use a custom view as the link label:

```haxe
NavigationLink.withView(
    new HStack([
        Image.systemImage("gear"),
        new Text("Settings")
    ]),
    new SettingsView()
)
```

## NavigationSplitView

A two-column layout for iPad. Shows a sidebar and detail pane side by side.

```haxe
new NavigationSplitView(
    // Sidebar
    new List([
        new NavigationLink("Overview", new OverviewView()),
        new NavigationLink("Settings", new SettingsView())
    ]),
    // Detail (default)
    new Text("Select an item")
)
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `sidebar` | `View` | Sidebar content |
| `detail` | `View` | Default detail content |

## TabView

A tab bar interface. Each tab has a label, icon, and content view.

```haxe
new TabView([
    { label: "Home",     systemImage: "house",    content: new HomeView() },
    { label: "Search",   systemImage: "magnifyingglass", content: new SearchView() },
    { label: "Settings", systemImage: "gear",     content: new SettingsView() }
])
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `tabs` | `Array<TabItem>` | Tab definitions |

**TabItem fields:**

| Field | Type | Description |
|-------|------|-------------|
| `label` | `String` | Tab label |
| `systemImage` | `String` | SF Symbol icon name |
| `content` | `View` | Tab content view |
