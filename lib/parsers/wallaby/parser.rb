module Wallaby
  # a parser to handle colon query
  class Parser < Parslet::Parser
    root(:statement)
    rule(:statement) { expression >> (space >> expression).repeat }
    rule(:expression) { colon_query | general_keyword }
    rule(:colon_query) do
      name.as(:left) >> operator.as(:op) >> keywords.as(:right)
    end
    rule(:name) { (space.absent? >> colon.absent? >> any).repeat(1) }
    rule(:operator) { colon >> match('[^\s\'\"\:\,0-9a-zA-Z]').repeat(0, 3) }
    rule(:keywords) { general_keyword >> (comma >> general_keyword).repeat }
    rule(:general_keyword) { quoted_keyword | keyword }

    # basic elements
    rule(:quoted_keyword) do
      open_quote >>
        (close_quote.absent? >> any).repeat.as(:keyword) >>
        close_quote
    end
    rule(:keyword) { ((space | comma).absent? >> any).repeat.as(:keyword) }

    # atomic entities
    rule(:comma) { str(',') }
    rule(:space) { match('\s').repeat(1) }
    rule(:colon) { str(':') }

    # open-close elements
    rule(:open_quote) { match('[\'\"]').capture(:quote) }
    rule(:close_quote) { dynamic { |_src, ctx| str(ctx.captures[:quote]) } }
  end
end
