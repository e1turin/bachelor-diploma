#let title_page(
  title: str,
  author: str
) = {
  align(center)[
    #v(10cm)
    #text(24pt, weight: "bold")[#title]
    #v(1cm)
    #author
  ]

  // pagebreak()
}

#let GOST_7_32__2017(
  title: str,
  author: str,
  doc,
) = {

  set document(
    title: title,
    author: author,
  )

  /* 4.2 */
  set page(paper: "a4")

  set text(
    font: "Times New Roman",
    size: 14pt,
    spacing: 150%,
    lang: "ru",
  )

  set par(
    first-line-indent: (
      amount: 1.25cm,
      all: true,
    ),
    justify: true,
    spacing: 1em,
  )

  show heading.where(depth: 2): it => {
    block(inset: (left: 1.25cm), it)
  }

  set figure.caption(separator: [ --- ])

  /* 4.5 Images */
  show figure.where(kind: image): set figure(supplement: "Рисунок")

  /* 4.6 Tables */
  show figure.where(kind: table): set figure(supplement: "Таблица")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(kind: table): it => [
    #align(left)[#it]
  ]

  set list(marker: [---])
  set enum(numbering: "1)")

  title_page(
    title: title,
    author: author
  )

  /* 4.2 (avoid title page) */
  set page(
    margin: (
      left: 30mm,
      right: 15mm,
      top: 20mm,
      bottom: 20mm,
    ),
    numbering: "1",
  )

  /* 4.3 */
  counter(page).update(2)
  set heading(numbering: "1.1")

  doc
}

#let struct(name, outlined: true) = {
  /* 4.4 */
  pagebreak()
  align(center)[
    #heading(
      numbering: none,
      outlined: outlined,
    )[#upper(name)]
  ]
  v(1em)
}

#let chapter(name) = {
  /* 4.4.2 */
  pagebreak()
  align(center)[#heading[#name]]
}

#let definition(name, definition) = {
  /* 4.9 */
  par(
    first-line-indent: (
      amount: 0em,
    ),
  )[#name --- #definition]
}

