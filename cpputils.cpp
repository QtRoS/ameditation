#include "cpputils.h"

#include <QClipboard>
#include <QGuiApplication>

Q_LOGGING_CATEGORY(CppSingletone, "CppUtils")

CppUtils::CppUtils(QObject *parent) : QObject(parent)
{ }

CppUtils::~CppUtils()
{ }

void CppUtils::copyToClipboard(const QString& text) const
{
    qCDebug(CppSingletone) << text;
    QGuiApplication::clipboard()->setText(text);
}

QString CppUtils::prependWithDownloadsPath(const QString &fileName) const
{
    static QString dirName;
    if (dirName.isEmpty())
    {
        dirName = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QStringLiteral("/AMeditation");
        qCDebug(CppSingletone) << "Directory for downloads:" << dirName;
    }

    if (!QDir(dirName).exists() && !QDir().mkdir(dirName))
    {
        qCCritical(CppSingletone) << "Can't create directory for downloads:" << dirName;
        return fileName;
    }

    return QDir::cleanPath(dirName + QDir::separator() + fileName);
}

bool CppUtils::openUrlExternally(const QString &url) const
{
    return QDesktopServices::openUrl(QUrl(url));
}

bool CppUtils::removeFile(const QString &fileName) const
{
    QFileInfo fi(fileName);

    if (!fi.exists())
    {
        qCWarning(CppSingletone) << "Local file doesn't exist:" << fileName;
        return false;
    }

    return QFile::remove(fileName);
}

QObject *CppUtils::cppUtilsSingletoneProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new CppUtils();
}

