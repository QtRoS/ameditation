<img width="220" src="https://habrastorage.org/webt/rp/uv/u-/rpuvu-delydfsyvma6rm6nwtfri.png" align="left"/> Краткое лирическое вступление - в 2017 году мне случилось очень плотно заинтересоваться медитациями. Этому способствовала целая цепочка событий, благоприятных и не очень. Я долгие годы интересуюсь и практикую осознанные сновидения, однако конкретно медитациями в их каноническом виде до этого заниматься не приходилось. В эти дни многие ~~истории начинаются в баре (с)~~ увлечения начинаются с поиска в Google, вот и я начал именно так. Практически сразу нашлись топовые по популярности приложения для занятия медитацями - Calm и Headspace.  

Первое послужило неплохое отправной точкой (отличные обучающие медитации для начинающих), второе я не нашел для себя полезным, не понравилась подача. Оба оттолкнули своими платными (и надо сказать весьма дорогостоящими для РФ) тарифными планами. Возможно я просто не отношусь к категории людей, которым нужно заплатить, чтобы подбадривать себя чем-то заниматься :) Продолжная изучать Google play, я наткнулся на два близких мне по духу бесплатных приложения. Первое это "Let's Meditate" - я пользуюсь им по сей день, о втором речь пойдет в теле статьи.
<cut />

# Приложение

Итак, после достаточно долгих поисков нашлось совершенно неприметное приложение, называлось оно тогда, если не ошибаюсь, "Медитации. Антонов Александр". Как выяснилось, в нем можно было прослушать четыре авторские медитации, записанные и оформленные, собственно, Александром, с которым мы в дальнейшем познакомились и подружились. Приложение он собрал буквально из подручных средств самостоятельно, это было что-то вроде самодельного SPA с помощью WebView без каких-либо фреймворков, практически на "голом" HTML и минимально на Java. Выглядело оно так себе, да и некоторые функции просто отсутствовали (например, нельзя было перемещаться по записи, а только включить с начала). Поскольку мне очень понравился сам контент, я предложил Александру свою безвозмездную помощь в облагораживании приложения, чтобы, так сказать, "отдать что-то назад" по принципу "помогли мне, помогу и я". В теле статьи я постараюсь рассказать, с какими проблемами мы столкнулись при разработке, какие решения были приняты, и что получилось в конечном итоге! Надеюсь, отдельные рецепты статьи будут кому-либо полезны, а чтиво интересным :)


# Первая стадия разработки

Итак, мы поставили перед собой цели:
* Сохранить оригинальный функционал приложения
* Улучшить UI приложения и UX пользователя
* Обойтись минимальной сложностью реализации

### Qt

Резюмируя вышесказанное - возникла необходимость быстро сделать приложение с достаточно скромным функционалом (пока), код которого был бы понятен человеку с начальным опытом программирования на PHP/HTML. Размышлял я, откровенно говоря, недолго, выбор пал в пользу Qt, поскольку:

* У меня уже был большой опыт разработки на Qt (под Symbian, MeeGo, Ubuntu Phone и немного под Android);
* Возможность прозрачной разработки на десктопе, с последующей чистовой проверкой на целевом устройстве;
* Приложние можно создать на чистом QML, без использования C++. Наверняка читатель знает, но уточню - это JavaScript-like язык разметки, в нем может разобраться и любитель;
* В перспективе возможен прозрачный релиз на iOS (без доработки кода).

<spoiler title="Спойлер">
Забегая вперед могу сказать, что это было правильное решение - мы оба сошлись на этом, выпустив два крупных релиза приложения.
</spoiler>

### Построение и компоновка UI

Хороший разработчик и хороший дизайнер резко сосуществуют в одном теле, поэтому пришлось конкретно попотеть, чтобы придумать нечто симпатичное и удобное. Медитации в приложении для прослушивания медитаций должны занимать центральное место, поэтому я придумал большую и заметную кнопку, на которой разместились иконки отдельных медитаций. В дальнейшем мы ее не меняли, она стала своего рода сигнатурной для нашего приложения. В итоге получился вот такой интерфейс главной (светлая и темная темы): 

![](https://habrastorage.org/webt/yo/dm/or/yodmoriqhpendkc6mrvkgrp5rpy.png)

Все компоновку элементов интерфейса я делал и рекомендую делать "винтажными" anchors, Row, Column и Repeater. Это немного многословная, однако очень предсказуемая и хорошо себя ведущая на мобильных устройствах технология позиционирования элементов UI. Привожу код кнопки, в котором есть все описанные выше средства (самый большой листинг статьи):

```js
Button {
id: mainButton
anchors {
    left: parent.left
    right: parent.right
}
height: btnLayout.height + 30
Material.background: "white"
onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/MeditationListPage.qml"))

Column {
    id: btnLayout
    spacing: 10
    anchors {
        top: parent.top
        topMargin: 15
        left: parent.left
        right: parent.right
        margins: 10
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: (mainButton.width - 4 * 50) / 6
        Repeater {
            model: meditationModel

            RoundedIcon {
                source: Qt.resolvedUrl("qrc:/img/my%1.png".arg(model.index))
                color: model.color
                width: 50
                height: 50
            }
        }
    }

    Label {
        text: qsTr("Медитации")
        font.pointSize: 14
        color: "dimgrey"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        text: "В данном разделе Вы можете ознакомиться со списком медитаций, чтобы затем выбрать себе подходящую"
        anchors {
            left: parent.left
            right: parent.right
        }
        horizontalAlignment: Text.AlignHCenter
        Material.foreground: Material.Grey
        font.pixelSize: 12
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
}
```

В коде UI есть магические константы, и до поддержки HDPI в Qt приходилось оборачивать их в вызовы специального транслятора. Сейчас такой проблемы нет, нужно всего лишь включить нужную опцию Qt: `QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);`. Ввиду этого все константы решено было оставить "как есть".

В качестве темы визуального оформления был выбран Material design, поскольку он родной на Android и в Qt Quick Controls 2 есть его полноценная поддержка. Так же очень помогают статьи документации вроде этой https://doc.qt.io/qt-5/qtquickcontrols2-material.html. Чтобы придать отдельным медитациям некоторую уникальность и визуальную отличимость, я решил воспользоваться стандартными цветами Material design. UI на странице прослушивания медитации учитывает цветовую гамму, выставляя attached property `Material.accent` в нужный цвет.

![](https://habrastorage.org/webt/ax/2a/ff/ax2affbjfiw31a7lp49uydahsg8.png)

### Проблема больших ресурсов

Непосредственно mp3-файлы медитаций было решено поместить в ресурсы приложения, а именно в QRC. Файлы занимают порядка 10-15 мб каждый. Последующая компиляция вызвала у меня недоумение - она длилась дольше, а использование ОЗУ процессом в пике подскочило до 15 Гб. Оказалось, что для больших ресурсов существует специальная, слабодокументированная [опция](https://bugreports.qt.io/browse/QTBUG-50468) pro-файла:

```
CONFIG += resources_big
```

Она помогла мне, и, надеюсь, поможет читателю в трудный час.

### Ночной режим

Поскольку многие пользуются подобными приложениями в темное время суток, было решено реализовать "ночной режим". Я уже делал нечто подобное для приложения Shorts, там мы решили задачу очень просто, с помощью шейдера. Привожу код `DarkModeShader.qml`:

```js
ShaderEffect {
    fragmentShader: "
        uniform lowp sampler2D source;
        uniform lowp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;

        void main() {
            lowp vec4 p = texture2D(source, qt_TexCoord0);
            p.r = min(0.8, (1.0 - p.r) * 0.8 + 0.1);
            p.g = min(0.8, (1.0 - p.g) * 0.8 + 0.1);
            p.b = min(0.8, (1.0 - p.b) * 0.8 + 0.1);
            gl_FragColor = vec4(vec3(dot(p.rgb, vec3(0.299, 0.587, 0.114))), p.a) * qt_Opacity;
        }
    "
}
```

Используется он следующим образом:

```js
StackView {
    // ...
    layer.effect: DarkModeShader { }
    layer.enabled: optionsKeeper.isNightMode
}
```

Т.е. накладывается как эффект на котрол, включается или выключается опцией `isNightMode`. Благодаря связыванию свойств в Qt не понадобилась абсолютно никакого кода для включения/выключения ночного режима (кроме кнопки, конечно).  

*Кстати, у данного шейдера есть небольшой баг - очень блекло отображается желтый цвет. Если кто-то знает, как поправить - буду очень признателен!*

### Прочее

Вопрос проигрывания аудио был решен с помощью Qt Multimedia, а именно типа `Audio`. Он умеет проигрывать mp3, не выключается при блокировке экрана, поддерживает операцию перемотки - это все, что было на нужно на тот момент:

```js
Audio {
    id: audioPlayback
    source: meditAudioSource
}
// ...
Slider {
    anchors {
        left: parent.left
        right: playBtn.left
        verticalCenter: parent.verticalCenter
    }
    from: 0
    to: audioPlayback.duration
    value: audioPlayback.position
    onMoved: audioPlayback.seek(value)
    Material.accent: meditColor
}
```

Настройки решено было хранить в ~~нестареющем~~ `Settings` из `Qt.labs.settings` (серьезно, не понимаю, почему он никак не вырастет из labs):

```js
import Qt.labs.settings 1.0
// ... Опущен boilerplate-код опций, который кочует со мной из проекта в проект.
property Settings settings: Settings {
    property bool isNightMode: false
}
```

Обновленная версия приложения увидела свет в начале 2018 года, аудитория встретила ее очень тепло.


# Вторая стадия разработки

Собственно, спустя примерно два года, в конце апреля 2020, мне пришла идея доработать в приложении функционал, который когда-то задумывался, но так не увидел свет - загрузку дополнительных медитаций (я уже заспойлерил эту опцию на скриншоте выше). За это время у Александра накопилось несколько новых записей, а у меня - благодаря карантину - немного свободного времени :)

### Интеграция

Продолжая следовать правилу сохранения минимальной сложности, решили сформировать на сервере JSON-файл с описанием доступных для загрузки медитаций. Файлы аудиозаписей при этом отдаются как статика. В приложении для осуществления HTTP-запросов используется QML-обертка над `XMLHttpRequest` (для прозрачной и простой работы с JSON в QML). О ней я уже писал ранее в своей прошлой [статье](https://habr.com/ru/post/230435/).

### База данных

Совершенно неотвратимой стала необходимость хранения перечня загруженных медитаций. QML позволяет из коробки воспользоваться [LocalStorage](https://doc.qt.io/qt-5/qtquick-localstorage-qmlmodule.html), а именно полноценной SQLite. Всю работу с БД удобно вынести в отдельный JS-файл, который затем импортируется в QML, например:

```js
// databasemodule.js
.pragma library // I hope this will prevent the waste of memory.
.import QtQuick.LocalStorage 2.0 as SQL

function getMeditations() {
    ...
}

// TransferManager.qml
import "databasemodule.js" as DB
...
var syncedItems = DB.getMeditations()
```

Непосредственно работа с БД осуществляется примерно следующим образом:

```js
var db = SQL.LocalStorage.openDatabaseSync("AMeditation", "", "Main DB", 100000)
...
db.transaction(function(tx) {
    dbResult = tx.executeSql("SELECT * FROM meditations")
    console.log("meditations SELECTED: ", dbResult.rows.length)
})
```

Т.е. открывается соединение, затем в функцию `transaction` передается callback. Он будет вызван синхронно (и это хорошо, потому что в Qt другие средства для обеспечения асинхронности).  
Отдельно стоит рассмотреть тему версионирования. Функция `openDatabaseSync` подразумевает передачу версии вторым параметром. Это сделано для того, чтобы можно было открыть БД разных версий (не уверен, часто ли это бывает нужно на практике). Однако с помощью это особенности легко реализовать процедуру миграции БД. Дело в том, что если передать пустую строку, то откроется БД самой последней версии, которую уже можно догнать до целевой. Я организовал миграции как тройки ["версия с", "версия на", "код миграции"]:

```js
var migrations = [
    {'from': "", 'to': "1.0", 'ops': function(transaction) {
        transaction.executeSql("CREATE TABLE meditations ( \
            id	INTEGER PRIMARY KEY 
            ...
            status	TEXT);")
    }}
    ,{'from': "1.0", 'to': "1.1", 'ops': function(transaction) {
        transaction.executeSql("ALTER TABLE meditations ADD quality TEXT;")
    }}
]
```

При запуске приложения открывается база, затем на ней прогоняются нужные миграции (с небольшой особенностью реализации - в виде бесконечного цикла, пока хоть какие-то изменения происходят).

### C++

Загрузку и сохранение аудиозаписей в память устройства не реализовать с помощью QML, поэтому пришлось прибегнуть к помощи C++. Я взял реализацию менеджера загрузок из своего клиента Яндекс.Диска для Ubuntu Phone. Он умеет скачивать или закачивать одномоментно по одному файлу. Очередь операций в клиенте и в текущем приложении была реализована на QML в пользу все того же аргумента - простоты и стабильности реализации. Сделать видимым свой C++-объект в QML всегда было просто:

```cpp
engine.rootContext()->setContextProperty("networkManager", new NetworkManager());
```

В QML теперь можно написать что-то вроде:

```js
// Инициация загрузки.
var isSucces = networkManager.download(downloadUrl, currentDownload.localUrl)
...
// Прослушивание событий.
Connections {
    target: networkManager

    onDownloadOperationProgress: {
        d.currentDownload.current = current
        d.currentDownload.total = total
    }
    ...
}
```

Так же понадобились несколько утилитарных C++-функций, их я организовал в QML-ный [singletone ](https://doc.qt.io/qt-5/qtquick-localstorage-qmlmodule.html):

```cpp
// cpputils.h
class CppUtils : public QObject
{
    Q_OBJECT
public:
    explicit CppUtils(QObject *parent = nullptr);
    ~CppUtils();

    Q_INVOKABLE bool removeFile(const QString& fileName) const;
    static QObject *cppUtilsSingletoneProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

// main.cpp
qmlRegisterSingletonType<CppUtils>("AMeditation.CppUtils", 1, 0, "CppUtils", CppUtils::cppUtilsSingletoneProvider);
```

Т.е. создается специальный класс, у которого есть функция получения синглотна `cppUtilsSingletoneProvider`, а нужные методы обозначены как Q_INVOKABLE - это позволяет "видеть" их из QML. В QML используется вот так:

```js
import AMeditation.CppUtils 1.0
// ...
CppUtils.removeFile(cd.localUrl)
```

### Кэширование изображений

Загрузка аудиозаписей для оффлайн прослушивания является необходимостью, из-за которой пришлось пойти на намеренное усложнение приложения. Однако помимо аудио у медитаций есть еще один присущий им элемент - иконка. Она тоже хранится на сервере, и если каким-то специальным образом ее не загрузить, то в оффлайне она показываться не будет. Отдельные шаги по загрузке иконок в пайплайн скачивания медитации вставлять не хотелось, поэтому было принято решение зайти с другой стороны. Движок QML позволяет задать фабрику для сетевых менеджеров (QNetworkAccessManager). Это дает возможность подсунуть движку свой менеджер с правильными настройками кэширования. Делается примерно следующим образом:

```cpp
// cachingnetworkmanagerfactory.h
class CachingNetworkAccessManager : public QNetworkAccessManager
{
public:
    CachingNetworkAccessManager(QObject *parent = 0);
protected:
    QNetworkReply* createRequest(Operation op, const QNetworkRequest &req, QIODevice *outgoingData = 0);
};

class CachingNetworkManagerFactory : public QQmlNetworkAccessManagerFactory
{
public:
    CachingNetworkManagerFactory();
    QNetworkAccessManager *create(QObject *parent);
};

// cachingnetworkmanagerfactory.cpp

QNetworkReply* CachingNetworkAccessManager::createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData)
{
    QNetworkRequest req(request);
    req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferNetwork);
    return QNetworkAccessManager::createRequest(op, req, outgoingData);
}

QNetworkAccessManager *CachingNetworkManagerFactory::create(QObject *parent) {
    QNetworkAccessManager* manager = new CachingNetworkAccessManager(parent);

    QNetworkDiskCache* cache = new QNetworkDiskCache(manager);
    cache->setCacheDirectory(QString("%1/network").arg(QStandardPaths::writableLocation(QStandardPaths::CacheLocation)));
    manager->setCache(cache);
    return manager;
}

```

Т.е. менеджерам с помощью `setCache` настраивается кэширование, а в переопределении `createRequest` настраиваются детальности настройки кэширования для каждого запроса. У меня в реализации очень просто - всегда предпочитается сеть, иначе кэш.

### Сборка под Android

Для сборки потребуется SDK и NDK. По опыту рекомендую проделывать в Linux-подобных операционных системах, поскольку под Windows периодически что-то отваливается или ломается (например, в недавнем порыве сделать все удобным и прозрачным, в QtCreator 4.12 сломали возможность указать путь к NDK, пришлось шаманить с путями). В последних версиях NDK используется Clang. Собрать можно как arm_v7 (32 бита), так и arm_v8a (64 бита; Google play с 2019 года требует обязательно предоставлять такую сборку). Собранные приложения без проблем заливаются в Google play.

Релиз второго крупного обновления произошел буквально на днях, поэтому пока непонятно, как отреагировала аудитория.

# Итог

* Qt отличнейшим образом себя показал как инструмент для разработки pet-проектов, для некоммерческой разработки под Android. Мы очень быстро итерировались и проверяли идеи;
* Получившееся в результате приложение AMeditation (или как написано в UI маркета "Медитации 2.1. Антонов Александр") имеет порядка 10к+ загрузок и 250 отзывов, большинство из которых положительные (однако есть и отрицательные, некоторые пользователи недовольны качеством аудио, а ведь мы старались ужаться в небольшой размер ).
* Мы приятно провели время и, судя по отзывам, помогли множеству людей решить самые разные проблемы!
* Пока не релизнулись на iOS ввиду отсутствия яблочных устройств и разработческих аккаунтов.

В общем, разрабатывать на Qt весело, делать что-то бесплатно и для души - тоже!

P.S. Уважаемые Хабровчане, надеюсь, не сочтите за рекламу - приложение принципиально бесплатное и некоммерческое, хотелось рассказать о нем и об истории его создания интересующимся, ровно как и поделиться удачно найденными подходами к разработке.  
P.S.S. У приложения есть его близнец версии 1.1 с более старыми записями, у которого еще 5к+ загрузок и 100 отзывов. Вероятно, скоро уберем из магазина.

<spoiler title="Ссылки">
Код: https://github.com/QtRoS/ameditation
Google play: https://play.google.com/store/apps/details?id=com.antonovpsy.meditation2&hl=ru
</spoiler>