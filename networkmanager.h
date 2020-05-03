#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QFile>
#include <QDir>
#include <QRegExp>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(NetMan)



class NetworkManager : public QObject
{
    Q_OBJECT
    Q_ENUMS(Operation)
public:
    explicit NetworkManager(QObject *parent = nullptr);
    ~NetworkManager();

    Q_INVOKABLE bool download(const QString& url, const QString& localFile = "");
    Q_INVOKABLE bool upload(const QString& url, const QString& localFile);
    Q_INVOKABLE void abort();
    Q_INVOKABLE void abortDownload();
    Q_INVOKABLE void abortUpload();

    Q_PROPERTY(QString token READ token WRITE setToken)

    const QString& token() const;
    void setToken(const QString& t);

    enum Operation { OpDownload = 0, OpUpload = 1 };

signals:
    void downloadOperationProgress(qint64 current, qint64 total);
    void downloadOperationFinished(const QString& status);
    void uploadOperationProgress(qint64 current, qint64 total);
    void uploadOperationFinished(const QString& status);

private slots:
    /* Slots for QNetworkAccessManager. */
    void slotDownloadProgress(qint64 get, qint64 total);
    void slotUploadProgress(qint64 sent, qint64 total);
    void slotDownloadDataAvailable();
    void slotDownloadError(QNetworkReply::NetworkError code);
    void slotDownloadFinished();
    void slotUploadError(QNetworkReply::NetworkError code);
    void slotUploadFinished();

    void slotSslErrors(QNetworkReply *reply, QList<QSslError> errors);
    void slotSslErrors1(QList<QSslError> errors);

private:
    void cleanup(Operation operation, bool soft = false);
    void makeRequest(const QString& url, Operation operation);
    QString operationToString(Operation operation) const;

private:
    QString m_token;
    QNetworkAccessManager m_man;

    QFile m_downloadFile;
    QFile m_uploadFile;

    QNetworkReply* m_downloadReply;
    QNetworkReply* m_uploadReply;

    QNetworkReply::NetworkError m_downloadError;
    QNetworkReply::NetworkError m_uploadError;
};

#endif // NETWORKMANAGER_H
