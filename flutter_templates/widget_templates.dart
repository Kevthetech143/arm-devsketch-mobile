/// DevSketch Mobile - Flutter Widget Template Library
/// Auto-generated code templates for UI element detection
/// Material 3 compliant

// ============================================================
// TEMPLATE 1: BUTTON WIDGETS
// ============================================================

/// Elevated Button (Primary action)
String elevatedButtonTemplate({
  required String label,
  double? width,
  double? height,
}) => '''
ElevatedButton(
  onPressed: () {
    // TODO: Add action
  },
  style: ElevatedButton.styleFrom(
    ${width != null ? 'minimumSize: Size($width, ${height ?? 48}),' : ''}
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('$label'),
)
''';

/// Text Button (Secondary action)
String textButtonTemplate({
  required String label,
}) => '''
TextButton(
  onPressed: () {
    // TODO: Add action
  },
  child: Text('$label'),
)
''';

/// Outlined Button (Tertiary action)
String outlinedButtonTemplate({
  required String label,
  double? width,
}) => '''
OutlinedButton(
  onPressed: () {
    // TODO: Add action
  },
  style: OutlinedButton.styleFrom(
    ${width != null ? 'minimumSize: Size($width, 48),' : ''}
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('$label'),
)
''';

/// Icon Button
String iconButtonTemplate({
  required String iconName,
}) => '''
IconButton(
  onPressed: () {
    // TODO: Add action
  },
  icon: Icon(Icons.$iconName),
)
''';

// ============================================================
// TEMPLATE 2: TEXT FIELD WIDGETS
// ============================================================

/// Standard TextField
String textFieldTemplate({
  String? label,
  String? hint,
  bool obscure = false,
  double? width,
}) => '''
TextField(
  ${obscure ? 'obscureText: true,' : ''}
  decoration: InputDecoration(
    ${label != null ? "labelText: '$label'," : ''}
    ${hint != null ? "hintText: '$hint'," : ''}
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
  ),
)
''';

/// TextField with Controller
String textFieldWithControllerTemplate({
  required String controllerName,
  String? label,
  String? hint,
}) => '''
TextField(
  controller: $controllerName,
  decoration: InputDecoration(
    ${label != null ? "labelText: '$label'," : ''}
    ${hint != null ? "hintText: '$hint'," : ''}
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
  ),
)
''';

/// Search TextField
String searchFieldTemplate() => '''
TextField(
  decoration: InputDecoration(
    hintText: 'Search...',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    filled: true,
  ),
)
''';

// ============================================================
// TEMPLATE 3: TEXT/LABEL WIDGETS
// ============================================================

/// Headline Text
String headlineTextTemplate({
  required String text,
}) => '''
Text(
  '$text',
  style: Theme.of(context).textTheme.headlineMedium,
)
''';

/// Title Text
String titleTextTemplate({
  required String text,
}) => '''
Text(
  '$text',
  style: Theme.of(context).textTheme.titleLarge,
)
''';

/// Body Text
String bodyTextTemplate({
  required String text,
}) => '''
Text(
  '$text',
  style: Theme.of(context).textTheme.bodyMedium,
)
''';

/// Label Text
String labelTextTemplate({
  required String text,
}) => '''
Text(
  '$text',
  style: Theme.of(context).textTheme.labelMedium,
)
''';

/// Custom Styled Text
String styledTextTemplate({
  required String text,
  double? fontSize,
  String? fontWeight,
  String? color,
}) => '''
Text(
  '$text',
  style: TextStyle(
    ${fontSize != null ? 'fontSize: $fontSize,' : ''}
    ${fontWeight != null ? 'fontWeight: FontWeight.$fontWeight,' : ''}
    ${color != null ? 'color: $color,' : ''}
  ),
)
''';

// ============================================================
// TEMPLATE 4: CONTAINER WIDGETS
// ============================================================

/// Basic Container
String containerTemplate({
  double? width,
  double? height,
  double? padding,
  double? borderRadius,
  String? color,
}) => '''
Container(
  ${width != null ? 'width: $width,' : ''}
  ${height != null ? 'height: $height,' : ''}
  ${padding != null ? 'padding: EdgeInsets.all($padding),' : ''}
  decoration: BoxDecoration(
    ${color != null ? 'color: $color,' : 'color: Theme.of(context).colorScheme.surface,'}
    ${borderRadius != null ? 'borderRadius: BorderRadius.circular($borderRadius),' : ''}
  ),
  child: // TODO: Add child widget
)
''';

/// Card Container
String cardTemplate({
  double? width,
  double? padding,
}) => '''
Card(
  ${width != null ? 'child: SizedBox(width: $width),' : ''}
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: EdgeInsets.all(${padding ?? 16}),
    child: // TODO: Add child widget
  ),
)
''';

/// Decorated Container with Shadow
String decoratedContainerTemplate({
  double? width,
  double? height,
}) => '''
Container(
  ${width != null ? 'width: $width,' : ''}
  ${height != null ? 'height: $height,' : ''}
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: // TODO: Add child widget
)
''';

// ============================================================
// TEMPLATE 5: LAYOUT WIDGETS (COLUMN/ROW)
// ============================================================

/// Column Layout
String columnTemplate({
  String alignment = 'start',
  double? spacing,
  List<String>? children,
}) => '''
Column(
  mainAxisAlignment: MainAxisAlignment.$alignment,
  crossAxisAlignment: CrossAxisAlignment.${alignment == 'center' ? 'center' : 'start'},
  children: [
    ${children?.join(',\n    ') ?? '// TODO: Add children'}
    ${spacing != null ? "SizedBox(height: $spacing)," : ''}
  ],
)
''';

/// Row Layout
String rowTemplate({
  String alignment = 'start',
  double? spacing,
  List<String>? children,
}) => '''
Row(
  mainAxisAlignment: MainAxisAlignment.$alignment,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    ${children?.join(',\n    ') ?? '// TODO: Add children'}
    ${spacing != null ? "SizedBox(width: $spacing)," : ''}
  ],
)
''';

/// Spaced Column (with gaps)
String spacedColumnTemplate({
  double spacing = 16,
}) => '''
Column(
  children: [
    // TODO: Add first widget
    SizedBox(height: $spacing),
    // TODO: Add second widget
    SizedBox(height: $spacing),
    // TODO: Add third widget
  ],
)
''';

/// Spaced Row (with gaps)
String spacedRowTemplate({
  double spacing = 16,
}) => '''
Row(
  children: [
    // TODO: Add first widget
    SizedBox(width: $spacing),
    // TODO: Add second widget
    SizedBox(width: $spacing),
    // TODO: Add third widget
  ],
)
''';

// ============================================================
// TEMPLATE 6: IMAGE WIDGETS
// ============================================================

/// Image Placeholder
String imagePlaceholderTemplate({
  double? width,
  double? height,
}) => '''
Container(
  width: ${width ?? 200},
  height: ${height ?? 150},
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceVariant,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.image,
    size: 48,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  ),
)
''';

/// Network Image
String networkImageTemplate({
  required String url,
  double? width,
  double? height,
}) => '''
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.network(
    '$url',
    ${width != null ? 'width: $width,' : ''}
    ${height != null ? 'height: $height,' : ''}
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(child: CircularProgressIndicator());
    },
  ),
)
''';

// ============================================================
// TEMPLATE 7: ICON WIDGETS
// ============================================================

/// Icon Widget
String iconTemplate({
  required String iconName,
  double? size,
  String? color,
}) => '''
Icon(
  Icons.$iconName,
  ${size != null ? 'size: $size,' : ''}
  ${color != null ? 'color: $color,' : ''}
)
''';

// ============================================================
// TEMPLATE 8: APP BAR
// ============================================================

/// Standard AppBar
String appBarTemplate({
  required String title,
  bool hasBackButton = false,
  List<String>? actions,
}) => '''
AppBar(
  ${hasBackButton ? '' : 'automaticallyImplyLeading: false,'}
  title: Text('$title'),
  centerTitle: true,
  ${actions != null ? '''
  actions: [
    ${actions.join(',\n    ')}
  ],''' : ''}
)
''';

// ============================================================
// TEMPLATE 9: SCAFFOLD STRUCTURE
// ============================================================

/// Full Page Scaffold
String scaffoldTemplate({
  required String title,
  bool hasBottomNav = false,
  bool hasFab = false,
}) => '''
Scaffold(
  appBar: AppBar(
    title: Text('$title'),
    centerTitle: true,
  ),
  body: SafeArea(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: // TODO: Add body content
    ),
  ),
  ${hasFab ? '''
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // TODO: Add action
    },
    child: Icon(Icons.add),
  ),''' : ''}
  ${hasBottomNav ? '''
  bottomNavigationBar: NavigationBar(
    destinations: [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
    ],
  ),''' : ''}
)
''';

// ============================================================
// TEMPLATE 10: LIST WIDGETS
// ============================================================

/// List Tile
String listTileTemplate({
  required String title,
  String? subtitle,
  bool hasLeading = false,
  bool hasTrailing = false,
}) => '''
ListTile(
  ${hasLeading ? 'leading: CircleAvatar(child: Icon(Icons.person)),' : ''}
  title: Text('$title'),
  ${subtitle != null ? "subtitle: Text('$subtitle')," : ''}
  ${hasTrailing ? 'trailing: Icon(Icons.chevron_right),' : ''}
  onTap: () {
    // TODO: Add action
  },
)
''';

/// ListView
String listViewTemplate() => '''
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
''';

// ============================================================
// DETECTION CLASS MAPPING
// ============================================================

/// Maps detected UI element types to appropriate templates
class UIElementTemplateMapper {
  static String getTemplate(String detectedClass, Map<String, dynamic> params) {
    switch (detectedClass.toLowerCase()) {
      case 'button':
        return elevatedButtonTemplate(
          label: params['label'] ?? 'Button',
          width: params['width'],
          height: params['height'],
        );
      case 'textfield':
      case 'input':
        return textFieldTemplate(
          label: params['label'],
          hint: params['hint'],
        );
      case 'text':
      case 'label':
        return bodyTextTemplate(
          text: params['text'] ?? 'Label',
        );
      case 'container':
      case 'box':
      case 'rectangle':
        return containerTemplate(
          width: params['width'],
          height: params['height'],
          borderRadius: 12,
        );
      case 'image':
        return imagePlaceholderTemplate(
          width: params['width'],
          height: params['height'],
        );
      case 'icon':
        return iconTemplate(
          iconName: params['iconName'] ?? 'star',
          size: params['size'],
        );
      default:
        return containerTemplate();
    }
  }
}
