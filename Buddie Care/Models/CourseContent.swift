import Foundation

// MARK: - All course content for Buddy Care Training Institute
// Content reviewed against: Calibris competentieprofiel Verzorgende IG,
// KNGF valpreventierichtlijn, KNMP medicatieveiligheid, AVG toepassing in zorg.

enum CourseContent {

    // MARK: - Helpers

    static func q(_ question: String, _ options: [String], correct: Int, _ explanation: String) -> QuizQuestionData {
        QuizQuestionData(id: UUID(), question: question, options: options, correctIndex: correct, explanation: explanation)
    }

    static func section(_ heading: String, symbol: String, _ body: String) -> ReadingSection {
        ReadingSection(id: UUID(), heading: heading, body: body, symbol: symbol)
    }

    static func video(_ title: String, symbol: String, duration: Int, _ description: String) -> CourseModuleData {
        CourseModuleData(id: UUID(), title: title, type: .video, durationMinutes: duration,
                         illustrationSymbol: symbol, videoDescription: description)
    }

    static func reading(_ title: String, symbol: String, duration: Int, _ sections: [ReadingSection]) -> CourseModuleData {
        CourseModuleData(id: UUID(), title: title, type: .reading, durationMinutes: duration,
                         illustrationSymbol: symbol, readingSections: sections)
    }

    static func quiz(_ title: String, symbol: String, _ questions: [QuizQuestionData]) -> CourseModuleData {
        CourseModuleData(id: UUID(), title: title, type: .quiz, durationMinutes: 15,
                         illustrationSymbol: symbol, quizQuestions: questions)
    }

    // MARK: - Niveau 0: Basis Buddy — Welkom

    static let course_basisWelkom: Course = Course(
        id: UUID(), level: .zero,
        title: "Basis Buddy — Welkom",
        durationMinutes: 35,
        progressPercent: 100,
        unlocked: true,
        summary: "Kennismaken met Buddy Care, de spelregels, communicatie met ouderen en wat er van je verwacht wordt.",
        modules: [
            video("Welkom bij Buddy Care", symbol: "heart.text.square.fill", duration: 8, """
In deze introductievideo maak je kennis met de missie van Buddy Care: studenten koppelen aan ouderen voor lichte, waardevolle zorg. Je ziet hoe een bezoek er van begin tot eind uitziet — van het accepteren van een taak op de kaart tot het schrijven van een afsluitende notitie. Je maakt ook kennis met het Level-systeem en hoe je kunt doorgroeien.
"""),
            reading("Communicatie met ouderen", symbol: "message.fill", duration: 15, [
                section("Helder en rustig spreken", symbol: "waveform", """
Spreek duidelijk, niet te snel en zonder onnodige jargon. Kijk de oudere aan terwijl u spreekt en zorg voor oogcontact op gelijke hoogte — ga zitten als de oudere zit. Geef na elke zin even de tijd om te reageren; haast doet de communicatie geen goed.

Gebruik korte zinnen en concrete woorden. Zeg 'kopje koffie' in plaats van 'een drankje', en 'uw medicijnen om 8 uur' in plaats van 'de ochtendmedicatie'. Bevestig dat u begrepen heeft door kort samen te vatten wat er gezegd werd.
"""),
                section("Actief luisteren", symbol: "ear.fill", """
Actief luisteren is meer dan alleen horen. Knik af en toe, stel een vervolgvraag ('En hoe ging dat daarna?') en laat stiltes toe. Veel ouderen hebben behoefte aan iemand die echt luistert — dat is soms het meest waardevolle wat u kunt brengen.

Onderbreek nooit midden in een zin, ook niet als u het antwoord al weet. De oudere mag zijn of haar gedachte afmaken. Oordeel niet; u bent er om te ondersteunen, niet om te corrigeren.
"""),
                section("Grenzen en professionele afstand", symbol: "hand.raised.fill", """
Als buddy bent u geen familielid, maar ook geen onbekende. Houd een warme maar professionele houding aan. Deel niet uw eigen problemen of persoonlijke situaties — het bezoek draait om de oudere.

Vraag altijd toestemming voor lichamelijk contact, ook voor iets kleins als een hand vasthouden. Sommige ouderen waarderen dat heel erg, anderen hebben liever afstand. Respecteer dit zonder uitleg te vragen.
"""),
                section("Na elk bezoek: de notitie", symbol: "doc.text.fill", """
Schrijf na elk bezoek een korte notitie in de app. Wees objectief: noteer feiten, geen oordelen. 'Mevrouw was verdrietig en noemde haar zus' is een goede notitie. 'Mevrouw deed raar' is dat niet.

Bijzonderheden — zoals een val, ongewone verwardheid, of zorgen van de oudere — meldt u direct, niet pas na het bezoek. Familie en eventuele zorgverleners kunnen meelezen en zijn afhankelijk van uw observaties.
""")
            ]),
            quiz("Eindtoets — Basis Buddy", symbol: "checkmark.seal.fill", [
                q("Wat is de minimale leeftijd om buddy te worden bij Buddy Care?",
                  ["16 jaar", "18 jaar", "21 jaar", "Geen minimum"], correct: 1,
                  "Buddy Care werkt met meerderjarige zorgverleners. De minimumleeftijd is 18 jaar, conform het arbeidsrecht en de vereisten van de VOG."),
                q("Welk document is verplicht voor elke buddy vóór de eerste taak?",
                  ["Rijbewijs", "VOG (Verklaring Omtrent Gedrag)", "BIG-registratie", "Zorgdiploma"], correct: 1,
                  "De VOG is verplicht voor alle buddies. Dit is een screening door Justis (Ministerie van Justitie) om te controleren of er geen relevante strafblad-aantekeningen zijn."),
                q("Je merkt dat een oudere jou niet herkent en verward raakt. Wat doe je?",
                  ["Jezelf nadrukkelijk voorstellen en corrigeren", "Kalm blijven, je naam noemen en rustig aanwezig zijn", "Weggaan en later terugkomen", "Direct 112 bellen"], correct: 1,
                  "Verwardheid is bij dementie geen keuze. Blijf rustig, spreek zacht en bevestig je aanwezigheid zonder te corrigeren. Schakel alleen hulp in als er gevaar is."),
                q("Hoe lang is een VOG bij Buddy Care geldig?",
                  ["1 jaar", "2 jaar", "3 jaar", "5 jaar"], correct: 2,
                  "Bij Buddy Care is de VOG 3 jaar geldig, waarna hernieuwing verplicht is. Dit is in lijn met richtlijnen van VWS voor informele zorgverleners."),
                q("Wat doe je na elk bezoek?",
                  ["Niets, dat is niet nodig", "Een korte objectieve notitie schrijven in de app", "Een rapport sturen naar de huisarts", "Bellen met de familie om alles door te nemen"], correct: 1,
                  "De notitie in de app is de officiële overdracht. Familie en zorgcoördinatoren lezen mee. Wees objectief, feitelijk en meld bijzonderheden direct.")
            ])
        ]
    )

    // MARK: - Niveau 0: Communicatie & Empathie

    static let course_communicatie: Course = Course(
        id: UUID(), level: .zero,
        title: "Communicatie & Empathie",
        durationMinutes: 50,
        progressPercent: 0,
        unlocked: true,
        summary: "Hoe communiceer je met ouderen, ook met dementie? Actief luisteren, non-verbale signalen en omgaan met emotie.",
        modules: [
            reading("Wat is dementie?", symbol: "brain.head.profile", duration: 14, [
                section("Dementie: meer dan vergeten", symbol: "brain.head.profile", """
Dementie is een verzamelnaam voor hersenaandoeningen waarbij cognitieve functies langzaam achteruitgaan. De meest voorkomende vorm is de ziekte van Alzheimer (60-70%), gevolgd door vasculaire dementie en Lewy body dementie. Dementie is geen normaal onderdeel van het ouder worden.

Naast geheugenverlies kunnen mensen moeite krijgen met plannen, communiceren, oriëntatie in tijd en ruimte, en het herkennen van vertrouwde personen en voorwerpen. In een later stadium kan ook de persoonlijkheid en het gedrag veranderen.
"""),
                section("Hoe dit jouw bezoek beïnvloedt", symbol: "person.2.fill", """
Verwardheid, herhaalde vragen en onrust zijn geen opzet — het is een gevolg van de aandoening. Corrigeer nooit wanneer iemand een naam verwisselt of iets vergeet. Ga mee in de belevingswereld van de persoon, zolang dat veilig is.

Spreek in korte, duidelijke zinnen. Gebruik namen in plaats van 'u weet wel'. Geef keuzes bij voorkeur als 'dit of dat', nooit als een open vraag. Een dementerende die keuze-stress ervaart, raakt sneller verward of angstig.
"""),
                section("Aanraking en zintuiglijke prikkels", symbol: "hand.point.up.left.fill", """
Ouderen met dementie zijn vaak gevoeliger voor prikkels: lawaai, drukte en snelle bewegingen kunnen onrust veroorzaken. Zorg voor een rustige omgeving. Zet achtergrondgeluid zachter en vermijd plotselinge bewegingen.

Aanraking kan geruststellend werken, maar vraag altijd stilzwijgend toestemming door uw hand zichtbaar aan te bieden. Een hand vasthouden of een lichte aanraking op de onderarm zegt soms meer dan woorden. Respecteer als iemand terugtrekt.
"""),
                section("Wanneer actie ondernemen", symbol: "exclamationmark.triangle.fill", """
Raak niet in paniek bij verwardheid of milde agressie — dit hoort bij het ziektebeeld. Maar er zijn situaties waarbij je direct actie onderneemt: de persoon wil de woning verlaten en raakt in paniek, er is gevaarlijk gedrag, of angst escaleert.

Blijf kalm, ga niet mee in de paniek, en schakel de familie in via de app. Gebruik de SOS-knop alleen als er direct gevaar is voor de veiligheid van de persoon. Verlaat nooit een verwarde oudere zonder eerst voor veilige overdracht te zorgen.
""")
            ]),
            reading("Non-verbale communicatie", symbol: "figure.stand", duration: 12, [
                section("Wat zegt je lichaam?", symbol: "figure.stand", """
Meer dan 70% van communicatie is non-verbaal: houding, oogcontact, gezichtsuitdrukking, afstand en toon van de stem doen meer dan de woorden zelf. Voor ouderen met afnemend gehoor of taalbegrip is dit extra belangrijk.

Zorg voor een open houding: armen niet over elkaar, lichaam naar de persoon gericht. Ga op gelijke hoogte zitten of staan. Een neerwaartse blik — u staat, de oudere zit — creëert onbewust een gevoel van ongelijkwaardigheid.
"""),
                section("Toon en spreektempo", symbol: "waveform.path.ecg", """
Spreek met een warme, rustige toon. Vermijd een hoge, kinderachtige toon — dat komt neerbuigend over en wordt door veel ouderen als respectloos ervaren. Spreek ook niet overdreven luid, tenzij de persoon echt slechthorend is.

Pauzes zijn waardevol. Geef de oudere de tijd om te reageren; gemiddeld hebben ouderen 5-7 seconden nodig om een antwoord te formuleren. Vul die stilte niet meteen in — wacht geduldig.
"""),
                section("Emoties herkennen en benoemen", symbol: "heart.fill", """
Als iemand verdrietig is maar 'het gaat goed' zegt, geloof dan wat je ziet, niet alleen wat je hoort. Benoem wat je waarneemt op een zachte manier: 'U lijkt een beetje verdrietig vandaag. Wilt u erover praten?'

Dwing nooit een gesprek over emoties af. Soms is het genoeg om stil aanwezig te zijn. Zet een kopje thee, ga naast de persoon zitten en wacht. Aanwezigheid op zich heeft al een therapeutische waarde bij eenzame ouderen.
""")
            ]),
            video("Oefengesprek: koffie met Riet", symbol: "cup.and.saucer.fill", duration: 10, """
In deze video zie je een realistisch oefengesprek tussen een buddy en Riet (78 jaar, lichte dementie). Je ziet hoe de buddy binnenkwam, hoe hij omging met een herhaalde vraag, hoe hij afscheid nam en de notitie invulde. Let op de lichaamshouding, het oogcontact en de manier van praten.
"""),
            quiz("Eindtoets — Communicatie & Empathie", symbol: "person.2.circle.fill", [
                q("Wat is een kenmerk van de ziekte van Alzheimer?",
                  ["Bewust liegen over herinneringen", "Geheugenverlies en toenemende verwardheid", "Alleen slecht humeur op bepaalde dagen", "Moeite met lopen maar helder denken"], correct: 1,
                  "Alzheimer kenmerkt zich door progressief geheugenverlies en cognitieve achteruitgang. Het is geen keuze of gedragsprobleem maar een hersenaandoening."),
                q("Een oudere met dementie vraagt voor de vierde keer hoe laat het is. Wat doe je?",
                  ["Zeggen 'dat heb ik al meerdere keren verteld'", "Rustig en vriendelijk antwoorden alsof het de eerste keer is", "De vraag negeren", "Vragen waarom ze het steeds vergeten"], correct: 1,
                  "Herhaalde vragen zijn een symptoom, geen keuze. Elke keer rustig antwoorden is de juiste aanpak. Correctie of irritatie vergroot de onrust."),
                q("Waarom is het belangrijk om op gelijke hoogte te zitten bij een oudere in een rolstoel?",
                  ["Het is een hygiëneprotocol", "Het is wettelijk verplicht", "Het geeft een gevoel van gelijkwaardigheid en verbetert het contact", "Om beter te verstaan wat er gezegd wordt"], correct: 2,
                  "Hoogteverschil in communicatie geeft onbewust een gevoel van ongelijkheid. Op gelijke hoogte zitten of knielen versterkt vertrouwen en contact."),
                q("Wat is GEEN voorbeeld van non-verbale communicatie?",
                  ["Oogcontact maken", "Je lichaamshouding", "De woorden die je kiest", "De toon van je stem"], correct: 2,
                  "Non-verbale communicatie omvat alles behalve de letterlijke woorden: houding, oogcontact, toon, gezichtsuitdrukking en afstand."),
                q("Een oudere is stilletjes verdrietig maar zegt 'alles is prima'. Wat doe je?",
                  ["Haar op haar woord geloven en doorgaan", "Zachtjes benoemen wat je ziet en ruimte geven om te praten", "Direct de familie bellen", "Onderwerp veranderen om haar af te leiden"], correct: 1,
                  "Wat iemand zegt en voelt is niet altijd hetzelfde. Zacht benoemen wat je ziet ('U lijkt een beetje stil vandaag') opent de deur zonder te forceren.")
            ])
        ]
    )

    // MARK: - Niveau 0: Veiligheid thuis

    static let course_veiligheid: Course = Course(
        id: UUID(), level: .zero,
        title: "Veiligheid thuis",
        durationMinutes: 45,
        progressPercent: 0,
        unlocked: true,
        summary: "Valrisico's herkennen, omgaan met noodsituaties en hoe je een veilige thuisomgeving signaleert en rapporteert.",
        modules: [
            reading("Valrisico's herkennen", symbol: "figure.walk.motion", duration: 14, [
                section("Waarom vallen ouderen vaker?", symbol: "figure.walk.motion", """
Vallen is de meest voorkomende oorzaak van letsel bij ouderen in Nederland. Jaarlijks vallen ruim 1,5 miljoen 65-plussers, waarvan 100.000 naar de spoedeisende hulp gaan. Oorzaken zijn divers: verminderd evenwicht, spierzwakte, verminderd zicht, bijwerkingen van medicatie en omgevingsfactoren.

Als buddy let je actief op valrisico's. Je bent geen ergotherapeut of fysiotherapeut, maar je kunt signaleren en melden. Dat is al heel veel waard.
"""),
                section("Omgevingsrisico's", symbol: "house.fill", """
De badkamer is de gevaarlijkste ruimte: glad op natte vloer, onhandige instap bad/douche, en weinig houvast. Daarna volgen de trap, de drempel bij de voordeur en losse kleedjes in de gang of woonkamer.

Let bij elk bezoek op: losse snoeren op de vloer, slecht verlichte doorgangen, schoenen of tassen op de trap, en matten zonder antislip onderkant. Je mag kleine obstakels verplaatsen als dat veilig is, maar meld het altijd in je notitie.
"""),
                section("Signalen bij de persoon", symbol: "person.fill.questionmark", """
Naast de omgeving let je ook op signalen bij de persoon zelf: loopt de oudere onvaster dan normaal? Klaagt hij of zij over duizeligheid? Zijn er blauwe plekken die er de vorige keer niet waren?

Dit zijn signalen die je objectief noteert en aan de familie doorgeeft. Je diagnosticeert niets — je observeert en meldt. Zeg nooit 'ik denk dat...' in je notitie, maar schrijf wat je letterlijk zag of hoorde.
"""),
                section("De badkamer: praktische check", symbol: "shower.fill", """
Bij het eerste bezoek doe je een snelle mentale 'badkamercheck': is er een beugel bij de douche of het bad? Is er een antislipmat? Kan de deur van buitenaf geopend worden in geval van nood?

Ontbreekt er iets essentieels, dan meld je dit aan de familie. Je installeert niets zelf — dat is de verantwoordelijkheid van de woningbeheerder of mantelzorger. Jouw rol is signaleren, niet verbouwen.
""")
            ]),
            reading("Omgaan met een noodsituatie", symbol: "cross.case.fill", duration: 14, [
                section("De oudere is gevallen", symbol: "figure.fall", """
Als je aankomt en de oudere ligt op de grond, volg dan deze stappen: controleer eerst of hij/zij bij bewustzijn is (spreek aan, tik zachtjes op de schouder). Als er geen reactie is: bel direct 112.

Als de persoon bij bewustzijn is: stel gerust, vraag of er pijn is en waar, en til NOOIT iemand op als je niet zeker weet of er iets gebroken is. Bel de familie via de app, leg een jas of deken over de persoon en blijf aanwezig totdat professionele hulp er is.
"""),
                section("Wat te doen als iemand onwel wordt", symbol: "waveform.path.ecg.rectangle", """
Tekenen dat iemand onwel wordt: plotseling bleek worden, zweten, duizeligheid, pijn op de borst, moeite met praten of één kant van het gezicht hangt scheef. Dit zijn urgente signalen.

Bij twijfel: bel 112. Je bent geen arts, en het is altijd beter om een ambulance te laten komen die niet nodig was, dan te wachten. Bel daarna ook de familie via de app zodat zij op de hoogte zijn.
"""),
                section("Psychologische noodsituaties", symbol: "exclamationmark.bubble.fill", """
Soms is een 'noodsituatie' niet lichamelijk. Een oudere die plotseling erg verward is, wil vertrekken en weet niet meer waar hij/zij woont, of ernstig angstig of agressief is — dit vraagt ook actie.

Bel dan eerst de familie. Verlaat de persoon niet. Probeer de omgeving rustig te houden en ga niet in discussie. Als de situatie gevaarlijk wordt voor jezelf of de oudere: bel 112 en geef aan dat het om een verward persoon gaat.
"""),
                section("Na een incident: de rapportage", symbol: "doc.badge.plus", """
Na elk incident — hoe klein ook — schrijf je een uitgebreide notitie. Noteer: tijd, wat je aantrof, wat je deed, wie je belde en wat er daarna gebeurde. Wees objectief en volledig.

Deze notitie is de officiële overdracht naar familie en eventuele zorgprofessionals. In geval van een klacht of onderzoek is dit ook de enige schriftelijke verslaglegging die bestaat.
""")
            ]),
            quiz("Eindtoets — Veiligheid thuis", symbol: "cross.case.fill", [
                q("Wat is de gevaarlijkste ruimte voor vallen bij ouderen?",
                  ["Slaapkamer", "Woonkamer", "Badkamer", "Keuken"], correct: 2,
                  "De badkamer heeft de hoogste valrisico's door natte gladde vloeren, de instap bij bad/douche en gebrek aan houvast. Een antislipmat en beugels zijn essentieel."),
                q("Je komt aan en de oudere ligt op de grond maar is bij bewustzijn. Wat is je eerste actie?",
                  ["Meteen optillen zodat hij/zij niet afkoelt", "Controleren op bewustzijn, geruststellen, familie bellen via de app", "Weggaan om een buur te halen", "Zelf inschatten of er iets gebroken is en dan tillen"], correct: 1,
                  "Til nooit iemand op als je niet weet of er iets gebroken is — dat kan ernstige schade veroorzaken. Geruststellen, familie bellen en ter plaatse blijven totdat hulp er is."),
                q("Je ziet dat de oudere plotseling scheef praat en één kant van het gezicht hangt. Wat doe je?",
                  ["Afwachten of het over gaat", "Een glas water geven", "Direct 112 bellen — dit zijn tekenen van een beroerte", "De familie bellen en vragen wat je moet doen"], correct: 2,
                  "Dit zijn klassieke tekenen van een beroerte (CVA). Elke minuut telt. Bel direct 112 — daarna pas de familie informeren."),
                q("Je ziet een losse mat in de gang. Wat doe je?",
                  ["Niets — het is niet jouw verantwoordelijkheid", "De mat weggooien", "De mat verplaatsen als dat veilig is en het melden in de notitie", "Alleen melden als er al gevallen is"], correct: 2,
                  "Kleine obstakels verwijderen en melden is precies wat van een buddy verwacht wordt. Grotere aanpassingen meld je aan de familie zodat de juiste persoon actie kan ondernemen."),
                q("Hoe schrijf je een goede incidentnotitie?",
                  ["'Mevrouw deed raar, ik vond het eng'", "'Mevrouw was om 14:15 verward, liep naar de voordeur, ik heb haar begeleid terug naar de stoel en de familie gebeld'", "'Alles prima, klein akkefietje opgelost'", "'Denk dat mevrouw misschien dementie heeft'"], correct: 1,
                  "Een goede notitie is objectief, feitelijk en tijdgebonden. Geen oordelen, geen diagnoses — alleen wat je zag, hoorde en deed.")
            ])
        ]
    )

    // MARK: - Niveau 0: Privacy & AVG in de zorg

    static let course_privacy: Course = Course(
        id: UUID(), level: .zero,
        title: "Privacy & AVG in de zorg",
        durationMinutes: 30,
        progressPercent: 0,
        unlocked: true,
        summary: "Wat mag je weten, delen en bewaren? Geheimhouding, digitale privacy en jouw verantwoordelijkheden als buddy.",
        modules: [
            reading("Persoonsgegevens en geheimhouding", symbol: "lock.shield.fill", duration: 14, [
                section("De AVG in de zorgsector", symbol: "lock.shield.fill", """
De Algemene Verordening Gegevensbescherming (AVG) geldt voor iedereen die persoonsgegevens verwerkt — dus ook voor jou als buddy. Medische en zorggegevens vallen onder 'bijzondere persoonsgegevens' en genieten extra bescherming.

Als buddy verwerk je automatisch gevoelige informatie: de naam en het adres van de oudere, gezondheidssituatie, medicatiegebruik en soms ook financiële situatie. Al deze informatie is strikt vertrouwelijk.
"""),
                section("Geheimhouding: wat en met wie?", symbol: "eye.slash.fill", """
Informatie over de oudere deel je alleen met wie het nodig heeft voor de directe zorgverlening: de familie die via de app gekoppeld is en Buddy Care zelf. Je deelt niets met vrienden, klasgenoten of andere buddies.

Dit geldt ook voor mondelinge informatie: vertel niet aan een andere cliënt hoe het met een andere oudere gaat. Vertel het niet aan je buren. Wees ook voorzichtig in openbare ruimtes — een telefoongesprek in de tram over een cliënt is een privacyschending.
"""),
                section("Foto's en social media: verboden zonder toestemming", symbol: "camera.fill", """
Je maakt nooit foto's van de cliënt, de woning of bezittingen zonder expliciete schriftelijke toestemming. Dit geldt ook als je denkt dat het 'lief bedoeld' is, zoals een foto voor een verjaardag.

Plaats nooit iets op social media over je werk als buddy — ook niet anoniem of geanonimiseerd als er details herkenbaar zijn. Een beschrijving als 'grappige 80-jarige dame in Rotterdam-Zuid met drie katten' kan de persoon identificeerbaar maken.
"""),
                section("Digitale veiligheid", symbol: "iphone.lockscreen", """
De Buddy Care-app gebruikt versleutelde verbindingen voor alle communicatie. Gebruik de app alleen op uw eigen apparaat. Deel je inloggegevens niet met anderen — ook niet met een collega-buddy.

Stuur nooit medische informatie via WhatsApp of e-mail. Als de familie via de app communiceert, gebruik dan alleen dat kanaal. Bij een datalek of verlies van je telefoon: meld dit direct via hulp@buddiecare.nl.
""")
            ]),
            quiz("Eindtoets — Privacy & AVG", symbol: "lock.shield.fill", [
                q("Wat mag je als buddy NOOIT doen?",
                  ["Boodschappen doen namens de cliënt", "Een foto van de woning delen op social media", "Een objectieve notitie schrijven in de app", "Uitleggen wat je gaat doen voordat je begint"], correct: 1,
                  "Foto's van de woning, cliënt of bezittingen zijn strikt verboden zonder schriftelijke toestemming. Dit is een directe schending van de AVG en de vertrouwensrelatie."),
                q("Met wie mag je informatie over de cliënt delen?",
                  ["Met andere buddies zodat ze weten wat ze kunnen verwachten", "Alleen met gekoppelde familie en Buddy Care via de beveiligde app", "Met de huisarts als je je zorgen maakt", "Met je medestudenten voor een casusopdracht"], correct: 1,
                  "Informatie delen buiten de gekoppelde familie en Buddy Care is een privacyschending, ook als je goede bedoelingen hebt. Voor zorgen: meld altijd via de app."),
                q("Een familielid van een andere cliënt vraagt hoe het gaat met jouw cliënt. Wat doe je?",
                  ["Vriendelijk vertellen dat het goed gaat", "Zeggen dat je geen informatie deelt over anderen", "Doorverwijzen naar Buddy Care", "Alleen zeggen 'geen bijzonderheden'"], correct: 1,
                  "Elke informatie over een cliënt is vertrouwelijk, ook het feit dat het 'goed gaat'. Je deelt nooit iets zonder toestemming van de cliënt of Buddy Care."),
                q("Wat doe je als je telefoon verloren gaat en de Buddy Care-app erop staat?",
                  ["Afwachten of je hem terugvindt", "Niets — de app heeft een wachtwoord", "Direct melden bij Buddy Care via hulp@buddiecare.nl", "Je account verwijderen en opnieuw aanmaken"], correct: 2,
                  "Bij verlies of diefstal van een apparaat met toegang tot patiëntgegevens moet je dit direct melden. Buddy Care kan dan de toegang intrekken om misbruik te voorkomen."),
                q("Mag je in een opdracht voor je studie een casus beschrijven gebaseerd op een van je cliënten?",
                  ["Ja, als je de naam verandert", "Ja, als de casus meer dan 6 maanden geleden is", "Nee, nooit zonder schriftelijke toestemming van de cliënt", "Ja, als je docent ermee instemt"], correct: 2,
                  "Zelfs geanonimiseerde casussen zijn alleen toegestaan met expliciete toestemming. Herkenbare details (leeftijd, stad, situatie) kunnen de persoon identificeerbaar maken.")
            ])
        ]
    )

    // MARK: - Niveau 1: Steunkousen & Mobiliteit

    static let course_steunkousen: Course = Course(
        id: UUID(), level: .one,
        title: "Steunkousen & Mobiliteit",
        durationMinutes: 90,
        progressPercent: 100,
        unlocked: true,
        summary: "Veilig steunkousen aandoen en uittrekken, helpen opstaan met loophulpmiddel, en ergonomisch werken als buddy.",
        modules: [
            video("Steunkousen aandoen: stap voor stap", symbol: "figure.arms.open", duration: 12, """
In deze instructievideo zie je hoe je steunkousen correct aantrekt bij een zittende cliënt. Je ziet de juiste handgreep, hoe je voorkomt dat de kous kreukelt (valse druk), en hoe je controleert of de kous goed zit. Ook wordt uitgelegd wanneer je stopt en de zorgcoördinator informeert.
"""),
            reading("Compressietherapie begrijpen", symbol: "bandage.fill", duration: 14, [
                section("Waarom steunkousen?", symbol: "bandage.fill", """
Steunkousen worden voorgeschreven bij spataders, oedeem (vocht in de benen) of na een trombose. Ze oefenen druk uit op de bloedvaten waardoor het bloed beter terugstroomt naar het hart. Bij ouderen zijn ze zeer gangbaar.

Als buddy doe je kousen aan of uit op basis van het zorgplan. Jij besluit niet zelf of iemand kousen nodig heeft — dat heeft een arts bepaald. Jouw rol is uitvoering van de instructie.
"""),
                section("Compressieklassen: wat betekenen ze?", symbol: "chart.bar.fill", """
Steunkousen zijn er in vier klassen (1 t/m 4) op basis van de druk die ze uitoefenen. Klasse 1 (lichte compressie, 15-21 mmHg) zijn over-the-counter verkrijgbaar. Klasse 2 en hoger zijn op voorschrift en merkbaar steviger.

Als buddy doe je vrijwel altijd klasse 1 of 2 aan. Als een kous erg moeilijk aan te trekken is of als de cliënt aangeeft dat het pijn doet, stop dan en noteer dit — forceren kan huidschade veroorzaken.
"""),
                section("Wanneer stop je?", symbol: "exclamationmark.triangle.fill", """
Stop onmiddellijk en noteer het als je het volgende ziet: de huid is rood, paars of blauw bij de enkel of voet, er zijn open wonden of blaren, de huid is extreem gevoelig bij aanraking, of de cliënt geeft aan felle pijn te hebben.

Dit zijn tekenen van slechte doorbloeding of huidproblemen. De steunkous kan dan meer kwaad dan goed doen. Schakel via de notitie de familie in en vraag om contact met de behandelend arts.
""")
            ]),
            reading("Helpen opstaan met loophulpmiddel", symbol: "figure.walk", duration: 16, [
                section("Soorten loophulpmiddelen", symbol: "figure.walk", """
Ouderen gebruiken loophulpmiddelen als rollators, wandelstokken, krukken of looprekken. Elk hulpmiddel heeft een andere techniek voor het begeleiden. Informeer jezelf bij het eerste bezoek: welk hulpmiddel gebruikt deze persoon, en hoe?

Pas nooit het hulpmiddel aan zonder toestemming van de ergotherapeut of fysiotherapeut. De instellingen (hoogte, rem) zijn afgestemd op de specifieke cliënt.
"""),
                section("Opstaan uit een stoel: de juiste techniek", symbol: "chair.lounge.fill", """
De veiligste manier om iemand te helpen opstaan: laat de cliënt naar voren schuiven op de stoel, voeten plat op de grond, licht breder dan heupen. Vraag hem/haar om naar voren te leunen ('neus boven de knieën') en dan samen op te staan.

Ondersteun aan de romp of onder de oksels — nooit trekken aan de armen. Sta zelf op de zwakkere kant van de cliënt zodat u als steun kunt dienen. Geef de rollator of wandelstok pas na het opstaan.
"""),
                section("Lopen begeleiden: naast, niet voor", symbol: "person.2.fill", """
Loop altijd naast of iets achter de cliënt — nooit voor. Zo kunt u ingrijpen als iemand struikelt zonder de loopmogelijkheid te blokkeren. Leg uw hand lichtjes op de rug of onderarm als de persoon onzeker loopt.

Pas het looptempo aan aan de cliënt. Haast nooit — ook niet als u weinig tijd heeft. Een valincident kost veel meer tijd en leed dan een langzame wandeling.
"""),
                section("Ergonomie voor de buddy", symbol: "figure.strengthtraining.traditional", """
Uw eigen lichaam is uw werkinstrument. Zorg voor een brede, stabiele stand (voeten op schouderbreedte). Buig vanuit de knieën, niet vanuit de rug. Houd het gewicht dicht bij uw lichaam.

Als een cliënt te zwaar is voor één persoon om veilig te helpen, schakel dan hulp in. Nooit forceren — rugklachten zijn de meest voorkomende beroepsziekte in de zorg. Meld in de app als u denkt dat professioneel tiltechniek of een tilhulpmiddel nodig is.
""")
            ]),
            quiz("Eindtoets — Steunkousen & Mobiliteit", symbol: "figure.walk.circle.fill", [
                q("Wanneer trek je steunkousen aan bij een cliënt?",
                  ["Aan het einde van de dag als de benen moe zijn", "'s Ochtends voor of kort na het opstaan, als de benen nog niet gezwollen zijn", "Alleen als de cliënt er zelf om vraagt", "Na het wandelen, zodat de circulatie al op gang is"], correct: 1,
                  "Steunkousen werken het beste als ze aangetrokken worden voordat de benen overdag opzwellen — dus 's ochtends vroeg, bij voorkeur terwijl de cliënt nog ligt of net is opgestaan."),
                q("Je ziet dat de huid van de enkel paars-blauw verkleurd is. Wat doe je?",
                  ["De kous toch aandoen, paarse huid hoort erbij", "Stoppen, de situatie noteren en de familie informeren", "Een warme handdoek op de enkel leggen", "Harder masseren zodat de circulatie op gang komt"], correct: 1,
                  "Verkleuring is een alarmsignaal voor slechte doorbloeding of bestaande huidschade. Een steunkous zou de situatie ernstig kunnen verergeren. Altijd stoppen en rapporteren."),
                q("Hoe help je iemand veilig opstaan uit een stoel?",
                  ["Aan de armen trekken zodat het snel gaat", "Van achteren onder de oksels optillen", "Cliënt naar voren laten schuiven, voeten plat, samen omhoog komen", "Cliënt zelf laten opstaan en alleen klaarstaan"], correct: 2,
                  "De juiste techniek is: naar voren schuiven, voeten plat en breed, neus boven de knieën, dan samen omhoog. Trekken aan armen of van achteren tillen vergroot het valrisico en kan letsel veroorzaken."),
                q("Aan welke kant ga je staan bij het begeleiden van een cliënt die links zwakker is?",
                  ["Rechts, zodat je een overzicht heeft", "Links — de zwakkere kant — zodat je als steun kunt dienen", "Afwisselend links en rechts", "Achter de cliënt"], correct: 1,
                  "Je staat aan de zwakkere kant omdat die kant meer ondersteuning nodig heeft. Als de cliënt naar die kant wegzakt, kun jij direct ingrijpen."),
                q("Wat doe je als een cliënt te zwaar is om veilig te helpen?",
                  ["Toch proberen — de cliënt moet niet wachten", "Vragen of een buurman kan helpen", "Stoppen, dit melden in de app en professionele hulp of tilhulpmiddelen inschakelen", "Alleen de onderste helft van het lichaam optillen"], correct: 2,
                  "Veiligheid voor jezelf én de cliënt staat altijd voorop. Forceren leidt tot rugklachten en valincidenten. Meld dat professionele hulp nodig is — dit is geen falen maar verantwoordelijk handelen.")
            ])
        ]
    )

    // MARK: - Niveau 1: Maaltijdvoorbereiding voor ouderen

    static let course_maaltijden: Course = Course(
        id: UUID(), level: .one,
        title: "Maaltijdvoorbereiding voor ouderen",
        durationMinutes: 50,
        progressPercent: 60,
        unlocked: true,
        summary: "Veilig opwarmen en serveren, allergieën herkennen, slikproblemen signaleren en dieetwensen respecteren.",
        modules: [
            reading("Voeding en veroudering", symbol: "fork.knife", duration: 14, [
                section("Veranderende voedingsbehoeften", symbol: "fork.knife", """
Bij veroudering verandert de stofwisseling. Ouderen hebben minder calorieën nodig, maar juist meer eiwitten en micronutriënten (vitamines, mineralen). Ondervoeding — te weinig eiwitten en vitamines — is een serieus probleem bij 20-30% van de thuiswonende ouderen.

Signalen van ondervoeding: zichtbaar gewichtsverlies, broze nagels en haar, moeheid, slechte wondgenezing. Noteer het als u dit ziet — de huisarts of diëtist kan dan handelen.
"""),
                section("Eetlust stimuleren", symbol: "star.fill", """
Veel ouderen eten minder omdat eten minder lekker smaakt (minder smaakpapillen), ze minder honger voelen, of omdat eten een eenzame activiteit is geworden. Samen eten doet wonderen: zet ook voor uzelf een kop thee en ga gezellig aan tafel.

Presentatie telt: een bord dat er aantrekkelijk uitziet wordt beter gegeten. Kleine porties die aangevuld kunnen worden werken beter dan een overvolle borden die overweldigend aanvoelen.
"""),
                section("Bijzondere voedingsbehoeften", symbol: "allergens", """
Veel ouderen hebben een dieet: zoutarm (bij hartfalen of hoge bloeddruk), suikerarm (diabetes), glutenvrij (coeliakie), of een aangepaste consistentie (bij slikproblemen). Deze informatie staat in het zorgplan of de notities van de cliënt in de app.

Controleer altijd voor het bereiden. Bij twijfel: bel de familie. Geef nooit iets wat niet op het dieetplan staat, ook niet als de cliënt zelf erom vraagt ('een klein koekje kan toch geen kwaad?'). Het risico is soms groter dan het lijkt.
""")
            ]),
            reading("Veilig opwarmen en serveren", symbol: "thermometer.medium", duration: 14, [
                section("Kerntemperatuur en voedselveiligheid", symbol: "thermometer.medium", """
Opgewarmd voedsel moet een kerntemperatuur van minimaal 70°C bereiken om bacteriën te doden. Dit is de HACCP-richtlijn die ook in thuiszorg geldt. Meet de temperatuur in het midden van het gerecht — de rand is altijd heter.

Gebruik bij voorkeur een voedseltermometer. Roer tussendoor om ongelijke verhitting te voorkomen. Microwave-verwarming is toegestaan maar vraagt extra aandacht voor koude plekken ('hotspots and cold spots').
"""),
                section("Serveren bij bewegingsbeperking", symbol: "figure.seated.seatbelt", """
Ouderen met tremor (beving) of verminderde handkracht hebben speciale aandacht nodig. Gebruik bekers met deksel voor warme dranken, borden met antislip-onderkant, en bestek met dikke handvatten als dat beschikbaar is.

Serveer warme dranken niet gloeiend heet — laat ze iets afkoelen. Zet alles binnen handbereik zodat de cliënt niet hoeft te reiken of opstaan voor een tweede portie.
"""),
                section("Koken versus opwarmen", symbol: "flame.fill", """
Als buddy mag je eenvoudige maaltijden bereiden of opwarmen. Kook nooit iets ingewikkelds als je niet precies weet hoe — een simpele soep of omelet is altijd veiliger dan een experiment. Vraag bij het eerste bezoek naar de favoriete maaltijden en hoe die worden bereid.

Controleer altijd de houdbaarheidsdatum van producten. Gooi niets weg zonder overleg met de familie, maar meld verlopen producten in de notitie.
""")
            ]),
            video("Herkennen van slikproblemen", symbol: "drop.fill", duration: 10, """
In deze instructievideo leer je de tekenen van dysfagie (slikproblemen) herkennen: verslikken tijdens eten of drinken, een natte/gorgelende stem na het eten, hoesten tijdens of na maaltijden, en voedsel dat in de wang wordt gehouden. Je ziet ook hoe je veilig kunt aanpassen (kleine hapjes, dikkere vloeistoffen) en wanneer je direct moet melden.
"""),
            quiz("Eindtoets — Maaltijdvoorbereiding", symbol: "fork.knife.circle.fill", [
                q("Op welke minimale kerntemperatuur moet opgewarmd voedsel zijn?",
                  ["55°C", "60°C", "70°C", "80°C"], correct: 2,
                  "De HACCP-richtlijn schrijft 70°C voor als minimale kerntemperatuur voor opgewarmd voedsel. Dit is de temperatuur waarbij de meeste pathogene bacteriën worden gedood."),
                q("Een cliënt met een zoutarm dieet vraagt om extra zout op zijn eten. Wat doe je?",
                  ["Een beetje zout is niet erg, dat kan hij zelf beoordelen", "Het dieet respecteren en vriendelijk uitleggen waarom je geen zout toevoegt", "De familie bellen voor toestemming", "Een klein beetje zout toevoegen maar het niet melden"], correct: 1,
                  "Het dieet is medisch voorgeschreven. Jij voegt geen zout toe, ook niet op verzoek van de cliënt. Leg het vriendelijk uit en noteer het verzoek zodat de familie of behandelaar ervan weet."),
                q("Welk teken kan wijzen op een slikstoornis (dysfagie)?",
                  ["De cliënt eet langzaam", "De cliënt heeft geen trek", "Herhaaldelijk verslikken en een gorgelende stem na het drinken", "De cliënt eet liever kleine porties"], correct: 2,
                  "Verslikken, hoesten bij het eten en een natte stem na het drinken zijn klassieke signalen van dysfagie. Dit moet direct gemeld worden — aspiratie (voedsel in de longen) kan levensgevaarlijk zijn."),
                q("Hoe serveer je warme thee veilig aan een cliënt met tremor?",
                  ["In een normale kop, zo snel mogelijk serveren zodat hij nog warm is", "In een beker met deksel of anti-slip onderzetter, iets afgekoeld", "In een glas zodat de cliënt de hoeveelheid kan zien", "Op het aanrecht laten staan zodat de cliënt het zelf pakt"], correct: 1,
                  "Een beker met deksel voorkomt morsen bij tremor. Iets afkoelen verlaagt het brandrisico. Zet de beker binnen handbereik zodat de cliënt niet hoeft te reiken."),
                q("Je ziet verlopen melk in de koelkast. Wat doe je?",
                  ["Weggooien — dat is de veiligste oplossing", "Laten staan en niets zeggen", "Melden in de notitie zodat de familie actie kan ondernemen", "Aan de cliënt vragen of hij het nog wil gebruiken"], correct: 2,
                  "Je gooit niets weg zonder overleg — dat kan een discussie opleveren. Meld verlopen producten in de notitie: de familie of mantelzorger neemt dan de juiste actie.")
            ])
        ]
    )

    // MARK: - Niveau 1: Valpreventie & Ergonomisch werken

    static let course_valpreventie: Course = Course(
        id: UUID(), level: .one,
        title: "Valpreventie & Ergonomisch werken",
        durationMinutes: 55,
        progressPercent: 0,
        unlocked: true,
        summary: "Valrisico's systematisch in kaart brengen, de thuisomgeving aanpassen en zelf ergonomisch werken zonder rugklachten.",
        modules: [
            reading("Waardoor vallen ouderen?", symbol: "figure.fall", duration: 14, [
                section("Intrinsieke risicofactoren", symbol: "figure.fall", """
Intrinsieke factoren zijn risico's die in de persoon zelf zitten: verminderd evenwicht en spierkracht, slecht zicht, bijwerkingen van medicatie (duizeligheid, sufheid), lage bloeddruk bij het opstaan (orthostatische hypotensie) en cognitieve achteruitgang.

Orthostatische hypotensie is een veelvoorkomende maar ondergewaardeerde oorzaak. Iemand staat snel op en wordt plotseling duizelig. Als je dit ziet, meld het dan — een arts kan de medicatie aanpassen.
"""),
                section("Extrinsieke risicofactoren", symbol: "house.fill", """
Extrinsieke factoren zijn omgevingsrisico's: losse kleedjes, slechte verlichting, gladde vloeren, obstakels in de looproute, trapleuningen die ontbreken of onvast zitten, en te lage stoelen of toiletten.

Maak bij elk bezoek een snelle mentale 'rondgang'. Je hoeft geen lijst bij te houden, maar let actief op veranderingen ten opzichte van het vorige bezoek.
"""),
                section("Schoeisel: onderschat risico", symbol: "shoe.fill", """
Sloffen zijn de meest gevaarlijke schoenen voor ouderen: ze bieden geen steun, hebben een gladde zool en nodigen uit tot slepen in plaats van lopen. Toch dragen veel ouderen thuis bijna altijd sloffen.

Stimuleer het dragen van gesloten schoenen met een antislipzool, ook binnenshuis. Als de cliënt niet wil wisselen, meld dit dan in het dossier. Jij kunt niet dwingen, maar je kunt wel documenteren.
""")
            ]),
            reading("Ergonomisch tillen en ondersteunen", symbol: "figure.strengthtraining.traditional", duration: 16, [
                section("De basisprincipes van ergonomisch werken", symbol: "figure.strengthtraining.traditional", """
Rugklachten zijn de meest voorkomende beroepsziekte in de zorgsector. Voorkomen is beter dan genezen. De basisprincipes: werk dicht bij uw lichaam, buig vanuit uw knieën (niet uw rug), houd uw rug recht en verdeel het gewicht gelijkmatig.

Zorg voor een stabiele voetstand (voeten op schouderbreedte). Houd het gewicht dat u tilt zo dicht mogelijk bij uw lichaam. Draai niet met uw rug als u iets tilt — zet uw voeten in de gewenste richting en draai mee.
"""),
                section("Tilnormen en grenzen", symbol: "scalemass.fill", """
De arbeidsnorm voor tillen is maximaal 23 kg met twee handen, in ideale omstandigheden. Bij ongunstige omstandigheden (gebogen houding, ver van het lichaam) is de grens veel lager. Een persoon van 70 kg til je nooit alleen.

Als een taak fysiek te zwaar is voor één buddy, is dat geen falen maar een professionele inschatting. Meld het via de app en vraag om een tiltechniek-consult of een professioneel tilhulpmiddel zoals een tillift.
"""),
                section("SBAR: gestructureerd overdragen", symbol: "doc.text.fill", """
SBAR staat voor Situation, Background, Assessment, Recommendation — een communicatiestructuur voor professionele overdracht. Gebruik het als je iets meldt in de app of aan familie doorgeeft.

Voorbeeld: S — 'Mevrouw is vanavond twee keer bijna gevallen.' B — 'Ze heeft nieuwe medicatie gekregen vorige week.' A — 'Ze lijkt duizeliger dan normaal, vooral bij het opstaan.' R — 'Ik adviseer contact op te nemen met de huisarts over de medicatie.'
""")
            ]),
            quiz("Eindtoets — Valpreventie & Ergonomisch werken", symbol: "figure.walk.circle.fill", [
                q("Wat is orthostatische hypotensie?",
                  ["Een type val waarbij iemand naar achteren valt", "Een plotselinge bloeddrukdaling bij snel opstaan, die duizeligheid veroorzaakt", "Een aandoening aan de knie door overbelasting", "Hoge bloeddruk door stress"], correct: 1,
                  "Orthostatische hypotensie is een bloeddrukdaling die optreedt bij snel gaan staan. Het bloed zakt naar de benen, het hoofd krijgt even te weinig aanvoer en de persoon wordt duizelig of valt. Medicatie is een veel voorkomende oorzaak."),
                q("Welk type schoeisel verhoogt het valrisico het meest?",
                  ["Stevige wandelschoenen", "Sportschoenen", "Sloffen zonder antislip", "Slippers met een enkel-bandje"], correct: 2,
                  "Sloffen hebben een gladde zool, bieden geen enkelbescherming en nodigen uit tot slepen. Ze zijn de meest gevaarlijke keuze voor thuiswonende ouderen."),
                q("Wat is de juiste manier om een voorwerp van de grond te pakken?",
                  ["Snel bukken vanuit de rug", "Knielen met rechte rug of hurken met gestrekte rug", "Vanuit een zittende stoel reiken", "Eén been naar achteren strekken en voorover buigen"], correct: 1,
                  "Knielen of hurken met een rechte rug beschermt de wervelkolom. Bukken vanuit de rug is de meest voorkomende oorzaak van acuut rugletsel."),
                q("Wat betekent de 'A' in de SBAR-methode?",
                  ["Actie — wat je hebt gedaan", "Assessment — jouw beoordeling van de situatie", "Afspraak — de geplande vervolgstap", "Achtergrond — wie de cliënt is"], correct: 1,
                  "SBAR: Situation (wat is er), Background (context), Assessment (jouw inschatting), Recommendation (wat jij adviseert). Het is een professionele overdrachtsstructuur die ook in de ziekenhuiszorg gebruikt wordt."),
                q("Wanneer mag je een cliënt NIET alleen optillen?",
                  ["Als het vorige bezoek ook goed ging", "Als de cliënt zwaarder is dan 23 kg in ideale omstandigheden, of bij ongunstige werkomstandigheden", "Nooit — tillen doe je altijd samen", "Alleen als er een verhoogd valrisico is"], correct: 1,
                  "De tilnorm is 23 kg in ideale omstandigheden. Mensen tillen doe je nooit alleen. Bij twijfel: meld het en vraag professionele hulp of een tilhulpmiddel.")
            ])
        ]
    )

    // MARK: - Niveau 2: Medicatietoezicht

    static let course_medicatie: Course = Course(
        id: UUID(), level: .two,
        title: "Medicatietoezicht",
        durationMinutes: 120,
        progressPercent: 0,
        unlocked: false,
        summary: "Medicatieschema's lezen, toezicht houden op correcte inname, bijwerkingen herkennen en fouten veilig melden.",
        modules: [
            reading("Medicatiesoorten en toedieningsvormen", symbol: "pills.fill", duration: 18, [
                section("Soorten medicatie bij ouderen", symbol: "pills.fill", """
Ouderen gebruiken gemiddeld vijf of meer geneesmiddelen tegelijk (polyfarmacie). De meest voorkomende categorieën zijn: bloeddrukverlagende medicatie, bloedverdunners, cholesterolverlagers, antidiabetica, pijnstillers en slaapmiddelen.

Als Niveau 2 buddy geef je geen diagnoses en adviseer je geen medicatiewijzigingen. Jouw rol is: de correcte inname begeleiden op basis van het door een arts opgesteld medicatieschema.
"""),
                section("Toedieningsvormen", symbol: "cross.case.fill", """
Medicatie kan op verschillende manieren worden ingenomen: tabletten en capsules (oraal), druppels (sublinguaal of oraal), puffers (inhalatie), zalven en crèmes (cutaan), en pleisters (transdermaal). Als Niveau 2 buddy hanteer je uitsluitend orale toedieningsvormen — dus tabletten, capsules en druppels die worden ingeslikt.

Injecties, oogdruppels, oordruppels, vaginale of rectale toediening, en inhalatiemedicatie vallen buiten jouw bevoegdheid als Niveau 2 buddy. Bij twijfel over wat wel en niet is toegestaan: vraag de zorgcoördinator.
"""),
                section("Wat mag een Niveau 2 buddy NOOIT doen", symbol: "xmark.shield.fill", """
Een Niveau 2 buddy mag NOOIT: medicatie klaarzetten zonder supervisie van een BIG-geregistreerde zorgverlener, medicatie toedienen die niet op het schema staat, de dosering aanpassen ook al vraagt de cliënt erom, medicatie toedienen die injecteerbaar is, en medicatie toedienen zonder het schema te controleren.

Dit zijn voorbehouden handelingen (Wet BIG art. 36). Overtreding hiervan is niet alleen een fout binnen Buddy Care, maar mogelijk ook strafbaar.
""")
            ]),
            reading("Het medicatieschema lezen", symbol: "calendar", duration: 16, [
                section("Opbouw van een medicatieschema", symbol: "doc.text.fill", """
Een medicatieschema bevat per geneesmiddel: de naam (merknaam en/of generieke naam), de dosering (bijv. 50 mg), het tijdstip (ochtend/middag/avond/nacht), de toedieningsvorm (tablet, capsule) en eventuele instructies (met of zonder eten, heel inslikken).

Let op de kolom 'tijdstip': '1dd1' betekent één keer per dag één tablet. '2dd2' betekent twee keer per dag twee tabletten. Als je het schema niet begrijpt, vraag dan altijd om uitleg voordat je begint.
"""),
                section("Controleren voor uitreiken", symbol: "checkmark.circle.fill", """
Controleer altijd de vier 'R's voor het uitreiken van medicatie: Rechte persoon (cliënt identificeren), Rechte medicatie (juiste naam), Rechte dosering, Rechte tijd. Dit is een mondiale standaard die ook in ziekenhuizen wordt gebruikt.

Controleer ook de houdbaarheidsdatum en of de verpakking correct is. Uitreiken van verlopen medicatie is een medicatiefout en moet worden gemeld, ook als er niets ernstigs is gebeurd.
"""),
                section("Bijzondere aandachtspunten", symbol: "exclamationmark.circle.fill", """
Sommige medicijnen hebben specifieke instructies: met een vol glas water innemen, niet fijnmaken (enterisch gecoate tabletten), niet gelijktijdig met grapefruitsap, of op een lege maag. Deze informatie staat altijd bij het schema.

Als een cliënt zegt een tablet al te hebben ingenomen, geloof dat dan tenzij er duidelijke aanwijzingen zijn van het tegendeel. Dubbeltoediening van bepaalde medicijnen (bloedverdunners, hartmedicatie) kan gevaarlijk zijn.
""")
            ]),
            reading("Bijwerkingen herkennen", symbol: "waveform.path.ecg.rectangle", duration: 14, [
                section("Veelvoorkomende bijwerkingen", symbol: "waveform.path.ecg.rectangle", """
Bijwerkingen die je als buddy kunt tegenkomen: sufheid of verwardheid (slaapmiddelen, antidepressiva), duizeligheid bij opstaan (bloeddrukverlagende medicatie), misselijkheid (antibiotica, pijnstillers), blauwe plekken bij lichte stoten (bloedverdunners), droge mond (antihistaminica, antipsychotica).

De meeste bijwerkingen zijn vervelend maar niet gevaarlijk. Noteer ze objectief in de app: 'cliënt klaagt over misselijkheid na innemen van medicatie om 8:00'.
"""),
                section("Ernstige bijwerkingen: direct melden", symbol: "cross.fill", """
Sommige bijwerkingen vereisen directe actie: plotselinge benauwdheid of zwelling (allergische reactie), ernstige huiduitslag, plotseling zwak worden of flauwvallen, verwardheid die plotseling optreedt, en donkere/bloederige ontlasting (bij bloedverdunners).

Bij deze signalen: bel 112, informeer de familie en noteer alles zo gedetailleerd mogelijk. Geef aan de ambulancedienst door welke medicatie de cliënt gebruikt — het schema in de app is daarvoor beschikbaar.
""")
            ]),
            video("Medicatie klaarzetten en toezicht houden", symbol: "cross.case.fill", duration: 14, """
In deze instructievideo zie je hoe je het medicatieschema controleert, de medicatie uit de baxterrol of pillendoos haalt, de vier-R-check uitvoert, toezicht houdt bij inname en hoe je de inname documenteert in de app. Je ziet ook hoe je omgaat met een cliënt die een tablet weigert in te nemen.
"""),
            reading("Medicatiefouten voorkomen en melden", symbol: "exclamationmark.triangle.fill", duration: 12, [
                section("Wat is een medicatiefout?", symbol: "exclamationmark.triangle.fill", """
Een medicatiefout is elke afwijking van het medicatieschema: verkeerde medicatie uitreiken, verkeerde dosering, verkeerd tijdstip, of vergeten toediening. Ook een 'bijna-fout' (bijna-incident) — een fout die je op tijd opmerkte en corrigeerde — moet worden gemeld.

Melden is geen kwestie van schuld, maar van veiligheid. Het zorgsysteem kan alleen leren van fouten als ze gemeld worden. Wees eerlijk en objectief in je melding.
"""),
                section("Hoe meld je een medicatiefout?", symbol: "bell.fill", """
Meld elke (bijna-)fout direct in de app via de incidentenknop. Beschrijf: welke medicatie, welke afwijking, wat je deed en wat het gevolg was. Informeer ook de familie direct.

Bij een serieuze fout (dubbele dosis gegeven, verkeerde medicatie) bel je ook de huisarts of apotheker voor advies. Laat de cliënt niet alleen totdat duidelijk is of er gevaar is.
""")
            ]),
            quiz("Eindtoets — Medicatietoezicht", symbol: "pills.circle.fill", [
                q("Welke toedieningsvorm mag een Niveau 2 buddy NOOIT gebruiken?",
                  ["Oraal tablet", "Druppels die worden ingeslikt", "Injectie", "Capsule"], correct: 2,
                  "Injecties zijn een voorbehouden handeling (Wet BIG art. 36) en mogen alleen worden gegeven door BIG-geregistreerde zorgverleners. Voor een Niveau 2 buddy is dit strikt verboden."),
                q("Wat zijn de vier 'R's die je controleert bij medicatie uitreiken?",
                  ["Reden, Recept, Risico, Registratie", "Rechte persoon, Rechte medicatie, Rechte dosering, Rechte tijd", "Regels, Richtlijn, Registratie, Rapportage", "Rustig, Respectvol, Regelmatig, Rondom"], correct: 1,
                  "De vier R's zijn een internationale standaard: juiste persoon, juist medicijn, juiste dosering, juist tijdstip. Dit verlaagt het risico op medicatiefouten aanzienlijk."),
                q("Een cliënt zegt dat hij zijn bloeddrukpil al heeft ingenomen. Wat doe je?",
                  ["Hem toch de pil geven — hij vergeet het vast", "Hem geloven en dit noteren in de app", "De pil geven maar in twee helften", "De familie bellen voor bevestiging bij elk bezoek"], correct: 1,
                  "Vertrouw de cliënt tenzij er duidelijke aanwijzingen zijn van het tegendeel. Dubbele toediening van bloeddrukverlagende medicatie kan gevaarlijk zijn. Noteer het gesprek in de app."),
                q("Je ziet plotselinge zwelling van de lippen bij een cliënt na innemen van een nieuw medicijn. Wat doe je?",
                  ["Afwachten of het over gaat", "Een antihistaminicum geven uit de eigen voorraad", "Direct 112 bellen — dit kan een ernstige allergische reactie zijn", "De apotheek bellen om advies te vragen"], correct: 2,
                  "Zwelling van lippen of keel na medicatiegebruik is een mogelijk anafylactische reactie — medische noodsituatie. Bel direct 112 en noem alle medicatie die de cliënt heeft gebruikt."),
                q("Wanneer moet je een 'bijna-fout' melden?",
                  ["Alleen als er daadwerkelijk iets mis is gegaan", "Altijd — ook als je de fout op tijd corrigeerde", "Alleen als de cliënt er iets van heeft gemerkt", "Nooit — dat geeft onnodige onrust"], correct: 1,
                  "Bijna-fouten zijn net zo belangrijk als echte fouten. Melden helpt om patronen te herkennen en het systeem veiliger te maken. Er is geen straf voor eerlijk melden van bijna-incidenten.")
            ])
        ]
    )

    // MARK: - Niveau 2: Hulp bij wassen aan de wastafel

    static let course_wassen: Course = Course(
        id: UUID(), level: .two,
        title: "Hulp bij wassen aan de wastafel",
        durationMinutes: 90,
        progressPercent: 0,
        unlocked: false,
        summary: "Privacy en waardigheid tijdens persoonlijke verzorging, juiste techniek bij de wastafel, huidverzorging bij ouderen.",
        modules: [
            reading("Privacy en waardigheid", symbol: "hand.raised.fill", duration: 14, [
                section("Zelfbeschikking is heilig", symbol: "hand.raised.fill", """
Persoonlijke verzorging is de meest intieme zorghandeling die bestaat. De cliënt geeft u toegang tot de meest persoonlijke aspecten van zijn of haar lichaam en leven. Dit vraagt om een hoge mate van respect, discretie en professioneel gedrag.

Vraag altijd expliciet toestemming voor elke handeling, ook als u dit al eerder heeft gedaan. 'Mag ik nu uw gezicht wassen?' is geen overbodige vraag — het geeft de cliënt controle over het proces.
"""),
                section("Zelfredzaamheid bevorderen", symbol: "figure.arms.open", """
Doe nooit meer dan nodig. Als de cliënt zijn armen zelf kan wassen, laat hem dat dan doen. Jouw rol is ondersteunen en aanvullen, niet overnemen. Zelfredzaamheid behouden is een kernprincipe in de zorgsector — mensen die alles uit handen gegeven krijgen, gaan achteruit.

Zeg wat u gaat doen voordat u het doet. 'Ik was nu uw rug' geeft de cliënt de kans om te reageren of aan te geven dat hij dat liever zelf doet.
"""),
                section("Omgaan met schaamte en ongemak", symbol: "heart.fill", """
Veel ouderen voelen schaamte of ongemak bij persoonlijke verzorging door een vreemde. Dit is volkomen normaal. Minimaliseer dit door te praten tijdens de wasbeurt (over koetjes en kalfjes), de cliënt nooit alleen te laten staan terwijl hij gedeeltelijk ontkleed is, en snel en doelgericht te werken.

Als een cliënt aangeeft de wasbeurt te willen overslaan, respecteer dat altijd. Noteer het in de app. Dwingen is nooit toegestaan.
""")
            ]),
            reading("Stap-voor-stap wasbeurt", symbol: "drop.fill", duration: 16, [
                section("Voorbereiding", symbol: "checklist", """
Bereid alles voor voordat u begint: warme washand (36-38°C), handdoek, zeep, crème, schone kleding — alles binnen handbereik. Een halverwege-stop om iets te halen terwijl de cliënt gedeeltelijk ontkleed staat, is onaanvaardbaar.

Draag handschoenen bij contact met slijmvliezen, wonden of incontinentiemateriaal. Was uw handen voor en na de zorg, ook als u handschoenen droeg.
"""),
                section("Volgorde van de wasbeurt", symbol: "drop.fill", """
De standaard volgorde: gezicht → nek → armen (ver verwijderd van genitaliën) → romp voor → romp achter → benen → genitaliën en billen als laatste. Dit principe (schoon naar vuil) verkleint het risico op verspreiding van bacteriën.

Gebruik voor het intieme gebied altijd een aparte washand of wisje. Nooit dezelfde washand gebruiken voor gezicht en intiem gebied.
"""),
                section("Huidverzorging bij ouderen", symbol: "hands.sparkles.fill", """
Oudere huid is dunner, droger en kwetsbaarder. Droog altijd goed af, met name in huidplooien (oksels, liezen, onder de borsten). Vochtige huidplooien zijn een voedingsbodem voor schimmelinfecties.

Breng na het drogen een vochtinbrengende crème aan als dit in het zorgplan staat. Let op: sommige cliënten zijn allergisch voor bepaalde geurstoffen. Gebruik altijd de crème die al in de badkamer staat — niet uw eigen product.
"""),
                section("Alarmsignalen op de huid", symbol: "exclamationmark.triangle.fill", """
Noteer altijd wat u op de huid ziet: rode plekken op drukpunten (stuitje, hielen, schouderbladen) zijn vroege tekenen van een doorligwond. Blauwe plekken die er de vorige keer niet waren. Uitslag. Open wonden.

Behandel geen huidproblemen zelf. Meld alles in de app. Bij een open wond of ernstige huidproblemen: de thuiszorgcoördinator of huisarts moet worden ingeschakeld.
""")
            ]),
            video("Demonstratie: juiste techniek wasbeurt", symbol: "figure.arms.open", duration: 12, """
In deze instructievideo zie je een complete wasbeurt aan de wastafel in real-time. Je ziet hoe de buddy toestemming vraagt, hoe de watertemperatuur wordt gecontroleerd, de volgorde van schoon naar vuil, het correct drogen van huidplooien en het aanbrengen van crème. Let ook op hoe de buddy communiceert tijdens de wasbeurt.
"""),
            quiz("Eindtoets — Hulp bij wassen", symbol: "drop.circle.fill", [
                q("Wat is het eerste dat je doet voordat je begint met de wasbeurt?",
                  ["Meteen beginnen zodat de cliënt niet afkoelt", "Toestemming vragen en uitleggen wat je gaat doen", "Warm water klaarzetten en de handdoeken ophangen", "Handschoenen aantrekken"], correct: 1,
                  "Toestemming en communicatie gaan altijd voor. De cliënt heeft het recht om te weten wat er gaat gebeuren en om te weigeren. Daarna pas de praktische voorbereiding."),
                q("Welke watertemperatuur is veilig voor een wasbeurt bij ouderen?",
                  ["30-33°C", "36-38°C", "40-42°C", "Zo warm als de cliënt prettig vindt, zonder limiet"], correct: 1,
                  "36-38°C is de veilige range voor een wasbeurt. Ouderen voelen temperaturen vaak minder goed, waardoor brandwonden kunnen ontstaan bij te heet water. Meet altijd met uw pols of elleboog."),
                q("In welke volgorde was je een cliënt?",
                  ["Van genitaliën naar gezicht, zodat je eindigt met het schoonste deel", "Van gezicht naar genitaliën (schoon naar vuil)", "In de volgorde die de cliënt het prettigst vindt", "Het maakt niet uit als je maar schone wasdoekjes gebruikt"], correct: 1,
                  "Het principe 'schoon naar vuil' (gezicht eerst, genitaliën als laatste) minimaliseert bacteriële kruisbesmetting. Dit is een basisregel in infectiepreventieprogramma's."),
                q("Een cliënt weigert vandaag gewassen te worden. Wat doe je?",
                  ["Toch doorgaan — hygiëne is medisch noodzakelijk", "Het proberen te overtuigen totdat ze toestemmen", "De weigering accepteren, noteren in de app en afsluiten", "De familie direct bellen om toestemming te vragen"], correct: 2,
                  "Zelfbeschikking staat boven alles. Een cliënt mag weigeren. Noteer het in de app zodat de continuïteit van zorg gewaarborgd is en de volgende zorgverlener op de hoogte is."),
                q("Wanneer draag je handschoenen bij een wasbeurt?",
                  ["Altijd, bij elke wasbeurt", "Nooit — handschoenen zijn koud en onprettig voor de cliënt", "Bij contact met wonden, slijmvliezen of incontinentiemateriaal", "Alleen als de cliënt ziek is"], correct: 2,
                  "Handschoenen beschermen zowel de cliënt als de buddy. Je draagt ze bij contact met lichaamsvloeistoffen, slijmvliezen, wonden en incontinentiemateriaal. Bij een 'gewone' wasbeurt van gezicht en armen zijn ze niet verplicht.")
            ])
        ]
    )

    // MARK: - Niveau 2: Signalering & Rapportage

    static let course_signalering: Course = Course(
        id: UUID(), level: .two,
        title: "Signalering & Rapportage",
        durationMinutes: 65,
        progressPercent: 0,
        unlocked: false,
        summary: "Wat is signaleren in de zorg, welke veranderingen zijn alarmerend, en hoe schrijf je een professionele rapportage?",
        modules: [
            reading("Wat is signaleren?", symbol: "eye.fill", duration: 14, [
                section("Signaleren als kerncompetentie", symbol: "eye.fill", """
Signaleren betekent: opmerken, beoordelen en doorgeven van veranderingen in de toestand of situatie van de cliënt. Als buddy ben jij vaak de persoon die de cliënt het meest regelmatig ziet. Jij merkt veranderingen op die familieleden op afstand missen.

Signaleren is geen diagnose stellen. Jij stelt geen medische diagnoses — dat doet een arts. Jij beschrijft wat je ziet, hoort en ruikt, en geeft dit door aan de juiste personen.
"""),
                section("Wat signaleer je?", symbol: "magnifyingglass", """
Let bij elk bezoek op vier domeinen: fysiek (hoe ziet de cliënt eruit, hoe beweegt hij/zij), cognitief (is hij/zij helder of verward), emotioneel (is hij/zij vrolijk, verdrietig, angstig), en sociaal (is er contact, zijn er familieleden geweest).

Vergelijk altijd met het vorige bezoek. Een cliënt die normaal energiek is maar vandaag nauwelijks uit zijn stoel komt — dat is een signaal. Een cliënt die normaal goed eet maar vandaag haar bord vrijwel onaangeroerd laat — dat is een signaal.
"""),
                section("Directe vs. uitgestelde signalen", symbol: "bell.fill", """
Sommige signalen meld je direct — nog tijdens het bezoek of direct daarna: plotselinge verwardheid, tekenen van een beroerte, vallen, ernstige pijn, tekenen van verwaarlozing of mishandeling.

Andere signalen meld je in de reguliere notitie na afloop van het bezoek: verminderde eetlust de laatste drie bezoeken, toenemende bewegingsbeperking, veranderd slaappatroon. Dit zijn signalen die een trend vormen en minder urgent zijn maar wel belangrijk voor de langetermijnzorg.
""")
            ]),
            reading("Hoe schrijf ik een goede rapportage?", symbol: "doc.text.fill", duration: 16, [
                section("Objectief vs. subjectief", symbol: "doc.text.fill", """
Een goede rapportage is objectief: je beschrijft wat je hebt gezien, gehoord of gemeten. Vermijd interpretaties en oordelen. 'Mevrouw zag er moe uit' is subjectief. 'Mevrouw had wallen onder haar ogen, liep langzamer dan normaal en zei drie keer dat ze slecht had geslapen' is objectief.

Gebruik geen jargon of afkortingen die anderen niet begrijpen. Schrijf in begrijpelijk Nederlands. De rapportage wordt gelezen door familieleden, mogelijk door een huisarts en door collega-buddies.
"""),
                section("De SOAP-methode", symbol: "list.bullet.clipboard.fill", """
SOAP staat voor: Subjectief (wat vertelt de cliënt zelf), Objectief (wat zie jij), Assessment (jouw observatie/beoordeling), Plan (wat is het vervolgplan of wat adviseer je).

Voorbeeld: S — 'Mevrouw zegt al drie dagen buikpijn te hebben.' O — 'Mevrouw heeft een opgezette buik, heeft weinig gegeten en is niet naar het toilet geweest.' A — 'Mogelijk obstipatie.' P — 'Familie geïnformeerd, advies om contact op te nemen met huisarts.'
"""),
                section("Wat je NOOIT in een rapportage schrijft", symbol: "xmark.circle.fill", """
Schrijf nooit: oordelen over de cliënt ('was lastig'), veronderstellingen als feiten ('heeft waarschijnlijk dementie'), informatie over derden ('de dochter was ook vreemd'), of informatie die niets met de zorg te maken heeft.

Schrijf ook niet wat je niet zeker weet zonder dat duidelijk te maken. 'Ik denk dat...' of 'mogelijk...' zijn toegestaan als je aangeeft dat het een observatie is, geen vastgesteld feit.
""")
            ]),
            quiz("Eindtoets — Signalering & Rapportage", symbol: "doc.badge.plus", [
                q("Wat is het verschil tussen signaleren en diagnosticeren?",
                  ["Er is geen verschil", "Signaleren is observeren en doorgeven; diagnosticeren is een medisch oordeel vellen", "Diagnosticeren doe je als buddy, signaleren doet de arts", "Signaleren mag alleen een verpleegkundige"], correct: 1,
                  "Signaleren is jouw kernrol: beschrijven wat je waarneemt. Diagnosticeren — een medische conclusie trekken — is voorbehouden aan BIG-geregistreerde zorgverleners."),
                q("Welke bevinding rapporteer je direct, niet pas na het bezoek?",
                  ["De cliënt heeft vandaag minder gegeten dan normaal", "Plotselinge verwardheid die niet normaal is voor deze persoon", "De cliënt klaagt over een milde rugpijn", "De cliënt was iets stiller dan normaal"], correct: 1,
                  "Plotselinge verwardheid kan een teken zijn van een beroerte, infectie, medicatiefout of andere urgente situatie. Dit meld je direct — wacht niet tot na het bezoek."),
                q("Wat betekent de 'O' in de SOAP-methode?",
                  ["Observeer — blijf goed kijken", "Objectief — wat jij zelf observeert als zorgverlener", "Overdracht — naar wie je rapporteert", "Opmerking — vrije tekst"], correct: 1,
                  "SOAP: S = wat de cliënt zelf zegt, O = wat jij als zorgverlener objectief waarneemt, A = jouw beoordeling, P = plan of advies."),
                q("Welke zin is geschikt voor een rapportage?",
                  ["'Mevrouw was weer lastig en deed niet mee'", "'Meneer zag er moe uit en was vast niet uitgerust'", "'Mevrouw heeft de wasbeurt geweigerd en gezegd dat ze zich niet lekker voelt'", "'Meneer heeft waarschijnlijk dementie en dat wordt erger'"], correct: 2,
                  "Objectief, feitelijk en zonder oordeel. 'Heeft geweigerd en gezegd dat...' beschrijft gedrag en uitspraken — geen oordeel, geen diagnose."),
                q("Een cliënt vertelt je een persoonlijk geheim. Wat noteer je?",
                  ["Alles — volledige transparantie is belangrijk", "Niets — het is vertrouwelijk", "Alleen de informatie die relevant is voor de zorgverlening", "De samenvatting, met naam van de betrokkenen"], correct: 2,
                  "Vertrouwelijkheid en zorgvuldigheid gaan hand in hand. Je noteert alleen wat relevant is voor de zorg. Persoonlijke details die niets met de zorg te maken hebben, horen niet in de rapportage.")
            ])
        ]
    )

    // MARK: - Niveau 3: ADL-zorg (diploma vereist)

    static let course_adl: Course = Course(
        id: UUID(), level: .three,
        title: "ADL-zorg — Volledige ondersteuning",
        durationMinutes: 200,
        progressPercent: 0,
        unlocked: false,
        summary: "Alleen na Verzorgende-IG diploma of HBO-V jaar 2+. Volledige ADL, stomazorg en niet-complexe wondzorg.",
        modules: [
            video("Introductie ADL-zorg", symbol: "heart.text.square.fill", duration: 10, """
Welkom bij het Niveau 3 traject. Dit traject is uitsluitend toegankelijk voor buddies met een Verzorgende-IG diploma of HBO-V studenten vanaf jaar 2. In deze video krijg je een overzicht van alle ADL-handelingen die vallen binnen Niveau 3, de wettelijke kaders (Wet BIG), en hoe de samenwerking met BIG-geregistreerde begeleiders werkt.
"""),
            reading("Volledige ADL", symbol: "figure.arms.open", duration: 25, [
                section("Wat valt onder ADL?", symbol: "figure.arms.open", """
ADL staat voor Activiteiten van het Dagelijks Leven. Hieronder vallen: wassen, aankleden, eten en drinken, toiletgang, mobiliteit binnenshuis, en in- en uitbed gaan. Als Niveau 3 buddy ondersteun je bij al deze activiteiten.

Het principe van zelfredzaamheid geldt ook hier: doe nooit meer dan nodig. Een cliënt die zijn bovenlichaam zelf kan wassen, doet dat. Jij vult aan waar nodig. Dit stimuleert fysieke en mentale zelfstandigheid.
"""),
                section("Complexe hygiënezorg", symbol: "drop.fill", """
Bij volledige ADL doe je meer dan een wasbeurt aan de wastafel: je helpt bij douchen of in bad gaan, haarwassen, tanden poetsen en scheren. Elk van deze handelingen heeft een eigen volgorde en techniek.

Bij het douchen let je extra op het valrisico: natte vloer, drempels, en het bukken om de voeten te wassen. Gebruik altijd een douchekruk als de cliënt niet lang kan staan. Controleer de watertemperatuur voor de cliënt er in gaat.
"""),
                section("Aankleden: meer dan het lijkt", symbol: "tshirt.fill", """
Aankleden bij een cliënt met beperkte mobiliteit vraagt specifieke kennis: bij hemiplegie (halfzijdige verlamming) kleed je altijd eerst het aangedane been of arm aan — 'zwak eerst, sterk laatst'. Bij het uitkleden is het omgekeerd.

Gebruik kleding die gemakkelijk aan- en uitgetrokken kan worden: elastische banden, klittenband, wijdere halsgaten. Stimuleer de cliënt om zoveel mogelijk zelf te doen, ook al duurt het langer.
""")
            ]),
            reading("Stomazorg", symbol: "cross.case.fill", duration: 20, [
                section("Wat is een stoma?", symbol: "cross.case.fill", """
Een stoma is een chirurgisch gecreëerde opening in de buikwand waardoor de darm of de blaas uitmondt. Er zijn colostoma's (dikke darm), ileostoma's (dunne darm) en urostoma's (urinewegen). Elke stomasoort heeft een eigen verzorgingstechniek.

Als Niveau 3 buddy verzorg je alleen stoma's waarbij je specifiek voor bent opgeleid en dit is vastgelegd in het zorgplan. Nooit zelf een stomazak wisselen als je dit niet geleerd hebt of als het niet in het zorgplan staat.
"""),
                section("Stomazak wisselen: techniek", symbol: "bandage.fill", """
De zak wissel je wanneer deze vol, lekt of al meer dan 3-4 dagen oud is. Zorg voor warme handen, alle benodigdheden bij de hand en voldoende privacy. Verwijder de oude zak voorzichtig, reinig de huid rondom de stoma met lauw water en een droge washand, droog goed.

Controleer de huid om de stoma: roodheid, irritatie of kleine blaasjes zijn signalen van huidproblemen. Dit meld je altijd.
""")
            ]),
            reading("Niet-complexe wondzorg", symbol: "bandage.fill", duration: 20, [
                section("Grenzen van jouw bevoegdheid", symbol: "exclamationmark.shield.fill", """
Als Niveau 3 buddy mag je eenvoudige wonden verzorgen: kleine oppervlakkige wonden, schaafwonden en wonden die al door een verpleegkundige zijn beoordeeld en waarvoor een verbandprotocol is opgesteld.

Je mag NOOIT: een wond verbinden die je niet kent, een wond inschatten of diagnoseren, een verbandprotocol opstellen, of diepe, geïnfecteerde of chronische wonden (doorligwonden, ulcera) behandelen zonder directe supervisie van een BIG-geregistreerde verpleegkundige.
"""),
                section("Wondverzorging: basisprincipes", symbol: "bandage.fill", """
Wassen: reinig de wond met fysiologisch zout (NaCl 0,9%) of lauw stromend water, van binnen naar buiten. Nooit met gewone zeep in een open wond. Verbinden: gebruik het verbandmateriaal dat in het verbandprotocol staat — vervang niet op eigen initiatief.

Signalen van infectie: roodheid rondom de wond die groter wordt, warmte, zwelling, pusvorming, onaangename geur of koorts bij de cliënt. Dit meld je direct en je verzorgt de wond niet zelfstandig totdat een verpleegkundige heeft beoordeeld.
""")
            ]),
            quiz("Eindtoets — ADL-zorg & Niveau 3", symbol: "cross.circle.fill", [
                q("Bij het aankleden van een cliënt met een verlamde linkerarm: welke arm kleed je eerst aan?",
                  ["Rechts — de sterke arm, zodat die al vrij is", "Links — de aangedane arm als eerste", "Het maakt niet uit", "De arm die de cliënt zelf aanwijst"], correct: 1,
                  "'Zwak eerst, sterk laatst' bij aankleden. De aangedane arm heeft minder bewegingsvrijheid — die gaat eerst door de mouw. Bij uitkleden is het omgekeerd: sterk eerst, zwak laatst."),
                q("Wanneer wissel je een stomazak?",
                  ["Altijd dagelijks, ongeacht de vulling", "Als de zak vol is, lekt, of ouder is dan 3-4 dagen", "Alleen als de cliënt erom vraagt", "Alleen als er een geur is"], correct: 1,
                  "Stomazakken worden gewisseld bij volheid, lekkage of ouderdom (max 3-4 dagen). Dagelijks wisselen is onnodig en belastend voor de huid rondom de stoma."),
                q("Met wat reinig je een wond?",
                  ["Gewone zeep en warm water", "Fysiologisch zout (NaCl 0,9%) of lauw stromend water", "Jodium of alcohol — dat desinfecteert het beste", "Mondwater — dat is steriel"], correct: 1,
                  "Fysiologisch zout of lauw stromend water is de standaard voor wondreininging. Alcohol en jodium beschadigen nieuw weefsel. Gewone zeep irriteert open wonden."),
                q("Je ziet dat een wond die je kent plotseling pus vertoont en de huid eromheen rood en warm is. Wat doe je?",
                  ["De wond verbinden zoals altijd en het noteren", "De wond verbinden met een antibiotische zalf uit de verbandkist", "Stoppen met wondverzorging en direct de thuiszorgcoördinator of verpleegkundige inschakelen", "Afwachten tot het volgende bezoek en dan beoordelen"], correct: 2,
                  "Tekenen van infectie (pus, warmte, roodheid) vereisen beoordeling door een verpleegkundige. Jij behandelt geen geïnfecteerde wonden zelfstandig — dat valt buiten jouw bevoegdheid als Niveau 3 buddy."),
                q("Welke handeling valt BUITEN de bevoegdheid van een Niveau 3 buddy?",
                  ["Volledige wasbeurt inclusief douchen", "Stomazak wisselen conform protocol", "Injecties geven op basis van het medicatieschema", "Aankleden bij hemiparese"], correct: 2,
                  "Injecties zijn altijd een voorbehouden handeling (Wet BIG art. 36) en vallen buiten de bevoegdheid van alle buddies, inclusief Niveau 3. Dit mag alleen door BIG-geregistreerde verpleegkundigen.")
            ])
        ]
    )

    // MARK: - All courses as array

    static let allCourses: [Course] = [
        course_basisWelkom,
        course_communicatie,
        course_veiligheid,
        course_privacy,
        course_steunkousen,
        course_maaltijden,
        course_valpreventie,
        course_medicatie,
        course_wassen,
        course_signalering,
        course_adl
    ]
}
