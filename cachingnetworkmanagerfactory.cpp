#include "cachingnetworkmanagerfactory.h"

#include <QNetworkDiskCache>
#include <QNetworkAccessManager>
#include <QStandardPaths>

CachingNetworkAccessManager::CachingNetworkAccessManager(QObject *parent)
    : QNetworkAccessManager(parent)
{ }

QNetworkReply* CachingNetworkAccessManager::createRequest(Operation op, const QNetworkRequest &request, QIODevice *outgoingData)
{
    // 1. Самый простой вариант - кэшировать все. Ломает загрузку JSON.
    //return QNetworkAccessManager::createRequest(op, request, outgoingData);

    // 2. Продвинутый вариант, когда JSON явно грузится всегда, картинки предпочтительно по сети.
    // QNetworkRequest req(request);
    // req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, request.url().fileName().endsWith(QLatin1String("png")) ?
    //                      QNetworkRequest::PreferNetwork : QNetworkRequest::AlwaysNetwork);
    // return QNetworkAccessManager::createRequest(op, req, outgoingData);

    // 3. Компромиссный и простой вариант, когда всегда предпочитается интрнет, а кэш как fallback.
    QNetworkRequest req(request);
    req.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferNetwork);
    return QNetworkAccessManager::createRequest(op, req, outgoingData);
}

CachingNetworkManagerFactory::CachingNetworkManagerFactory()
{ }

QNetworkAccessManager *CachingNetworkManagerFactory::create(QObject *parent) {
    QNetworkAccessManager* manager = new CachingNetworkAccessManager(parent);

    QNetworkDiskCache* cache = new QNetworkDiskCache(manager);
    cache->setCacheDirectory(QString("%1/network").arg(QStandardPaths::writableLocation(QStandardPaths::CacheLocation)));

    manager->setCache(cache);
    return manager;
}
