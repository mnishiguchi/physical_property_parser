# Physical property parser

In this repo, I will parse physical property XML feeds into Ruby representation and place it to PostgreSQL database.

---

## Environment

```
OSX
Ruby 2.3.1
Rails 5.0.0
```

---

## Models

![](erd/erd.jpg)

---

## Get started

```bash
rails db:create
rails db:migrate
rails db:seed
```

Visit localhost:3000

---

## Gems / Libraries

#### XML parsing witn Nokogiri
- [Nokogiri tutorials](http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html)
- [Nokogiri wiki](https://github.com/sparklemotion/nokogiri/wiki)
- [Nokogiri rubydoc](http://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Document)
- [Nokogiri Cheat-sheet](https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet)
