## Search

Wallaby offers very complicated colon search functionality for Active Record (e.g. similar to site colon Google search, it is possible to do field colon search like `published_at:>2018-01-31`). It breaks into the following sections:

- [Simple Keyword Search](#simple-keyword-search)
  - [Use Quotes in Keywords](#use-quotes-in-keywords)
- [Field Colon Search](#simple-field-colon-search)
  - [Use Quotes in Field Colon](#use-quotes-in-field-colon)
  - [Use Comma as Divider](#use-comma-as-divider)
  - [Equal/Not-Equal Colons](#equal-colons)
  - [Match Colons](#match-colons)
    - [Contain](#contain-colon)
    - [Start With](#start-with-colon)
    - [End With](#end-with-colon)
  - [Between/Not Colons](#between-colons)

### Simple Keyword Search

Keyword search will be as simple as below:

```
reInteractive OpsCare contact
```

In this example, Wallaby will search three keywords `reInteractive`, `OpsCare` and `contact` (separated by white space) among all the `string` and `text` fields and see if any value contains those three keywords at the same time.

#### Use Quotes in Keywords

Keywords can be quoted for exact match:

```
reInteractive OpsCare 'email contact'
```

In this example, Wallaby will search these keywords `reInteractive`, `OpsCare`, and `email contact`.

> NOTE: either single quotes or double quotes can be used, but the text has to be closed by the quote same as opening quote.

### Field Colon Search

Similar to site colon used on Google Search, end-users can do field colon search. Field colon starts with field name (it's column name for ActiveRecord), followed by a colon operator, ending with value(s):

```
published_at:>2018-01-31 type:general,special discount:<10
```

Let's review the usage of quotes in field colon.

#### Use Quotes in Field Colon

Similar to [Use Quotes in Keywords](#use-quotes-in-keywords), a value can be quoted:

```
name:'lamb salad'
```

to do an exact match of `lamb salad` for field `name`

#### Equal Colons

Equal colons are `:` and `:=`, and they allows end-user to do exact match like:

```
name:salad promotion:=lite,easy
```

In this example, Wallaby will try to return records that `name` equals to `salad` and promo

#### Not-Equal Colons

Not-equal colons are `:!`, `:!=` and `:<>`. They are used to exclude the values
