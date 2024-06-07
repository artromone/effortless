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
} // namespace

int main(int argc, char *argv[]) {
  QApplication app(argc, argv);
  const QString appName = "effortless";

  const auto semaphoreId = generateKeyHash(appName, "semaphore");
  const auto sharedMemoryId = generateKeyHash(appName, "sharedMemory");

  QSystemSemaphore semaphore(semaphoreId, 1);
  semaphore.acquire(); // another apps cannot work with shared memory

#ifndef Q_OS_WIN32
  // in linux/unix shared memory do not frees in case of crash, need to free
  // garbage
  QSharedMemory nix_fix_shared_memory(sharedMemoryId);
  if (nix_fix_shared_memory.attach()) {
    nix_fix_shared_memory.detach();
  }
#endif
  QSharedMemory sharedMemory(sharedMemoryId);

  bool is_running;
  if (sharedMemory.attach()) {
    is_running = true;
  } else {
    sharedMemory.create(1);
    is_running = false;
  }

  semaphore.release();

  if (is_running) {
    QMessageBox msgBox;
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(
        QObject::tr("Приложение уже запущено.\n"
                    "Вы можете запустить только один экземпляр приложения."));
    msgBox.exec();
    return 1;
  }

  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/effortless/Main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
