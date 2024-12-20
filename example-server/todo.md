Here's a comprehensive list of common Flutter widgets and features you might want to wrap first:
Basic Layout Widgets:

Container (done)
Column (done)
Row (done)
Center (done)
Stack (done)
Expanded (done)
Flexible (done)
SizedBox (done)
Padding (done)
Align (done)
Positioned (done)
ConstrainedBox (done)
Wrap (done)
AspectRatio
FractionallySizedBox
LayoutBuilder
OrientationBuilder
MediaQuery
Visibility (done)
Spacer (done)

Input & Form Widgets:

TextField (done)
TextFormField (done)
Form (done)
Checkbox (done)
Radio (done)
Switch (done)
Slider (done)
DropdownButton (done)
ElevatedButton (done)
TextButton (done)
IconButton (done)
Switch
Radio
CheckboxListTile
RadioListTile
SwitchListTile
SearchBar
SegmentedButton

Advanced Interaction:

RefreshIndicator (done)
Draggable
DragTarget
ReorderableListView
Dismissible
InteractiveViewer (for zoom/pan)

Responsive Widgets:

AdaptiveWidget
ResponsiveWidget

Media & Images:

VideoPlayer
AudioPlayer
Gallery

Content Display:

Text (done)
Image (done)
Icon (done)
CircleAvatar (done)
Placeholder (done)
Card (done)
Divider (done)
ListTile (done)
ExpansionTile (done)

Scrolling:

SingleChildScrollView (done)
ListView (done)
GridView (done)
CustomScrollView (done)
SliverList (done)
SliverGrid (done)
SliverAppBar (done)
SliverPersistentHeader (NOT DONE - requires extensive abstraction)

Navigation & Structure:

Scaffold (done)
AppBar (done)
BottomNavigationBar (done)
Drawer (done)
TabBar (done)
TabBarView (done)

Animation:

AnimatedContainer
AnimatedOpacity
Hero
FadeTransition
SlideTransition
Transform
RotatedBox

Visuals & Effects:
Chip (done)
Badge (done)
ClipRRect (done)
ClipOval (done)
ClipRect (done)
ClipPath (done)
BackdropFilter
DecoratedBox
Material

Gestures:

GestureDetector (done)
InkWell (done)
DragTarget
Draggable

Utility Widgets:

FutureBuilder
StreamBuilder
ValueListenableBuilder

Builtin Functions to Consider:

Navigation:

#navigator.push()
#navigator.pop()
#navigator.pushNamed()

HTTP:

#http.get()
#http.post()
#http.put()
#http.delete()

Storage:

#storage.read()
#storage.write()
#storage.remove()

Builders:

#builder.list()
#builder.grid()
#builder.sliver()

Platform:

#platform.getLocation()
#platform.showNotification()
#platform.share()

Animation:

#animation.tween()
#animation.curve()
#animation.controller()

Media:

#media.pickImage()
#media.pickFile()
#media.takePhoto()

Utils:

#color.fromHex()
#color.lerp()
#datetime.now()
#json.encode()
#json.decode()