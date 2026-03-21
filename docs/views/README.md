# Views

sui provides 22 built-in views that map directly to SwiftUI components.

## All Views

| View | Category | SwiftUI Equivalent | Description |
|------|----------|-------------------|-------------|
| `VStack` | Layout | `VStack` | Vertical stack |
| `HStack` | Layout | `HStack` | Horizontal stack |
| `ZStack` | Layout | `ZStack` | Overlay stack |
| `Spacer` | Layout | `Spacer` | Flexible space |
| `ScrollView` | Layout | `ScrollView` | Scrollable container |
| `Text` | Display | `Text` | Static text |
| `Text.withState` | Display | `Text("\(...)")` | Dynamic text with state interpolation |
| `Label` | Display | `Label` | Icon + text |
| `Image` | Display | `Image` | Image display |
| `Button` | Control | `Button` | Tappable action |
| `TextField` | Control | `TextField` | Text input |
| `SecureField` | Control | `SecureField` | Password input |
| `Toggle` | Control | `Toggle` | Boolean switch |
| `Slider` | Control | `Slider` | Range input |
| `Picker` | Control | `Picker` | Selection control |
| `List` | Container | `List` | Row container |
| `Form` | Container | `Form` | Data entry container |
| `Section` | Container | `Section` | Grouped content |
| `ForEach` | Iteration | `ForEach` | Array iteration |
| `NavigationStack` | Navigation | `NavigationStack` | Navigation container |
| `NavigationLink` | Navigation | `NavigationLink` | Navigation trigger |
| `NavigationSplitView` | Navigation | `NavigationSplitView` | Split view (iPad) |
| `TabView` | Navigation | `TabView` | Tab-based navigation |
| `ConditionalView` | Logic | `if/else` | Conditional rendering |

## Categories

- **[Layout](views/layout.md)** &mdash; VStack, HStack, ZStack, Spacer, ScrollView
- **[Text & Labels](views/text-and-labels.md)** &mdash; Text, Text.withState, Label, Image
- **[Controls](views/controls.md)** &mdash; Button, TextField, Toggle, Slider, Picker
- **[Lists & Iteration](views/lists-and-iteration.md)** &mdash; List, ForEach, ScrollView, Section, Form
- **[Navigation](views/navigation.md)** &mdash; NavigationStack, NavigationLink, NavigationSplitView, TabView
