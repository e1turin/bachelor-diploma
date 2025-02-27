# Бакалаврский диплом

<!--toc:start-->
- [Бакалаврский диплом](#бакалаврский-диплом)
  - [Ссылки](#ссылки)
    - [Название](#название)
    - [Размышления](#размышления)
  - [Задание...](#задание)
    - [1. Основные вопросы, подлежащие разработке](#1-основные-вопросы-подлежащие-разработке)
      - [1.1. техническое задание:](#11-техническое-задание)
      - [1.2. исходные данные к работе:](#12-исходные-данные-к-работе)
      - [1.3. содержание работы:](#13-содержание-работы)
      - [1.4. цель:](#14-цель)
      - [1.5. задачи работы:](#15-задачи-работы)
      - [1.6. перечень подлежащих разработке вопросов:](#16-перечень-подлежащих-разработке-вопросов)
      - [1.7. рекомендуемые материалы и пособия для выполнения работы и т.д.:](#17-рекомендуемые-материалы-и-пособия-для-выполнения-работы-и-тд)
    - [2. Форма представления материалов ВКР](#2-форма-представления-материалов-вкр)
    - [3. Дата выдачи задания](#3-дата-выдачи-задания)
    - [4. Срок представления готовой ВКР](#4-срок-представления-готовой-вкр)
    - [5. Дополнительно](#5-дополнительно)
  - [Защита](#защита)
    - [Предзащита](#предзащита)
    - [Возможные вопросы](#возможные-вопросы)
<!--toc:end-->

тема: «Реализация модуль моделирования аппаратуры для SCADA-системы Controls.kt»

## Ссылки

Controls.kt: 
- https://sciprog.center/projects/controls
- https://git.sciprog.center/kscience/dataforge-core
- из telegram [@SciProgCentre](https://t.me/SciProgCentre):
  - про создание внутреннего формата представления ~VCD: https://t.me/SciProgCentre/24449
  - про задачу моделирования аппаартуры: https://t.me/SciProgCentre/26576
  - про Chisel: https://t.me/SciProgCentre/26604
- пока ничего на [youtrack issues](https://sciprog.center/youtrack/issues?q=%23Controls-kt)

Обзор Chisel для генерации сложных цифровых схем и сравнение с System Verilog:
- https://youtu.be/d_vlVsoJ8vI

ИРИС – инструментарий разработки интегральных схем в среде С++:
- https://engineer.yadro.com/wp-content/uploads/2024/06/gasanov-slides.pdf

CHISEL:
- https://www.imm.dtu.dk/~masca/chisel-book.pdf

Quokka:
- https://www.youtube.com/live/_MrGRMY-6jE
- https://github.com/EvgenyMuryshkin/qusoc

Verik:
- https://dspace.mit.edu/handle/1721.1/145151
    - https://dspace.mit.edu/bitstream/handle/1721.1/145151/Wang-frwang-meng-eecs-2022-thesis.pdf
    - https://github.com/frwang96/verik
        - https://codetabs.com/count-loc/count-loc-online.html

FPGA Twitch 03 - Введение в высокоуровневый синтез - High Level Synthesis (часть 1 из 2):
- https://youtu.be/a2SQQNgB4iQ

FIRRTL (dead):
- https://github.com/chipsalliance/firrtl

CIRCT — Circuit IR Compilers and Tools
- https://circt.llvm.org/
- https://github.com/llvm/circt
- Arcilator — 
    - https://youtu.be/iwJBlRUz6Vw
    - https://llvm.org/devmtg/2023-10/slides/techtalks/Erhart-Arcilator-FastAndCycleAccurateHardwareSimulationInCIRCT.pdf
- ИСП РАН: https://gitlab.ispras.ru/mvg/mvg-oss/circt

Venus rv32i — Kotlin RISC-V emulator:
- https://github.com/kvakil/venus
БЭВМ на Java
- https://github.com/tune-it/bcomp

MiL/SiL/PiL/HiL
- https://youtu.be/EZthOn4_0rw
- https://www.mathworks.com/matlabcentral/answers/440277-what-are-mil-sil-pil-and-hil-and-how-do-they-integrate-with-the-model-based-design-approach#answer_356873


### Название инструмента

- Kotlin
- IR
- *iL = * in the Loop
- HardWare
- CIRCT = Circuit IR Compilers & Tools
- Controls.kt ~ ctl, ctrl

### Размышления

Хочется иметь возможность симулировать систему прямо в Kotlin, вместе с
остальной системой, но главная задача это сделать **транслятор в промежуточное**
**представление**. Отсяда вопрос: на каком уровне должно быть это
*представление?  Ведь у нас может быть _"низкоуровневое"_ типа CIRCT или
какое-то повыше в виде схемы данных в Kotlin через композицию Data-классов, к
примеру.

При условии того, что компилятор свой разрабатывать выглядит очень 
расточительным, можно ограничиться функциональным DSL, который в результате
запуска будет давать IR или напрямую симулировать аппаратуру, т.к. обычно это
какой-то Top-модуль, в который интегрируются все другие функциональные
компоненты. Что-то вроде Gradle получится. Остается еще учесть специфику
Controls.kt и его архитектурные подходы через делегирование пропертей и, видимо,
непрерывное время нетипичное для моделей аппаратуры.

Наверное было бы хорошо иметь возможность переключать режимы работы модуля:
трансляция в IR и симуляция поведения.

Еще как альтернативный вариант это всегда получать промежуточное предтавление
и потом через сторонник инструменты взаимодействовать с ними, условно,
скомпилировать в CIRCT и запустить модель через arcilator, к которому 
подключается модель из Kotlin через Native. 
- Либо пойти дальше и написать модуль выполняющий симуляцию по данному IR, что
  пока выглядит нецелесообразно из-за сложности такого предприятия и непригодности
  JVM для таких симуляций; по сути придется сделать декомпилятор из IR в Kotlin
  (?).


## Задание...

### 1. Основные вопросы, подлежащие разработке

Информация для заполнения блока задания: 

#### 1.1. техническое задание: 

> Реализовать программный модуль для моделирования аппаратуры совместимый с фреймворком Controls.kt.

#### 1.2. исходные данные к работе:

1. Репозиторий исходных кодов и документация проекта Controls.kt.
2. Документация к проектам CIRCT, Chisel, Verik.

#### 1.3. содержание работы:

> Выпускная квалификационная работа предполагает реализацию программного модуля предоставляющего возможности по моделированию аппаратуры совместимого с фреймворком для создания и моделирования SCADA-систем Controls.kt.

#### 1.4. цель: 

<!-- FIXME: -->
> *Расширение возможностей по (?измеримо) моделированию и тестированию SCADA-систем.*

#### 1.5. задачи работы:

1. Изучение и анализ архитектуры фреймворка Controls.kt.
2. Исследование имеющихся решений для моделирования аппаратуры.
3. Проектирование архитектуры программного модуля.
4. Разработка программного модуля.
5. <!-- FIXME: --> *Проектирование и разработка тестового покрытия модуля.*
6. Тестирование готового решения и интеграция в систему Controls.kt.
7. Документирование разработанных программных компонентов.

#### 1.6. перечень подлежащих разработке вопросов:

1. Архитектур SCADA-систем и систем моделирования.
2. Языки описания аппаратуры.
3. Проект CIRCT.
4. ...

#### 1.7. рекомендуемые материалы и пособия для выполнения работы и т.д.:

1.  <!-- TODO: -->

### 2. Форма представления материалов ВКР

Информация для заполнения блока задания: 
  1. форма представления основных или дополнительных результаты ВКР:  
  2. форма представления Приложений (например: программный код, чертежи, презентация, и пр.):
    
> Отчет. Пояснительная записка, программный код, презентация.

### 3. Дата выдачи задания

> 14 октября 2024 год.

### 4. Срок представления готовой ВКР

> Рекомендации: Срок сдачи готовой работы не позднее даты начала ГИА (по графику
> учебного процесса).  Срок загрузки итоговой версии ВКР для проверки в системе
> «Антиплагиат» - не позднее чем за 10 дней до даты защиты ВКР 
> (см.[Положении о ВКР)](https://student.itmo.ru/ru/gia_docs/)

> 25 мая 2025 год.

### 5. Дополнительно

> Можете конкретизировать график представления материалов ВКР или указать любую
> другую информацию по этапам работы на ВКР.

<!-- TODO: -->

## Защита

### Предзащита

> Уважаемые студенты!
>
> 🔍 26,27,28 февраля пройдёт первое прослушивание ваших ВКР. Оно будет
> проходить на русском языке в zoom (ссылка будет позже).
>
> Таблица с распределением студентов по дням и времени (ищите в файле вкладку
> с вашей группой) -
> https://docs.google.com/spreadsheets/d/108VXrHwRSkW0DzsfxA3F5i6N1EY1eeBp92CyNGKrkik/edit?usp=sharing
>
> Для 1-го прослушивания ВКР необходимо подготовить краткое сообщение (не
> более 3 минут) со следующей информацией:
>
> 📎Тема ВКР
>
> 📎Актуальность темы. Здесь для обоснования следует использовать данные,
> например, из статистических отчетов, подтверждающих актуальность решаемых
> задач (проблем).
>
> 📎Цель и задачи ВКР
>
> 📎План работы
>
> ‼️Примечание: для выступления необходимо подготовить материалы в виде
> презентации. Шаблон
> (https://docs.google.com/presentation/d/1W9aYz4DsghPoxW8heycQ5dFslVoLblaK/edit#slide=id.p1)
> презентации.
>
> С уважение, секретарь комиссии Кирсанова Ольга Владимировна

Тема ВКР: Реализация модуль моделирования аппаратуры для SCADA-системы Controls.kt

Актуальность темы:

- из telegram [@SciProgCentre](https://t.me/SciProgCentre):
  - про создание внутреннего формата представления ~VCD: https://t.me/SciProgCentre/24449
  - про задачу моделирования аппаартуры: https://t.me/SciProgCentre/26576

- MiL/SiL/PiL/HiL
  - [1](https://www.mathworks.com/matlabcentral/answers/440277-what-are-mil-sil-pil-and-hil-and-how-do-they-integrate-with-the-model-based-design-approach#answer_356873)]
  - [2](https://youtu.be/EZthOn4_0rw)]

- Controls.kt (former DataForge-control):
  - ["Declarative analysis in "Troitsk nu-mass" experiment"](https://iopscience.iop.org/article/10.1088/1742-6596/1525/1/012024)
  - ["A Novel Solution for Controlling Hardware Components of Accelerators and Beamlines"](https://www.preprints.org/manuscript/202108.0336/v1)
  - ["Controls-kt, a Next Generation Control System"](https://www.researchgate.net/publication/373369314_Controls-kt_a_Next_Generation_Control_System)
  - [kscience/dataforge-core](ttps://git.sciprog.center/kscience/dataforge-core)

  - Композитная архитектура: [CompositeControlComponents.kt](https://git.sciprog.center/kscience/controls-kt/src/branch/dev-maxim/controls-core/src/commonMain/kotlin/space/kscience/controls/spec/CompositeControlComponents.kt)
    - пример из тестов: [CompositeControlTest.kt](https://git.sciprog.center/kscience/controls-kt/src/branch/dev-maxim/controls-core/src/commonTest/kotlin/space/kscience/controls/spec/CompositeControlTest.kt)
  - Demo проекты: [controls-kt/demo](https://git.sciprog.center/kscience/controls-kt/src/branch/dev/demo)

Цель и задачи ВКР:

> 

План работы:





### Возможные вопросы

1. А какие еще есть технологии для разработки SCADA-систем? зачем Controls.kt?

