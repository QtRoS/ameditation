#include "networkmanager.h"

Q_LOGGING_CATEGORY(NetMan, "NetworkManager")

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent),
      m_downloadReply(nullptr),
      m_uploadReply(nullptr),
      m_downloadError(QNetworkReply::NoError),
      m_uploadError(QNetworkReply::NoError)
{
//    connect(&m_man, SIGNAL(sslErrors(QNetworkReply *, QList<QSslError>)),
//        this, SLOT(slotSslErrors(QNetworkReply *, const QList<QSslError>&)));
//    connect(&m_man, &QNetworkAccessManager::sslErrors,
//            this, &NetworkManager::slotSslErrors);
}

NetworkManager::~NetworkManager()
{ }

bool NetworkManager::download(const QString &url, const QString& localFile)
{
    if (m_downloadReply != nullptr)
    {
        qCWarning(NetMan) << "Download already in progress";
        return false;
    }

    if (m_downloadFile.isOpen())
        m_downloadFile.close();

    qCDebug(NetMan) << "Download file name:" << localFile;

    m_downloadFile.setFileName(localFile);
    if (!m_downloadFile.open(QIODevice::Truncate | QIODevice::WriteOnly))
    {
        qCWarning(NetMan) << "File '" + localFile + "' can't be opened:" << m_downloadFile.errorString() << m_downloadFile.error();
        return false;
    }

    makeRequest(url, OpDownload);

    return true;
}

bool NetworkManager::upload(const QString &url, const QString& localFile)
{
    if (m_uploadReply != nullptr)
    {
        qCWarning(NetMan) << "Upload already in progress";
        return false;
    }

    if (m_uploadFile.isOpen())
        m_uploadFile.close();

    QString norm = localFile;
    if (norm.startsWith("file://"))
        norm = norm.remove(0, 7);
    qCDebug(NetMan) << "Upload file name:" << norm;

    m_uploadFile.setFileName(norm);
    if (!m_uploadFile.open(QIODevice::ReadOnly))
    {
        qCWarning(NetMan) << "File '" + norm + "' can't be opened:" << m_uploadFile.errorString() << m_uploadFile.error();
        return false;
    }

    makeRequest(url, OpUpload);

    return true;
}

void NetworkManager::abort()
{
    abortDownload();
    abortUpload();
}

void NetworkManager::abortDownload()
{
    qCDebug(NetMan) << "Download aborted";
    if (m_downloadReply)
        m_downloadReply->abort();
}

void NetworkManager::abortUpload()
{
    qCDebug(NetMan) << "Upload aborted";
    if (m_uploadReply)
        m_uploadReply->abort();
}

void NetworkManager::slotDownloadProgress(qint64 get, qint64 total)
{
    qCDebug(NetMan) << "Download progress:" << get << "of" << total;
    emit downloadOperationProgress(get, total);
}

void NetworkManager::slotUploadProgress(qint64 sent, qint64 total)
{
    qCDebug(NetMan) << "Upload progress:" << sent << "of" << total;
    emit uploadOperationProgress(sent, total);
}

void NetworkManager::slotDownloadDataAvailable()
{
    if (!m_downloadReply)
    {
        qCCritical(NetMan) << "Reply is null at 'slotDownloadDataAvailable()'";
        return;
    }

    qint64 dataLen = m_downloadReply->bytesAvailable();
    m_downloadFile.write(m_downloadReply->read(dataLen));
}

void NetworkManager::slotDownloadError(QNetworkReply::NetworkError code)
{
    qCWarning(NetMan) << "Download error:" << code;
    m_downloadError = code;
}

void NetworkManager::slotUploadError(QNetworkReply::NetworkError code)
{
    qCWarning(NetMan) << "Upload error:" << code;
    m_uploadError = code;
}

void NetworkManager::slotDownloadFinished()
{
    qCDebug(NetMan) << "'slotDownloadFinished()' is called";

    int status = m_downloadReply->attribute( QNetworkRequest::HttpStatusCodeAttribute ).toInt();
    QString location = m_downloadReply->rawHeader("Location");
    // REDIRECT.
    if (status / 100 == 3 || !location.isEmpty())
    {
        qCDebug(NetMan) << "Redirected: " << location;
        cleanup(OpDownload, true);
        makeRequest(location, OpDownload);
    }
    else
    {
        QNetworkReply::NetworkError error = m_downloadError;
        cleanup(OpDownload);

        // In case of aborting do not call finished signal.
        if (error == QNetworkReply::OperationCanceledError)
            return;

        emit downloadOperationFinished(error == QNetworkReply::NoError ? "success" : "failed");
    }
}

void NetworkManager::slotUploadFinished()
{
    qCDebug(NetMan) << "'slotUploadFinished()' is called";
    // qDebug() << m_reply->rawHeaderPairs();

    QNetworkReply::NetworkError error = m_uploadError;
    cleanup(OpUpload);

    // In case of aborting do not call finished signal.
    if (error == QNetworkReply::OperationCanceledError)
        return;

    emit uploadOperationFinished(error == QNetworkReply::NoError ? "success" : "failed");
}

void NetworkManager::slotSslErrors(QNetworkReply* reply, QList<QSslError> errors)
{
    qCDebug(NetMan) << " =====>>>>>>>>>>>> 'slotSslErrors()' is called" << errors;
    reply->ignoreSslErrors(errors);
}

void NetworkManager::slotSslErrors1(QList<QSslError> errors)
{
    qCDebug(NetMan) << " =====>>>>>>>>>>>> 'slotSslErrors1()' is called" << errors;
    m_downloadReply->ignoreSslErrors(errors);
}

void NetworkManager::cleanup(Operation operation, bool soft)
{
    qCDebug(NetMan) << "CleanUp:" << operationToString(operation) << soft;
    if (operation == OpUpload)
    {
        if (!soft && m_uploadFile.isOpen())
            m_uploadFile.close();

        disconnect(m_uploadReply, SIGNAL(uploadProgress(qint64,qint64)),
                this, SLOT(slotUploadProgress(qint64,qint64)));

        disconnect(m_uploadReply, SIGNAL(finished()),
                this, SLOT(slotUploadFinished()));

        disconnect(m_uploadReply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotUploadError(QNetworkReply::NetworkError)));

        if (m_uploadReply)
            m_uploadReply->deleteLater();
        m_uploadReply = nullptr;
        m_uploadError = QNetworkReply::NoError;
    }
    else
    {
        if (!soft && m_downloadFile.isOpen())
            m_downloadFile.close();

        disconnect(m_downloadReply, SIGNAL(downloadProgress(qint64,qint64)),
                this, SLOT(slotDownloadProgress(qint64,qint64)));

        disconnect(m_downloadReply, SIGNAL(readyRead()),
                this, SLOT(slotDownloadDataAvailable()));

        disconnect(m_downloadReply, SIGNAL(finished()),
                this, SLOT(slotDownloadFinished()));

        disconnect(m_downloadReply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotDownloadError(QNetworkReply::NetworkError)));

        if (m_downloadReply)
            m_downloadReply->deleteLater();
        m_downloadReply = nullptr;
        m_downloadError = QNetworkReply::NoError;
    }
}

void NetworkManager::makeRequest(const QString &url, Operation operation)
{
    QUrl reqUrl(url);
    QNetworkRequest req(reqUrl);
    // req.setRawHeader("Authorization", "OAuth " + m_token.toLatin1());

    qCDebug(NetMan) << "Making request:" << operationToString(operation) << url;

    if (operation == OpUpload)
    {
        req.setRawHeader("Content-Type", "application/binary");
        req.setRawHeader("Content-Length", (QString::number(m_uploadFile.size()).toLatin1()));
        m_uploadReply = m_man.put(req, &m_uploadFile);

        connect(m_uploadReply, SIGNAL(uploadProgress(qint64,qint64)),
                this, SLOT(slotUploadProgress(qint64,qint64)));

        connect(m_uploadReply, SIGNAL(finished()),
                this, SLOT(slotUploadFinished()));

        connect(m_uploadReply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotUploadError(QNetworkReply::NetworkError)));
    }
    else
    {
        m_downloadReply = m_man.get(req);
//        m_downloadReply->ignoreSslErrors();

        connect(m_downloadReply, SIGNAL(downloadProgress(qint64,qint64)),
                this, SLOT(slotDownloadProgress(qint64,qint64)));

        connect(m_downloadReply, SIGNAL(readyRead()),
                this, SLOT(slotDownloadDataAvailable()));

        connect(m_downloadReply, SIGNAL(finished()),
                this, SLOT(slotDownloadFinished()));

        connect(m_downloadReply, SIGNAL(error(QNetworkReply::NetworkError)),
                this, SLOT(slotDownloadError(QNetworkReply::NetworkError)));

//        connect(m_downloadReply, &QNetworkReply::sslErrors,
//                this, &NetworkManager::slotSslErrors1);
    }
}

QString NetworkManager::operationToString(NetworkManager::Operation operation) const
{
    switch (operation)
    {
    case OpDownload:
        return "OpDownload";
    case OpUpload:
        return "OpUpload";
    default:
        return "OpUnknown";
    }
}

const QString &NetworkManager::token() const
{
    return m_token;
}

void NetworkManager::setToken(const QString &t)
{
    m_token = t;
}
