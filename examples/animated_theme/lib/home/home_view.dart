import 'package:animated_theme/home/widget/change_quantity_of_product.dart';
import 'package:animated_theme/theme/app_theme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> images = [
    'https://akkasi.art/wp-content/uploads/2020/01/pos_men_photography_akasi_poz_mardane_3.jpg',
    'https://honarfardi.com/wp-content/uploads/2019/02/word-image-148.jpeg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjyvK0caRYiCNMmUWUy4dpyVkxeZ_E_-yaIKgRFZmUKM9KCwgrX-_k8iXhFKoPbHPgdU0&usqp=CAU',
  ];
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var darkTheme = Themes.darkTheme;
    var lightTheme = Themes.lightTheme;

    return ThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: ThemeSwitcher(
            clipper: const ThemeSwitcherCircleClipper(),
            builder: (context) {
              return IconButton(
                icon: Icon(
                  ThemeModelInheritedNotifier.of(context).theme.brightness ==
                          Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  var brightness =
                      ThemeModelInheritedNotifier.of(context).theme.brightness;
                  ThemeSwitcher.of(context).changeTheme(
                    theme:
                        brightness == Brightness.light ? darkTheme : lightTheme,
                    isReversed: brightness == Brightness.light ? true : false,
                    // isReversed: false,
                    // isReversed: true,
                  );
                },
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Column(
                children: [
                  /// Top Image and Shipping
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                                'https://freepngimg.com/thumb/gloves/55145-4-school-bag-free-transparent-image-hd.png'),
                          ),
                        ),

                        /// Free Shipping and like Icon
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              left: 8,
                              top: 15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Free Shipping",
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Center(
                                    child: Icon(
                                      IconlyBold.heart,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Infos
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),

                          Expanded(
                            flex: 1,
                            child: Text(
                              'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops"',
                              style: theme.textTheme.titleLarge,
                              maxLines: 2,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Text(
                              "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                              style: theme.textTheme.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    "\$109.95,",
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(fontSize: 35),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: ChangeStatusQuantity(
                                    quantity: 1,
                                    add: () {},
                                    minus: () {},
                                    iconSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// people pinned
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: List.generate(
                                            3,
                                            (index) => CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              backgroundImage: NetworkImage(
                                                images[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "8,200 + people pinned this",
                                          maxLines: 2,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                /// Coupon
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            "Have a coupon code? enter here👇",
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: TextField(
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(fontSize: 14),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.5,
                                                ),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  800
                                                              ? 10
                                                              : 20),
                                              suffixIcon: SizedBox(
                                                width: 95,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Write code",
                                                      style: theme
                                                          .textTheme.titleLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 13),
                                                    ),
                                                    const Icon(
                                                      IconlyBold.info_square,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              hintStyle: theme
                                                  .textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12),
                                              hintText:
                                                  "Add Your Coupon Code Here",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Divider(),

                                /// BottomButton

                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 17, right: 17, bottom: 10),
                                    child: MaterialButton(
                                      height: 60,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  IconlyLight.bag,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Add product to cart",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: 2,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              119,
                                                              255,
                                                              255,
                                                              255),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                const Text(
                                                  "\$109.95",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
