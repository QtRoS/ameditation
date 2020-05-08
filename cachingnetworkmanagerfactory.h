#ifndef CACHINGNETWORKMANAGERFACTORY_H
#define CACHINGNETWORKMANAGERFACTORY_H

#include <QQmlNetworkAccessManagerFactory>
#include <QNetworkAccessManager>

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

#endif // CACHINGNETWORKMANAGERFACTORY_H
