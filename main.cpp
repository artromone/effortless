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

  QSystemSemaphore semaphore(semaphoreId, 1); // создаём семафор
  semaphore.acquire(); // Поднимаем семафор, запрещая другим экземплярам
                       // работать с разделяемой памятью

#ifndef Q_OS_WIN32
  // в linux/unix разделяемая память не освобождается при аварийном завершении
  // приложения, поэтому необходимо избавиться от данного мусора
  QSharedMemory nix_fix_shared_memory(sharedMemoryId);
  if (nix_fix_shared_memory.attach()) {
    nix_fix_shared_memory.detach();
  }
#endif
  QSharedMemory sharedMemory(
      sharedMemoryId); // Создаём экземпляр разделяемой памяти
  bool is_running; // переменную для проверки ууже запущенного приложения
  if (sharedMemory
          .attach()) { // пытаемся присоединить экземпляр разделяемой памяти
    // к уже существующему сегменту
    is_running =
        true; // Если успешно, то определяем, что уже есть запущенный экземпляр
  } else {
    sharedMemory.create(1); // В противном случае выделяем 1 байт памяти
    is_running = false; // И определяем, что других экземпляров не запущено
  }
  semaphore.release(); // Опускаем семафор

  // Если уже запущен один экземпляр приложения, то сообщаем об этом
  // пользователю и завершаем работу текущего экземпляра приложения
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
