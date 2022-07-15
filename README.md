# Solome
1. Инструкция
2. Документация

---

### 1. Инструкция

Функционал программы "Solome" состоит из двух частей:
- Включение и отключение внешнего накопительного устройства в зависимости от состояния включения приложения для резервного копирования (Acronis, IDrive и тд.).
- Внесение включения, копирования файлов и папок из указанного пути в указанный внешнее накопительное устройство и отключения внешнего накопительного устройства.

В первом случае, пользователь выбирает устройство, на котором будет храниться резервное копирование. После, приложение "Solome" будет следить за состоянием приложения резервного копирования. При завершении работы приложения резервного копирования, "Solome" отключает диск. При обратном включении приложения резервного копирования, внешнее накопительное устройство снова будет подключена.
> перед отключением и подключением внешнего накопительного устройства, приложение "Solome" так же следит за изменениями данного устройства (смена буквы в системе). Смена переменных данных о внешнем накопительном устройстве не мешает работе приложения, так как менеджмент устройств проводится с участием серийного номера устройства.

Во втором случае, пользователь выбирает путь, файлы из которого нужно копировать, и путь во внешнее накопительное устройства, а так же указать время и день недели. Приложение "Solome" вносит данные в конфигурацию, после чего вносит в "Планировщик задач" включение, копирование и отключение внешнего накопительного устройства.

---

### 2. Документация

Работа программы построена на взаимодействий библиотеки "windows.h" на C++, batch файлов, объединенных в использовании с фреймворком Flutter. 
Первый метод использования приложения - включение и отключение внешнего накопительного устройства с проверкой статуса приложения для резервного копирования, выполняется следующими функциями из библиотеки "windows.h":
- findMyProc() - проводит сканирование Task Manager системы Windows, и при нахождении приложения, соответствующее переменной notepad возвращает true, или false в противном случае;
- getLength() - возвращает количество подключенных к устройству всех накопительных устройств в значении buf_length;
- getNumber() - возвращает в виде строки букву и серийный номер логического тома через структуру Drive. Так же есть возможность передавать название тома, максимальный объем, формат диска;
- manageMedia() - принимает буквенное обозначение логического тома, и при сигнале true - включает диск, при сигнале false - отключает;
Данные функции передаются во фреймворк Flutter в виде динамической библиотеки (.dll). В дальнейшем, в коде приложения данные функции используются для:
- getButtons() - при использовании getLength() получает количество внешних накопительных устройств, и функцией getNumber() добавляет данные устройства в список. Данный список в последующем используется для передачи данных о внешнем накопительном устройстве для дальнейших операции включения/выключения;
- getProcessLog() - принимает в качестве переменной структуру Drive, обновляет список подключенных внешних накопительных устройств для правильного подбора накопительного устройства, в случае, если какие-либо данные о данном устройстве были изменены (буквенное обозначение). После чего, проводит мониторинг приложения через функцию findProc(). При активном статусе приложения включает выбранное внешнее накопительное устройство, если же приложение не найдено - отключает. Выводит результат действии в экран.

Второй метод использования данного приложения - добавление в "Планировщик задач" резервное копирование с последующим отключением внешнего накопительного устройства, осуществляется при использовании batch файлов.
В текстовый файл config.ini вводятся данные, полученные с приложения. Дальше, .bat приложения Script#1.bat и schScript.bat выполняют команды добавления операции включения внешнего накопительного устройства, копирование файлов в указанном пути в устройство, и отключение устройства.

При дебагинге в VSCode закомментить все пути и разкомментить закоменченные пути. Для билда ввести в командную строку "flutter build windows"

---
### Проблемы

- Что-то не так с schTasks - он не добавляет в планировщик - легко.
- Нужно прописать логику для динамического изменения config.ini для поиска внешнего диска. При перезначении буквы он не сработает корректно - легко или отказаться от использования batch и прописать данную логику и операции, выполняемые в batch файлах переделать в c/c++ - сложно.
- Подправить внешку было бы классно - легко.
- добавить библиотеку и дополнительные файлы в assets - легко.