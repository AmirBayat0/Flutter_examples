import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  final int page;

  const DemoPage({Key? key, required this.page}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  List<String> body = [
    ''''In Winterfell, Ned Stark becomes Hand of the King to Robert Baratheon, bringing his daughters, Sansa and Arya, with him to King’s Landing. Ned's son, Bran, is paralyzed after stumbling upon Robert's wife, Cersei Lannister, having sex with her brother, Jaime. Ned discovers that Robert and Cersei's three children are in fact Jaime and Cersei's three children, and are not rightful heirs to the throne. Following Robert's death, however, Cersei's eldest, Joffrey, is crowned. Ned's refusal to recognize Joffrey as king leads to his execution. Meanwhile, Ned's bastard son Jon Snow joins the Night's Watch, an ancient order sworn to defend Westeros by maintaining the Wall. In Essos, the exiled Viserys Targaryen marries his sister, Daenerys, off to Dothraki warlord Khal Drogo in exchange for an army to take back Westeros, where his father was once king. Daenerys is gifted three dragon eggs while Viserys is eventually killed by Drogo, who later dies himself. Daenerys then hatches the dragon eggs, bringing dragons back into the world.''',
    '''Ned's eldest son, Robb, takes Jaime prisoner in a recently declared war with the Lannisters. His mother, Catelyn, sends Brienne of Tarth to escort Jaime to King's Landing, where she believes she can trade him for her daughters. In King's Landing, Sansa is frequently abused by Joffrey while acting Hand of the King and youngest Lannister child Tyrion works with Cersei to prepare for Stannis Baratheon's upcoming attack on the capitol. He attacks, but fails. Having escaped, Arya finds herself trapped in Harrenhal serving as cup bearer to Lannister patriarch Tywin, but manages to escape. Ned's ward, Theon Greyjoy, betrays Robb and takes Winterfell for himself, forcing Bran and youngest Stark child Rickon to flee to the Wall. Beyond the Wall, Jon gains the trust of the Wildlings while Samwell Tarly, encounters White Walkers. In Essos, Daenerys and her khalassar find refuge in Qarth, but Daenerys had her dragons stolen. She recovers them, steals some wealth, and leaves the city.''',
    '''After Robb breaks his vow to marry one of Walder Frey's daughters, Frey arranges the massacre of Robb, his mother, his wife, and all his bannermen, during a wedding feast. After Robb's death, Roose Bolton is appointed the new Warden of the North by Tywin, who is now Hand of the King. Theon is tortured by Roose's bastard son, Ramsay Snow. Further north, Jon Snow climbs the Wall with a Wildling party and ends up on its south side, but then betrays them. In the capital, King Joffrey has decided to marry Margaery of House Tyrell, setting Sansa aside. Tywin, however, arranges Sansa's marriage with his son, Tyrion. Jaime reaches King's Landing, having had his dominant hand cut off. In Essos, Daenerys acquires "The Unsullied", an army of eunuch slave soldiers. She also joins forces with the "Second Sons", a company of mercenaries, and becomes the Queen of Yunkai.''',
    '''In King's Landing, Lady Olenna secretly poisons King Joffrey at his wedding with her granddaughter Margaery, but Tyrion is falsely accused of the murder by his family, and is found guilty. However, Jaime and Varys conspire to smuggle Tyrion to Essos. Tyrion kills his father Tywin before leaving. Petyr Baelish smuggles Sansa into the Vale, ruled by her aunt and his lover, the widowed Lysa Arryn. Baelish marries Lysa but later kills her. After attempting to reunite with her family, Arya takes a ship bound for Braavos, in Essos. Having returned to the Night's Watch, Jon Snow defends Castle Black against an army of Wildlings, who are superior in strength. The Watch is rescued by the arrival of Stannis Baratheon and his forces. A crippled Bran with newfound powers travels north beyond the Wall with a few companions. Beneath a weirwood tree, he finds the Three-eyed Raven, an old man with the ability to perceive future and past. In Essos, Daenerys takes control of Meereen and abolishes slavery. When she discovers that her trusted advisor, Ser Jorah Mormont, had spied on her for Robert Baratheon, she exiles him.''',
    '''In King's Landing, Margaery marries the new King Tommen Baratheon, Joffrey's younger brother. The Sparrows, a group of religious fanatics, impose their views upon the city, imprisoning Margaery, her brother Loras, and Cersei for committing various sins. Jaime travels to Dorne to take back Myrcella Baratheon. However, Oberyn Martell's lover, Ellaria and his bastard daughters kill Myrcella as revenge for Oberyn's death. In Winterfell, the new seat of House Bolton, Baelish arranges Sansa's marriage with the now-legitimized son of Roose Bolton, the sadist Ramsay. Stannis's unsuccessful march on Winterfell, which leads to his death, allows Sansa the opportunity to escape with Theon. At the Wall, as the newly elected Lord Commander of the Night's Watch, Jon Snow forms an alliance with the Wildlings to save them from the White Walkers and their army of reanimated corpses. However, Jon is stabbed to death by some brothers who see him as a traitor. Arya arrives in Braavos, where she finds Jaqen H'ghar whom she had previously helped escape, and begins training with the Faceless Men, a guild of assassins. In Essos, Tyrion becomes an advisor to Daenerys. Ser Jorah saves the life of Daenerys against a revolt of slavers, who flees Meereen on Drogon's back.''',
    '''At the Wall, Melisandre resurrects Jon. Jon reunites with Sansa and leaves the Night's Watch. Aided by the Wildlings, loyalists and the Knights of the Vale, they defeat the Boltons and Jon is proclaimed the King in the North. Beyond the Wall, Bran trains with the Three-eyed Raven but they come under attack by the White Walkers. The Three-eyed Raven is killed and succeeded by Bran, who escapes with the help of Hodor, who dies in the process. Bran realizes Jon is in fact the son of his deceased aunt Lyanna Stark. In Braavos, Arya continues her training with the Faceless Men, but eventually leaves them and returns to Westeros to take revenge on Walder Frey. In King's Landing, Cersei demolishes the Great Sept with wildfire. Many die, including the High Sparrow, Margaery, and Loras. Tommen kills himself after witnessing the events, and Cersei is crowned Queen. In the Iron Islands, Euron Greyjoy usurps leadership by killing his brother and Theon's father, Balon. Daenerys gets captured by the Dothraki but gains their devotion by burning their leaders alive. She forgives Ser Jorah. She returns to Meereen, in time to save the city from a naval siege by slavers, then sails for Westeros, joined by Theon and his sister Yara. Ellaria seizes control of Dorne, and joins Olenna Tyrell in an alliance with Daenerys.''',
    '''Daenerys arrives in Westeros and takes over Dragonstone. She plans to overthrow Cersei, but Jon arrives to instead save Westeros from the White Walkers. The two fall in love and together they venture beyond the Wall to prove the threat of the White Walkers. The Night King - leader of the White Walkers - kills and reanimates Daenerys' dragon Viserion during the mission. Jon and Daenerys then attempt to persuade Cersei to join their cause by showing the existence of a wight they had captured, but she has her own plans to increase control over the continent. At Winterfell, Sansa is reunited with her siblings, Arya and Bran. When Lord Protector of the Vale Petyr Baelish begins to turn the Stark children against one another, they manage to have him executed. In a vision, Bran sees that his aunt, Lyanna, was, in fact, married to Prince Rhaegar, and that Jon's real name is Aegon Targaryen, making him the true heir to the Iron Throne. After his sister Yara is kidnapped by his uncle Euron, Theon sets out to save her. The Night King demolishes a section of The Wall with the help of the reanimated Viserion, allowing the White Walkers and Army of the Dead to pass into the Seven Kingdoms.''',
    '''Jon and Daenerys travel to Winterfell and learn the Army of the Dead has breached the Wall. Theon rescues Yara, then returns to Winterfell. Sam reveals to Jon that he is actually Aegon Targaryen. Jaime arrives at Winterfell, revealing Cersei will not help defeat the Army of the Dead. Jon reveals his Targaryen lineage to Daenerys, who wants it kept a secret. After a battle, Arya kills the Night King, destroying the Army of the Dead. With the Army of the Dead defeated, Daenerys turns her attention towards the Iron Throne. Euron's navy kills Rhaegal and captures Missandei, who is later executed by Cersei, enraging Daenerys, who, after her army takes King's Landing, destroys much of the city indiscriminately. Cersei and Jaime are killed. Tyrion denounces Daenerys and is imprisoned for treason to await execution. Jon, unable to stop Daenerys, is forced to kill her. Bran Stark is proclaimed king, allowing the North to secede as an independent kingdom. Bran appoints Tyrion as his Hand. Sansa is crowned Queen in the North, and Arya sails to find new lands. Jon is sentenced to the Night's Watch, and leads the Wildlings back north of the Wall.''',
  ];
  List<String> titles = [
    'Season 1 (2011)',
    'Season 2 (2012)',
    'Season 3 (2013)',
    'Season 4 (2014)',
    'Season 5 (2015)',
    'Season 6 (2016)',
    'Season 7 (2017)',
    'Season 8 (2019)',
  ];
  List<String> subTitles = [
    'Winter Is Coming',
    'The Kingsroad',
    'Lord Snow',
    'Cripples, Bastards, and Broken Things',
    'The Wolf and the Lion'
        'A Golden Crown',
    'You Win or You Die',
    'The Pointy End',
  ];
  List<String> images = [
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-night-king-1-1551377346.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-arya-1551376577.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-bran-1551376577.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-tyrion-1551376579.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-cersei-1551376577.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-dani-1551376577.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-davos-1551376577.jpg?crop=1xw:1xh;center,top&resize=980:*',
    'https://hips.hearstapps.com/hmg-prod/images/gt8-key-fb-9x16-euron-1551376578.jpg?crop=1xw:1xh;center,top&resize=980:*',
  ];

  @override
  Widget build(BuildContext context) {
    return widget.page == 7
        ? Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://i0.wp.com/insidefilmroom.com/wp-content/uploads/2019/04/giphy.gif?resize=480%2C269&ssl=1',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      titles[widget.page],
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'GOT : ${subTitles[widget.page]}',
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 24.0,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          body[widget.page],
                          style: const TextStyle(
                              fontSize: 14, fontFamily: 'Droid Sans'),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Image.network(
                          images[widget.page],
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (widget.page + 1).toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Droid Sans',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          );
  }
}
