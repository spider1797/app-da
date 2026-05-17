// Offline FAQ Chatbot Service
// No API calls — works fully offline
// Covers all 10 disaster types + general questions

class ChatbotService {
  static const Map<String, List<Map<String, String>>> _faqData = {
    'flood': [
      {
        'q': 'Flood mein kahan jaayein?',
        'a': '🏠 Upar ki manzil pe jaao. Ground floor bilkul khali karo. Kabhi bhi lift use mat karo — stairs use karo.',
      },
      {
        'q': 'Flood mein kya saaman lena chahiye?',
        'a': '🎒 Mobile + charger, pani ki bottle, important documents (waterproof bag mein), medicines, torch aur thoda khaana.',
      },
      {
        'q': 'Bijli kaise band karein flood mein?',
        'a': '⚡ Ghar ka main switch band karo.濡れた haath ya濡れ ke saath electrical switch bilkul mat chuao.',
      },
      {
        'q': 'Flood ka paani peena safe hai?',
        'a': '🚫 Bilkul nahi! Flood ka paani bohot contaminated hota hai. Sirf bottled ya ubla hua paani piyo.',
      },
      {
        'q': 'Flood ke baad ghar wapas kab jaayein?',
        'a': '✅ Sirf tab jab local authorities ya admin ka "All Clear" alert aaye. Pehle ghar ka structure check karwaao.',
      },
    ],
    'earthquake': [
      {
        'q': 'Earthquake mein Drop Cover Hold kya hai?',
        'a': '🫨 DROP: Abhi neeche baitho. COVER: Table ke neeche jao ya apna sar aur gardan haath se dhako. HOLD: Jab tak shaking ruke tab tak ruko.',
      },
      {
        'q': 'Earthquake mein bahar bhaagna chahiye?',
        'a': '🏃 Earthquake ke DURING bahar mat bhaago — girte pathar se khatra hai. Shaking rukne ke BAAD hi controlled tarike se bahar jao.',
      },
      {
        'q': 'Aftershock kya hota hai?',
        'a': '🔄 Main earthquake ke baad aane wale chhote jolts. Bahar raho, building mein wapas mat jao jab tak safe declare na ho.',
      },
      {
        'q': 'Earthquake mein lift use karein?',
        'a': '🚫 Kabhi nahi! Lift hamesha band ho jaati hai earthquake mein. Sirf stairs use karo.',
      },
      {
        'q': 'Earthquake ke baad gas leak kaise pehchanein?',
        'a': '👃 Sulphur ki smell (sadte anday jaise) aaye toh gas leak hai. Koi switch mat chhuo, khidkiyaan kholo, aur turant bahar jao.',
      },
    ],
    'cyclone': [
      {
        'q': 'Cyclone mein kahan rehna chahiye?',
        'a': '🏚️ Pakki building ke andar, andar waale kamre mein. Khidkiyon aur darwaazon se door raho. Basement ya ground floor pe raho.',
      },
      {
        'q': 'Cyclone warning aane pe kya karein?',
        'a': '📋 Ghar secure karo (khidki, darwaaze band), emergency kit taiyaar karo, gaadi andar rako, aur radio/alerts suno.',
      },
      {
        'q': 'Cyclone ke baad bahar kab niklein?',
        'a': '✅ Sirf jab authorities clear signal dein. "Eye of cyclone" mein mat niklein — storm wapas aa sakta hai.',
      },
    ],
    'heatwave': [
      {
        'q': 'Heatwave mein kya karein?',
        'a': '🌡️ Shade ya AC mein raho. Khub paani piyo (har ghante). Tight, dark kapde mat pehno. Dopahar 12-4 baje bahar mat niklein.',
      },
      {
        'q': 'Heat stroke ke symptoms kya hain?',
        'a': '🆘 Tez bukhar (104°F+), confusion, paseena band ho jaana, laal/hot skin. Turant shade mein le jao, 108 pe call karo.',
      },
      {
        'q': 'Heatwave mein ORS kab peena chahiye?',
        'a': '💧 Agar chakkar aa rahe hain ya kamzori lag rahi hai toh ORS piyo. Aur zyada thaka dene wala kaam avoid karo.',
      },
    ],
    'coldwave': [
      {
        'q': 'Cold wave mein hypothermia se kaise bachein?',
        'a': '🧥 Kai layer kapde pehno (wool/fleece). Sar, haath aur pair dhako — in jagahon se sabse zyada garmi jaati hai.',
      },
      {
        'q': 'Cold wave mein ghar mein heating kaise karein safely?',
        'a': '⚠️ Kerosene heater use karo toh khidki thodi khuli rakhni chahiye. Closed room mein gas/charcoal bilkul mat jalao — CO poisoning hoti hai.',
      },
    ],
    'landslide': [
      {
        'q': 'Landslide ke signs kya hain?',
        'a': '⚠️ Doors/windows ka stuck hona, zameen mein cracks, paani ka muddy ho jaana, ya ped ka jhukna — ye sab early signs hain. Turant area chhodo.',
      },
      {
        'q': 'Landslide ke waqt kahan jaayein?',
        'a': '🏔️ Dhalaanon aur nadiyein se door, high ground pe jao. Kisi valley ya low-lying area mein mat ruko.',
      },
    ],
    'lightning': [
      {
        'q': 'Lightning se kaise bachein?',
        'a': '⚡ Pakki building ya gaadi ke andar jao. Ped ke neeche kabhi mat khade ho. Dhatu ki cheezein chhodo. Paani se door raho.',
      },
      {
        'q': 'Lightning ke waqt kisi bade ped ke neeche khadam ho sakta hai?',
        'a': '🚫 Nahi! Ped lightning attract karta hai. Ped ke neeche khade hona zyada khatarnak hai khule maidaan se bhi.',
      },
    ],
    'epidemic': [
      {
        'q': 'Epidemic mein khud ko kaise protect karein?',
        'a': '😷 Mask pahno, haath dhote raho (20 sec soap se), bheed se bachao, bimaar logon se door raho, aur school ke alert suno.',
      },
      {
        'q': 'Epidemic mein school band hone pe kya karein?',
        'a': '🏠 Ghar pe raho. Admin ke alerts follow karo. Online classes join karo. Symptoms hone pe doctor se milo.',
      },
    ],
    'wildfire': [
      {
        'q': 'Wildfire smoke se kaise bachein?',
        'a': '😷 N95 mask pahno. Ghar ke andar raho. Khidki-darwaaze band rakho. Air purifier use karo.',
      },
      {
        'q': 'Wildfire mein evacuation order aane pe kya karein?',
        'a': '🚗 Turant niklo — wait mat karo. Gaadi mein AC band karo, windows band karo. Designated evacuation route follow karo.',
      },
    ],
    'drought': [
      {
        'q': 'Drought mein paani kaise bachaaein?',
        'a': '💧 Zyada zaroorat pe hi paani use karo. Leaky taps fix karo. Bartan machine ya washing machine full load pe chalao. Garden mein kam paani daalo.',
      },
    ],
    'general': [
      {
        'q': 'Assembly point kahan hai?',
        'a': '📍 Apne school ke admin se poochho ya QR poster dekho. Admin profile mein QR code hota hai jo assembly point indicate karta hai.',
      },
      {
        'q': 'Emergency number kya hai?',
        'a': '📞 Police: 100 | Fire: 101 | Ambulance: 108 | NDMA Helpline: 1078 | Disaster Relief: 1070',
      },
      {
        'q': 'Drill kab hai?',
        'a': '🔔 Alerts tab check karo. Jab admin drill start karega, notification aayega aur app pe countdown shuru ho jaayega.',
      },
      {
        'q': 'QR code kaise scan karein drill mein?',
        'a': '📱 Phone ka default camera app kholoi. Assembly point pe rakhe QR poster pe point karo. App-da automatically khul jaayega aur check-in ho jaayega.',
      },
      {
        'q': 'School code kahan milega?',
        'a': '🏫 Admin ke paas. Admin profile mein school code aur QR code permanently dikh ta hai. Apne teacher ya school admin se maango.',
      },
      {
        'q': 'App-da kaise kaam karta hai?',
        'a': '📱 App-da aapko disaster se bachne mein help karta hai: 1) Disaster modules padhein 2) Quiz dein 3) Admin ke drills mein participate karein 4) Emergency alerts paayein.',
      },
    ],
  };

  // Get all FAQs as a flat list
  static List<Map<String, String>> getAllFaqs() {
    final all = <Map<String, String>>[];
    for (final category in _faqData.values) {
      all.addAll(category);
    }
    return all;
  }

  // Get FAQs by category
  static List<Map<String, String>> getFaqsByCategory(String category) {
    return _faqData[category.toLowerCase()] ?? _faqData['general']!;
  }

  // Fuzzy keyword search
  static List<Map<String, String>> search(String query) {
    if (query.trim().isEmpty) return [];

    final q = query.toLowerCase();
    final all = getAllFaqs();

    // Exact/close match first
    final exactMatches = all.where((faq) {
      final question = faq['q']!.toLowerCase();
      final answer = faq['a']!.toLowerCase();
      return question.contains(q) || answer.contains(q);
    }).toList();

    if (exactMatches.isNotEmpty) return exactMatches.take(3).toList();

    // Keyword match — split query into words
    final keywords = q.split(' ').where((w) => w.length > 2).toList();
    final keywordMatches = all.where((faq) {
      final question = faq['q']!.toLowerCase();
      return keywords.any((kw) => question.contains(kw));
    }).toList();

    if (keywordMatches.isNotEmpty) return keywordMatches.take(3).toList();

    // Category keyword check
    for (final category in _faqData.keys) {
      if (q.contains(category)) {
        return _faqData[category]!.take(3).toList();
      }
    }

    return [
      {
        'q': 'Koi jawab nahi mila',
        'a': '😔 Is sawaal ka jawab abhi available nahi hai. Emergency mein:\n📞 NDMA: 1078 | Ambulance: 108 | Police: 100',
      }
    ];
  }

  // Suggested questions for initial chatbot view
  static List<String> getSuggestions() {
    return [
      'Flood mein kya karein?',
      'Emergency number kya hai?',
      'Assembly point kahan hai?',
      'Earthquake mein Drop Cover Hold?',
      'Drill kab hai?',
      'QR code kaise scan karein?',
    ];
  }

  // Get all category names
  static List<String> getCategories() {
    return _faqData.keys.toList();
  }
}
