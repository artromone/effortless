#include <QApplication>
#include <QCryptographicHash>
#include <QMessageBox>
#include <QQmlApplicationEngine>
#include <QSharedMemory>
#include <QSystemSemaphore>

namespace {
QString generateKeyHash(const QString &key, const QString &salt) {
  QByteArray data;

  data.append(key.toUtf8());
  data.append(salt.toUtf8());
  data = QCryptographicHash::hash(data, QCryptographicHash::Sha1).toHex();

  return data;
}

const QString APP_NAME = "effortless";
const QString SEMAPHORE_ID = generateKeyHash(APP_NAME, "semaphore");
const QString SHARED_MEMORY_ID = generateKeyHash(APP_NAME, "sharedMemory");
} // namespace

int main(int argc, char *argv[]) {
  QApplication app(argc, argv);

  QSystemSemaphore semaphore(SEMAPHORE_ID, 1);
  semaphore.acquire(); // another apps cannot work with shared memory

#ifndef Q_OS_WIN32
  // in linux/unix shared memory do not frees in case of crash, need to free garbage
  QSharedMemory nix_fix_shared_memory(SHARED_MEMORY_ID);
  if (nix_fix_shared_memory.attach())
  {
    nix_fix_shared_memory.detach();
  }
#endif
  QSharedMemory sharedMemory(SHARED_MEMORY_ID);

  bool is_running;
  if (sharedMemory.attach())
  {
    is_running = true;
  }
  else
  {
    sharedMemory.create(1);
    is_running = false;
  }

  semaphore.release();

  if (is_running)
  {
    QMessageBox msgBox;
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(QObject::tr("Another instance of app is already running."));
    msgBox.exec();
    return 1;
  }

  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/effortless/src/app/Main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
