# Search

Wallaby offers very complicated colon search functionality for ActiveRecord (e.g. similar to site colon Google search `site:reinteractive.com`, it is possible to do field colon search like `published_at:>2018-01-31`). Please see the following sections:

- [Simple Keyword Search](#simple-keyword-search)
  - [Use Quotes in Keywords](#use-quotes-in-keywords)
- [Field Colon Search](#simple-field-colon-search)
  - [Use Quotes in Field Colon](#use-quotes-in-field-colon)
  - [Use Comma as Divider](#use-comma-as-divider)
  - [Equal/Not Colons (`:`, `:=`, `:!`, `:!=`, `:<>`)](#equalnot-colons)
  - [Match Colons](#match-colons)
    - [Contain/Not (`:~`, `:!~`)](#containnot)
    - [Start-with/Not (`:^`, `:!^`)](#start-withnot)
    - [End-with/Not (`:$`, `:!$`)](#end-withnot)
  - [Compare Colons](#compare-colons)
    - [Larger Than (`:>`, `:>=`)](#larger-than)
    - [Less Than (`:<`, `:<=`)](#less-than)
  - [In/Not Colons (`:`, `:=`, `:!`, `:!=`, `:<>`)](#innot-colons)
  - [Between/Not Colons (`:()`, `:!()`)](#betweennot-colons)

## Simple Keyword Search

Keyword search will be as simple as below:

```
reInteractive OpsCare contact
```

The keywords passed to Wallaby will be `reInteractive`, `OpsCare` and `contact` (separated by white space).
Then, Wallaby will search these three keywords among only the `string` and `text` fields shown on the `index` page and see if any of these fields have value that contains all these three keywords.

### Use Quotes in Keywords

If a keyword has space in it, it can be quoted:

```
reInteractive OpsCare 'email contact'
```

In this example, keywords will be `reInteractive`, `OpsCare`, and `email contact`.

> NOTE: either single quotes or double quotes can be used, but the value has to be closed by the same quote as opening quote.

## Field Colon Search

Similar to site colon used on Google Search, end-users can do field colon search. Field colon starts with field name (it's column name for ActiveRecord), followed by a colon operator, ending with value(s):

In pseudo code, it would be:

```
field colon_operator value[,value]
```

For example:

```
published_at:>2018-01-31 type:general,special discount:<10
```

In this example, `published_at`, `type` and `discount` are the fields. `:>`, `:` and `:<` are colon operators. `2018-01-31` and `10` are the simple value. and `general,special` is the compound values.

The colon expression means search records that `published_at` is after `2018-01-31`, type is either `general` or `special`, and `discount` is less than `10`.

### Use Quotes in Field Colon

Let's review the usage of quotes in field colon. Similar to [Use Quotes in Keywords](#use-quotes-in-keywords), if a value has space in it, it can be quoted as below example:

```
name:'lamb salad'
```

This colon expression means to do an exact match of `lamb salad` for field `name`

> NOTE: either single quotes or double quotes can be used, but the value has to be closed by the same quote as opening quote.

### Use Comma as Divider

In sequence operations, it is possible to pass a list of values divided by comma to the operator. For example:

```
type:general,special
```

This colon expression means if value of `type` is either `general` or `special`.

### Equal/Not-Equal Colons

**Equal** colon operators are `:` and `:=`, and they allows end-user to do exact match like:

```
name:salad promotion:=lite
```

This colon expression means to do an exact match of `salad` for field `name` and `lite` for field `promotion`

**Not-equal** colon operators are `:!`, `:!=` and `:<>`. They are used to exclude the value

```
name:!salad promotion:!=lite date:<>2018-01-31
```

This colon expression means field `name` doesn't not eqaul to `salad`, `promotion` not equal to `lite`, and `date` not equal to `2018-01-31`.

### Match Colons

Useful operators for text search.

#### Contain/Not

**Contain** colon operator is `:~`. It can be used to search string/text and see whether the filed contain the value.

```
name:~salad
```

This colon expression means `name` contains `salad`.

**Not-contain** colon operator is `:!~`. It can be used to exclude the records that contain the value.

```
name:!~salad
```

This colon expression means `name` doesn't contain `salad`.

#### Start-with/Not

**Start-with** colon operator is `:^`. It can be used to match string/text that starts with given value.

```
name:^first_name
```

This colon expression means `name` starts with `first_name`.

**Not-start-with** colon operator is `:!^`. It can be used to exclude the records that start with the value.

```
name:!^first_name
```

This colon expression means `name` doesn't start with `first_name`.

#### End-with/Not

**End-with** colon operator is `:^`. It can be used to match string/text that ends with given value.

```
name:^first_name
```

This colon expression means `name` ends with `first_name`.

**Not-end-with** colon operator is `:!^`. It can be used to exclude the records that end with the value.

```
name:!^first_name
```

This colon expression means `name` doesn't end with `first_name`.

### Compare Colons

Colon operators for comparison.

#### Larger Than

**Larger than** colon operator is `:>`. It can be used to match records that are larger than given value.

```
date:>2018-01-31
```

This colon expression means `date` is after `2018-01-31`.

**Larger than or equal** colon operator is `:>=`. It can be used to match records that are larger than or equal to given value.

```
date:>=2018-01-31
```

This colon expression means `date` is on or after `2018-01-31`.

#### Less Than

**Less than** colon operator is `:<`. It can be used to match records that are less than given value.

```
date:<2018-01-31
```

This colon expression means `date` is before `2018-01-31`.

**Less than or equal** colon operator is `:<=`. It can be used to match records that are less than or equal to given value.

```
date:<=2018-01-31
```

This colon expression means `date` is on or before `2018-01-31`.

### In/Not Colons

**In** colon operators are `:` and `:=`. It can be used to check if the value is one of the inclusion (comma-separated values):

```
type:general,special weekday:mon,tue
```

This colon expression means to that `type` is either `general` or `special` and `weekday` is either `mon` or `tue`.

**Not-in** colon operators are `:!`, `:!=` and `:<>`. It can be used to check if the value is not one of the inclusion (comma-separated values):

```
type:general,special weekday:mon,tue country:<>aus,nzl
```

This colon expression means to that `type` is neither `general` or `special`, `weekday` is neither `mon` or `tue` and `country` is neither `aus` or `nzl`.

### Between/Not Colons

**Between** colon operator is `:()`. It can be used to check if the value is betwee A and B:

```
amount:()1,1000
```

This colon expression means to that `amount` is between `1` and `1000`.

**Not-Between** colon operator is `:!()`. It can be used to check if the value is not between A and B:

```
amount:!()1,1000
```

This colon expression means to that `amount` is not between `1` and `1000`.

