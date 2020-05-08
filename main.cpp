#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "networkmanager.h"
#include "cpputils.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setOrganizationName("AMeditation");
    app.setOrganizationDomain("antonovpsy.ru");

    QQmlApplicationEngine engine;
    qmlRegisterSingletonType<CppUtils>("AMeditation.CppUtils", 1, 0, "CppUtils", CppUtils::cppUtilsSingletoneProvider);
    engine.rootContext()->setContextProperty("networkManager", new NetworkManager());
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
