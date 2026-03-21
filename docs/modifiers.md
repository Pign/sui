# Modifiers

All views support modifier chaining. Each modifier returns the view, so you can chain them:

```haxe
new Text("Styled")
    .font(FontStyle.Title)
    .foregroundColor(ColorValue.Blue)
    .bold()
    .padding()
```

## Layout

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.padding()` | none | Default system padding |
| `.padding(value)` | `value: Float` | Fixed padding on all edges |
| `.frame(width, height, alignment)` | `width: Float`, `height: Float`, `alignment: Alignment` | All optional. Sets size constraints |
| `.overlay(content)` | `content: View` | Overlays another view on top |

**Alignment values:** `Center`, `Leading`, `Trailing`, `Top`, `Bottom`, `TopLeading`, `TopTrailing`, `BottomLeading`, `BottomTrailing`

## Typography

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.font(style)` | `style: FontStyle` | Sets the font |
| `.bold()` | none | Bold weight |
| `.italic()` | none | Italic style |
| `.multilineTextAlignment(alignment)` | `alignment: TextAlignment` | `.Leading`, `.Center`, `.Trailing` |
| `.lineLimit(lines)` | `lines: Int` | Maximum number of lines |

**FontStyle values:**

| Style | Usage |
|-------|-------|
| `FontStyle.LargeTitle` | Main screen titles |
| `FontStyle.Title` | Section titles |
| `FontStyle.Title2` | Subsection titles |
| `FontStyle.Title3` | Minor titles |
| `FontStyle.Headline` | Emphasized body text |
| `FontStyle.Subheadline` | Secondary emphasis |
| `FontStyle.Body` | Main content |
| `FontStyle.Callout` | Callout text |
| `FontStyle.Footnote` | Footnotes |
| `FontStyle.Caption` | Caption text |
| `FontStyle.Caption2` | Smaller captions |
| `FontStyle.Custom(name, size)` | Custom font name and size |

## Color & Appearance

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.foregroundColor(color)` | `color: ColorValue` | Text/icon color |
| `.background(color)` | `color: ColorValue` | Background color |
| `.opacity(value)` | `value: Float` | Opacity (0.0 to 1.0) |
| `.cornerRadius(radius)` | `radius: Float` | Rounds corners |

**ColorValue values:** `Primary`, `Secondary`, `Accent`, `Red`, `Orange`, `Yellow`, `Green`, `Blue`, `Purple`, `Pink`, `White`, `Black`, `Gray`, `Clear`, `Custom(hex)`

```haxe
new Text("Custom color")
    .foregroundColor(ColorValue.Custom("#EA8220"))
```

## Shape

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.cornerRadius(radius)` | `radius: Float` | Rounds corners |
| `.clipShape(shape)` | `shape: ShapeType` | Clips to a shape |

**ShapeType values:** `Rectangle`, `RoundedRectangle(cornerRadius)`, `Circle`, `Capsule`

## Navigation

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.navigationTitle(title)` | `title: String` | Sets the navigation bar title |
| `.navigationDestination(content)` | `content: View` | Destination for navigation |

## Interaction

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.disabled(isDisabled)` | `isDisabled: Bool` | Disables interaction (default: `true`) |
| `.searchable(textBinding, prompt)` | `textBinding: String`, `prompt: String` | Adds a search bar |

```haxe
new List([...])
    .searchable("searchText", "Search items...")
```

## Style

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.textFieldStyle(style)` | `style: TextFieldStyleValue` | `.Automatic`, `.RoundedBorder`, `.Plain` |

## Presentation

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.sheet(isPresentedBinding, content)` | `isPresentedBinding: String`, `content: View` | Modal sheet |
| `.alert(title, isPresentedBinding, message)` | `title: String`, `isPresentedBinding: String`, `message: String` | Alert dialog |
| `.confirmationDialog(title, isPresentedBinding, content)` | `title: String`, `isPresentedBinding: String`, `content: View` | Confirmation dialog |
| `.toolbar(content)` | `content: View` | Adds toolbar items |

```haxe
new VStack([...])
    .sheet("showSheet", new Text("Sheet content"))
    .alert("Warning", "showAlert", "Are you sure?")
```

## Animation

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.animation(value)` | `value: String` | Animation curve (e.g. `"default"`, `"easeIn"`, `"spring"`) |
| `.tint(color)` | `color: ColorValue` | Set accent/tint color for this view |
| `.badge(value)` | `value: Dynamic` | Badge on tab items or list rows |
| `.tag(value)` | `value: String` | Tag for Picker selection matching |

## Gestures

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.onTapGesture(action)` | `action: StateAction` | Runs a StateAction when tapped |

```haxe
// Set state on tap
new Text("Select me")
    .onTapGesture(StateAction.SetValue("selected", "true"))

// Use with ForEach for interactive lists
new ForEach("items", "i",
    new Text("{items[i].name}")
        .onTapGesture(StateAction.SetValue("selectedItem", "{items[i].id}"))
)
```

## Lifecycle

| Modifier | Parameters | Description |
|----------|-----------|-------------|
| `.onAppear(action)` | `action: () -> Void` | Called when the view appears |
| `.onDisappear(action)` | `action: () -> Void` | Called when the view disappears |
| `.task(action)` | `action: () -> Void` | Async task that runs on appear |

```haxe
new VStack([...])
    .onAppear(() -> trace("View appeared"))
    .onDisappear(() -> trace("View disappeared"))
    .task(() -> {
        // Runs when view appears, good for loading data
        myState.value = "Loading...";
        var http = new haxe.Http("https://example.com");
        http.onData = (d) -> myState.value = d;
        http.request(false);
    })
```
