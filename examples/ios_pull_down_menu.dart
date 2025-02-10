import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: Banner(
        message: 'Flexz',
        location: BannerLocation.topEnd,
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Retrieve screen dimensions
    final screenSize = MediaQuery.of(context).size;

    // Define the center position where the menu should appear
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 1.5; // Slightly above the center

    // Create a small rectangular region as an anchor point for the menu
    final centerRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: 0, // No width needed, just an anchor point
      height: 0, // No height needed, just an anchor point
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pull Down Buttons Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First button to show pull-down menu with profile and actions
            CupertinoButton.filled(
              onPressed: () async {
                await showPullDownMenu(
                  context: context,
                  items: [
                    PullDownMenuHeader(
                      leading: ColoredBox(
                        color: CupertinoColors.systemBlue.resolveFrom(context),
                      ),
                      title: 'Profile',
                      subtitle: 'Tap to open',
                      onTap: () {},
                      icon: CupertinoIcons.profile_circled,
                    ),
                    PullDownMenuItem(
                      onTap: () {},
                      title: 'Pin',
                      icon: CupertinoIcons.pin,
                    ),
                    PullDownMenuItem(
                      title: 'Forward',
                      subtitle: 'Share in different channel',
                      onTap: () {},
                      icon: CupertinoIcons.arrowshape_turn_up_right,
                    ),
                    PullDownMenuItem(
                      onTap: () {},
                      title: 'Delete',
                      isDestructive: true,
                      icon: CupertinoIcons.delete,
                    ),
                  ],
                  position: centerRect,
                );
              },
              child: const Text("Medium size Action Item"),
            ),
            const SizedBox(height: 10),

            // Second button to show a pull-down menu with actions row
            CupertinoButton.filled(
              onPressed: () async {
                await showPullDownMenu(
                  context: context,
                  items: [
                    PullDownMenuActionsRow.medium(
                      items: [
                        PullDownMenuItem(
                          onTap: () {},
                          title: 'Reply',
                          icon: CupertinoIcons.arrowshape_turn_up_left,
                        ),
                        PullDownMenuItem(
                          onTap: () {},
                          title: 'Copy',
                          icon: CupertinoIcons.doc_on_doc,
                        ),
                        PullDownMenuItem(
                          onTap: () {},
                          title: 'Edit',
                          icon: CupertinoIcons.pencil,
                        ),
                      ],
                    ),
                  ],
                  position: centerRect,
                );
              },
              child: const Text("Medium size Action Row"),
            ),
            const SizedBox(height: 10),

            // Third button to show a more complex pull-down menu
            PullDownButton(
              itemBuilder: (context) => [
                PullDownMenuItem(
                  title: 'Photo Library',
                  icon: CupertinoIcons.photo_on_rectangle,
                  onTap: () {},
                ),
                const PullDownMenuDivider(),
                PullDownMenuItem(
                  title: 'Take Photo or Video',
                  onTap: () {},
                  icon: CupertinoIcons.camera,
                ),
                const PullDownMenuDivider(),
                PullDownMenuItem(
                  title: 'Choose File',
                  onTap: () {},
                  icon: CupertinoIcons.folder,
                  isDestructive: false,
                ),
              ],
              buttonBuilder: (context, showMenu) => CupertinoButton(
                onPressed: showMenu,
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.ellipsis_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
