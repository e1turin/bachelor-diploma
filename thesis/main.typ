#import "prelude.typ": *
#import "title-page.typ": title_page

#let title = "Диплом"
#let author = "Тюрин Иван Николаевич"

#show: thesis_format.with(
  title, 
  author, 
  title_page: [
    // no pagebreak as struct alements do so
    #title_page(
      author: author, 
      title: title
    )
  ],
)

// #struct(outlined: false)[СОДЕРЖАНИЕ]
#outline(title: [
  #block(
    inset: (left: 50%),
    align(center)[
      // #set text(14pt)
      СОДЕРЖАНИЕ
    ]
  )
])

//#struct
= ТЕРМИНЫ И ОПРЕДЕЛЕНИЯ

/ Lorem: #lorem(10)

// #struct
= ВВЕДЕНИЕ

При построении сложных систем, немаловажным является вопрос их тестирования, при
этом тестирование с использованием реального оборудования может быть очень
рисковано --- приборы могут быть дорогостоящими или даже уникальными, а выход из
строя хотя бы одного из них приведет к значительным временным потерям, не считая
финансовых затрат. Отсюда возникает необходимость в использовании "виртуальных
устройств", которые создают уровень абстракции между системой управления и
оборудованием, что позволяет незаметно для компонентов системы подменять
реализацию устройства. Например, виртуальное устройство будет имитировать
поведение прибора, но в нужный момент его переключат на реальный прибор.

Моделирование работы прибора может производиться различными способами, но в любом
случае эта задача требует дополнительных усилий по разработке модели и поддержания
ее актуальности. Кроме того, чем точнее модель и сложнее устройство, тем труднее
ее разработать человеческими усилиями, что серьезно затрудняет или даже делает
невозможным сквозное тестирование модели системы, Если же прибор во время
построения системы находится в разработке, то затраты на поддержание
актуальности модели так же возрастают. 

В данной научной работе исследуются пути решения и описывается разработанное
решение для задачи моделирования аппаратуры.

= Обзор предметной области
== Фреймворк для SCADA-систем

"Controls.kt" --- это фреймворк на языке программирования Kotlin,
разрабатываемый Центром научного программирования МФТИ https://sciprog.center/.
Фреймворк базируется на ядре фреймворка для работы с данными --- DataForge,
который разрабатывался совместно с подразделением JetBrains Research
(https://doi.org/10.1051/epjconf/201817705003). "Controls.kt" предназначен, как
заявляют его авторы, для создания "легковестных" SCADA-систем, его особенность
заключается в том, что он использует асинхронный подход для коммуникации между
устрайствами, что расширяет границы применимости фреймворка. Кроме того
фреймворк дает необходимые абстракции для использования виртульных устройств.

Наиболее известным примером применения "Controls.kt" является установка
использовавшаяся в научном эксперименте по изучению нейтрино, публично
известный, как
#quote([''Troisk nu-mass,, experiment]): https://www.inr.ru/~numass/,
https://doi.org/10.1088/1742-6596/1525/1/012024

В настоящий момент фокус фреймворка сместился в сторону моделирования систем,
примерами чего могут служить демонстрационные проекты в репозитории с исходными
кодами. Перед разработчиками фреймворка встала задача моделирования работы
устройств на уровне цифровых схем, чтобы добиться полного сквозного тестирования
разрабатываемой системы еще до момента изготовления устройства. Такой подход
позволяет повысить качество работы разрабатываемой системы и, возможно, снизить
затраты за счет раннего обнаружения проблем в системе при использовании
конкретной реализации аппаратных компонентов. 


== Способы описания аппаратных моделей
// выбор HDL

Языки описания аппаратуры (HDL, Hardware Description Languages) играют ключевую
роль в проектировании и разработке цифровых систем. Они позволяют инженерам
описывать поведение и структуру аппаратных компонентов на различных уровнях
абстракции, начиная от логических вентилей и заканчивая сложными системами на
кристалле (SoC). 

Наиболее популярными языками HDL являются Verilog, SystemVerilog, VHDL, SystemC,
Chisel и Verik. Каждый из них имеет свои особенности и области применения:

- *Verilog и SystemVerilog*: Индустриальные стандарты, широко используемые для
  проектирования и верификации цифровых систем. SystemVerilog является расширением
  Verilog и предоставляет дополнительные возможности, такие как
  объектно-ориентированное программирование, интерфейсы и ассерты, что делает его
  мощным инструментом для работы с современными сложными системами.

- *VHDL*: Еще один популярный язык описания аппаратуры, который отличается
  строгой типизацией и высокой читаемостью кода. Он часто используется в
  академической среде и для проектирования систем, требующих высокой надежности.

- *SystemC*: Язык и библиотека на основе C++, предназначенные для
  моделирования аппаратных систем на уровне системного проектирования. SystemC
  позволяет интегрировать моделирование аппаратуры и программного обеспечения, что
  делает его особенно полезным для проектирования встраиваемых систем.

- *Chisel*: Современный язык описания аппаратуры, основанный на языке
  программирования Scala. Chisel предоставляет высокоуровневый функциональный
  подход к проектированию цифровых систем и упрощает процесс разработки за счет
  использования промежуточного представления FIRRTL.

- *Verik*: Новый язык описания аппаратуры, основанный на Kotlin. Verik
  ориентирован на упрощение проектирования цифровых систем и интеграцию с
  современными инструментами разработки.

Каждый из этих языков имеет свои преимущества и недостатки, и выбор подходящего инструмента зависит от конкретных требований проекта, уровня абстракции и предпочтений команды разработчиков.

=== SystemVerilog

// Verilog, SystemVerilog, VHDL
// Индустриальные стандарты описания аппаратуры

SystemVerilog - это современный язык описания аппаратуры, который является
расширением языка Verilog и предназначен для проектирования, моделирования и
верификации цифровых систем. Он был разработан для устранения ограничений
Verilog и добавления новых возможностей, необходимых для работы с современными
сложными системами.

SystemVerilog сочетает в себе возможности описания аппаратуры (HDL) и языков для
верификации (HVL), что делает его универсальным инструментом для проектирования
и тестирования цифровых схем. Он поддерживает такие функции, как:

- **Расширенные типы данных**: SystemVerilog предоставляет богатый набор типов
  данных, включая структуры, объединения, перечисления и динамические массивы, что
  упрощает моделирование сложных систем.
- **Интерфейсы**: Позволяют описывать связи между модулями, упрощая управление
  сложными схемами и улучшая читаемость кода.
- **Ассерты**: Встроенные механизмы для проверки корректности работы системы на
  всех этапах проектирования.
- **Объектно-ориентированное программирование**: SystemVerilog поддерживает
  классы, наследование и полиморфизм, что делает его мощным инструментом для
  создания тестовых сред.
- **Синтаксические улучшения**: Упрощают написание и чтение кода по сравнению с
  традиционным Verilog.

SystemVerilog стал стандартом в индустрии и широко используется для
проектирования сложных цифровых систем, таких как процессоры, системы на
кристалле (SoC) и другие высокопроизводительные устройства. Его популярность
обусловлена мощными инструментами для верификации, такими как UVM (Universal
Verification Methodology), которые позволяют создавать масштабируемые и повторно
используемые тестовые среды.

Таким образом, SystemVerilog представляет собой эволюцию Verilog и VHDL,
объединяя их лучшие черты и добавляя современные возможности для проектирования
и тестирования цифровых систем.

=== SystemC
// Система моделирования с возможностью синтеза описания аппаратуры

SystemC - это язык и библиотека для моделирования аппаратных систем на уровне
системного проектирования. Он предоставляет мощные инструменты для описания и
симуляции сложных цифровых систем, включая возможность моделирования на уровне
транзакций (TLM, Transaction-Level Modeling). SystemC основан на языке
программирования C++ и предоставляет расширения для описания аппаратных
компонентов, таких как модули, процессы, сигналы и порты.

Одной из ключевых особенностей SystemC является его способность интегрировать
моделирование аппаратуры и программного обеспечения в единой среде. Это делает
его особенно полезным для проектирования встраиваемых систем, где требуется
тесная связь между аппаратной и программной частями.

SystemC поддерживает синтезируемые описания, что позволяет использовать его для
генерации аппаратного кода, совместимого с традиционными языками описания
аппаратуры, такими как Verilog или VHDL. Это делает его универсальным
инструментом для проектирования, симуляции и верификации цифровых систем.

Кроме того, SystemC активно используется в индустрии для создания моделей
аппаратуры, которые могут быть использованы для раннего тестирования и
оптимизации систем, что позволяет сократить время разработки и повысить качество
конечного продукта.


=== Chisel
Современный язык описания аппаратуры, основанный на Scala
Chisel - это язык, который позволяет описывать аппаратные схемы на высоком
уровне абстракции, используя функциональный стиль программирования. Он
предоставляет мощные инструменты для создания сложных цифровых систем и упрощает
процесс проектирования. 

Для представления цифровых схем Chisel использует промежуточное представление
аппаратных модулей, так называемое FIRRTL (Flexible Intermediate Representation
for RTL).

На текущий момент проект развивающий FIRRTL объявлен архивным, и разработчики
отсылаются к другой технологии, называемой CIRCT.

=== Verik
Современный язык описания аппаратуры, основанный на Kotlin

== Промежуточное представление цифровых схем
=== Проект LLVM CIRCT

MLIR и ключевые диалекты

=== Проект LLVM CIRCT

LLVM CIRCT (Circuit IR Compilers and Tools) — это проект, направленный на
создание инфраструктуры для проектирования цифровых схем с использованием
промежуточного представления (IR). CIRCT базируется на MLIR (Multi-Level
Intermediate Representation), что позволяет использовать модульный и расширяемый
подход к описанию и трансформации цифровых схем.

Основные компоненты CIRCT включают:

- *MLIR*: Основа для создания диалектов, которые описывают различные аспекты
  цифровых схем.
- *Диалекты*: Включают HW (Hardware), SV (SystemVerilog), FIRRTL и другие,
  которые позволяют описывать схемы на различных уровнях абстракции.
- *Инструменты трансляции*: Такие как `firtool` для преобразования FIRRTL в
  Verilog или другие форматы.

CIRCT предоставляет мощные возможности для оптимизации и анализа цифровых схем,
а также для интеграции с существующими инструментами проектирования.

Пример использования CIRCT в контексте моего проекта:

+ *Описание схемы*: Использование FIRRTL для описания цифровых схем на
  высоком уровне абстракции.
+ *Трансляция*: Преобразование FIRRTL в Verilog с помощью `firtool`.
+ *Интеграция*: Использование сгенерированного Verilog-кода в существующих
  инструментах, таких как ModelSim или Vivado, для симуляции и синтеза.

CIRCT также поддерживает разработку пользовательских диалектов, что позволяет
адаптировать его под специфические требования проекта. Это делает его
универсальным инструментом для проектирования и оптимизации цифровых систем.

=== Транслятор FIRRTL
firtool

=== Транслятор Verilog
circt-verilog

svlang

// #chapter
== Cредства моделирования

=== Индустриальные решения

// - Modelsim
// - Anylogic
// - MathLab Simulink
// - LabView
// - Engee
// - ...

- *Modelsim*: Популярный инструмент для симуляции цифровых схем. Поддерживает
  Verilog, VHDL и SystemVerilog. Обладает высокой точностью моделирования и
  возможностью интеграции с другими инструментами проектирования. Стоимость
  лицензии может быть высокой, что делает его доступным в основном для крупных
  компаний.

- *AnyLogic*: Универсальная платформа для моделирования систем. Подходит для
  моделирования сложных процессов, но не предназначена для генерации HDL. Широко
  используется в бизнесе и науке. Стоимость варьируется в зависимости от версии.

- *MATLAB Simulink*: Мощный инструмент для моделирования и симуляции систем.
  Поддерживает генерацию HDL через дополнительные модули. Хорошо интегрируется с
  другими инструментами MATLAB. Стоимость лицензии высокая, но инструмент
  популярен в академической и инженерной среде.

- *LabVIEW*: Инструмент для визуального программирования и моделирования.
  Подходит для управления оборудованием и симуляции. Генерация HDL возможна через
  дополнительные модули. Стоимость лицензии высокая, но инструмент широко
  используется в промышленности.

- *Engage*: Инструмент для моделирования и симуляции, ориентированный на
  промышленное применение. Поддерживает интеграцию с существующими системами, но
  не предназначен для генерации HDL. Доступность и стоимость зависят от региона и
  версии.

- *Quartus Prime*: Инструмент от Intel для проектирования FPGA. Поддерживает
  генерацию HDL и интеграцию с аппаратными платформами. Бесплатная версия
  доступна, но с ограничениями. Популярен среди разработчиков FPGA.

- *Vivado*: Инструмент от Xilinx для проектирования FPGA. Поддерживает
  генерацию HDL и интеграцию с аппаратными платформами. Бесплатная версия
  доступна, но с ограничениями. Широко используется в индустрии.

- *Verilator*: Бесплатный инструмент с открытым исходным кодом для симуляции
  Verilog. Не поддерживает VHDL. Подходит для высокопроизводительных симуляций, но
  требует знаний программирования.

- *Icarus Verilog*: Бесплатный инструмент для симуляции Verilog. Подходит для
  небольших проектов и обучения. Ограничен в функциональности по сравнению с
  коммерческими решениями.

Каждое из этих решений имеет свои особенности, и выбор зависит от требований
проекта, бюджета и уровня интеграции с существующими системами.

=== Передаточные функции

=== Передаточные функции

Передаточные функции являются мощным инструментом для моделирования приборов и
систем. Они позволяют описывать динамическое поведение системы в частотной
области, что упрощает анализ и проектирование. Основные качества подхода с
использованием передаточных функций включают:

- *Простота*: Передаточные функции предоставляют компактное и удобное
  представление системы в виде алгебраического выражения. Это упрощает анализ,
  особенно для линейных систем, где можно использовать стандартные методы, такие
  как преобразование Лапласа.

- *Точность*: При правильной настройке передаточные функции могут точно
  описывать поведение системы в определенных условиях. Однако точность зависит от
  уровня абстракции и предположений, сделанных при создании модели.

- *Границы применимости*: Передаточные функции наиболее эффективны для линейных
  стационарных систем. Для нелинейных или нестационарных систем их применение
  ограничено, и может потребоваться использование других методов, таких как
  моделирование во временной области или численные методы.

Пример использования передаточных функций в контексте моделирования приборов:

+ *Определение модели*: Определите входные и выходные параметры системы, а также
  динамические свойства, такие как инерция, демпфирование и усиление.
+ *Построение передаточной функции*: Используйте уравнения системы для получения
  передаточной функции, например, в виде отношения полиномов.
+ *Анализ и симуляция*: Используйте передаточную функцию для анализа
  устойчивости, частотных характеристик и переходных процессов. Для симуляции
  можно использовать инструменты, такие как MATLAB Simulink или Python с
  библиотекой Control.

Таким образом, подход с использованием передаточных функций является мощным и
удобным инструментом для моделирования приборов, особенно в случаях, когда
система может быть представлена в линейной форме.

=== Точное моделирование

// Icarus Verilog, Verilator, Quartus, Vivado,...
// Qucks(?)

- *Icarus Verilog*: Бесплатный инструмент для симуляции Verilog. Подходит для
  небольших проектов и обучения. Ограничен в функциональности по сравнению с
  коммерческими решениями.
- *Verilator*: Бесплатный инструмент с открытым исходным кодом для симуляции
  Verilog. Подходит для высокопроизводительных симуляций, но требует знаний
  программирования.
- *Quartus Prime*: Инструмент от Intel для проектирования FPGA. Поддерживает
  генерацию HDL и интеграцию с аппаратными платформами. Бесплатная версия
  доступна, но с ограничениями.
- *Vivado*: Инструмент от Xilinx для проектирования FPGA. Поддерживает генерацию
  HDL и интеграцию с аппаратными платформами. Бесплатная версия доступна, но с
  ограничениями.
- *ModelSim*: Популярный инструмент для симуляции цифровых схем. Поддерживает
  Verilog, VHDL и SystemVerilog. Обладает высокой точностью моделирования и
  возможностью интеграции с другими инструментами проектирования.
- *MATLAB Simulink*: Мощный инструмент для моделирования и симуляции систем.
  Поддерживает генерацию HDL через дополнительные модули.
- *LabVIEW*: Инструмент для визуального программирования и моделирования.
  Подходит для управления оборудованием и симуляции. Генерация HDL возможна через
  дополнительные модули.

Каждое из этих решений имеет свои особенности, и выбор подходящего инструмента
зависит от требований проекта, уровня интеграции с существующими системами и
бюджета.

Arcilator

Arcilator - это инструмент в составе проекта CIRCT, предназначенный для
анализа и оптимизации цифровых схем. Он предоставляет возможности для
трансформации и проверки схем, описанных на различных уровнях абстракции.
Arcilator использует мощь MLIR для создания модульного и расширяемого
подхода к проектированию цифровых систем. Основные функции включают:

- *Анализ*: Проверка корректности схем и выявление потенциальных ошибок.
- *Оптимизация*: Улучшение производительности и уменьшение размера схем.
- *Интеграция*: Возможность взаимодействия с другими инструментами CIRCT.

Arcilator является важным компонентом экосистемы CIRCT, предоставляя
разработчикам мощные инструменты для работы с цифровыми схемами.


== Способы интеграции с нативным кодом

// === JNI
// === IPC
// === Kotlin/Native
// === FFM API
// ==== Описание

// ==== Использование FFM API

// - Jextract
// - Прямое использование FFM API
// - Собственные обертки FFM API
// - Проект Java Native Memory Access

Интеграция с нативным кодом из Kotlin/JVM может быть выполнена различными
способами, в зависимости от требований проекта и используемых технологий.
Рассмотрим основные подходы:

=== JNI (Java Native Interface)

JNI предоставляет стандартный способ взаимодействия между Java (и Kotlin/JVM) и
нативным кодом, написанным на C или C++. Этот подход позволяет вызывать нативные
функции из JVM и наоборот.

- *Преимущества*:
  - Широкая поддержка и документация.
  - Возможность работы с любыми библиотеками на C/C++.
- *Недостатки*:
  - Сложность написания и отладки кода.
  - Требует ручного управления памятью.

=== IPC (Inter-Process Communication)

IPC используется для взаимодействия между процессами, когда нативный код
выполняется в отдельном процессе. Это может быть полезно для повышения
безопасности и изоляции.

- *Преимущества*:
  - Изоляция процессов повышает стабильность.
  - Подходит для взаимодействия с нативными сервисами.
- *Недостатки*:
  - Более высокая задержка из-за межпроцессного взаимодействия.
  - Сложность настройки.

=== Kotlin/Native

Kotlin/Native позволяет компилировать Kotlin-код в нативный бинарный код, что
упрощает взаимодействие с нативными библиотеками. Это особенно полезно для
мультиплатформенных проектов.

- *Преимущества*:
  - Естественная интеграция с Kotlin.
  - Поддержка мультиплатформенности.
- *Недостатки*:
  - Ограниченная поддержка JVM-специфичных функций.
  - Требует использования Kotlin/Native runtime.

=== FFM API (Foreign Function & Memory API)

FFM API — это современный способ взаимодействия с нативным кодом,
предоставляемый в Java. Он позволяет работать с нативной памятью и вызывать
нативные функции без использования JNI.

- *Преимущества*:
  - Высокая производительность.
  - Упрощенная работа с нативной памятью.
- *Недостатки*:
  - Требует использования последних версий Java.
  - API находится в стадии разработки.

==== Использование FFM API

- *Jextract*: Инструмент для автоматической генерации Java-оберток для нативных
  библиотек.
- *Прямое использование FFM API*: Позволяет вручную вызывать нативные функции и
  управлять памятью.
- *Собственные обертки FFM API*: Создание высокоуровневых оберток для упрощения
  работы.
- *Проект Java Native Memory Access*: Расширяет возможности работы с нативной
  памятью.

Каждый из этих подходов имеет свои особенности, и выбор зависит от требований
проекта, уровня производительности и сложности интеграции.

= Проектирование решения
== Требования к проекту

Промежуточное представление

Отдельный проект, Kotlin классы

Обзор выбранных технологий


= Обзор разработанного решения
== Архитектура проекта

диаграмма размещения
диаграмма классов, 
диаграмма последовательности взаимодействия с моделью
мультиплатформа

== Процесс компиляции

конфигурация,

pipeline, описание этапов

скрин `gradle :run`

== Процесс генерации кода

библиотека для генерации кода

== Использование модели

проблема с Arena.ofConfined, фикс Arena.ofShared

пример с Controls

тестирование

= Анализ результатов

== Сравнение с другими решениями
== Способы применения
== Перспективы развития

// #struct
= ЗАКЛЮЧЕНИЕ

// #struct
= СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ

// #struct
= ПРИЛОЖЕНИЕ
