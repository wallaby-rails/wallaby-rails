# frozen_string_literal: true

module Wallaby
  # A parser to parse colon query string and return a hash for transformer
  # to consume
  class Parser < Parslet::Parser
    # @!method parse(str)
    # Parse string into Abstract Syntax Tree for transformer to consume
    # @param str [String]
    # @return [Hash] Abstract Syntax Tree

    # Case insensitive string match
    # @param str [String]
    def stri(str)
      str.chars.map! { |c| match["#{c.upcase}#{c.downcase}"] }.reduce :>>
    end

    root(:statement)
    rule(:statement) { expression >> (spaces >> expression).repeat }
    rule(:expression) { colon_query | quoted_string | string | any.repeat(0).as(:null) }
    rule(:colon_query) do
      name.as(:left) >> operator.as(:op) >> values.as(:right)
    end

    # colon query
    begin
      # name starts with letter
      rule(:name) { letter >> ((colon | spaces).absent? >> any).repeat }

      # operator starts with colon
      rule(:operator) do
        colon >> (
          (colon | spaces | quote | comma | digit | letter).absent? >> any
        ).repeat(0, 3)
      end

      # values separated by comma
      rule(:values) { value >> (comma >> value).repeat }
      rule(:value) { quoted_string | data }
      rule(:data) do
        null.as(:null) | boolean.as(:boolean) |
          (spaces.absent? >> comma.absent? >> any).repeat.as(:string)
      end
    end

    # basic elements
    rule(:quoted_string) do
      open_quote >>
        (close_quote.absent? >> any).repeat.as(:string) >>
        close_quote
    end
    rule(:string) { (spaces.absent? >> any).repeat(1).as(:string) }

    # atomic entities
    rule(:null) { stri('nil') | stri('null') }
    rule(:boolean) { stri('true') | stri('false') }
    rule(:letter) { match['a-zA-Z'] }
    rule(:digit) { match['0-9'] }
    rule(:dot) { str('.') }
    rule(:comma) { str(',') }
    rule(:spaces) { match['\s'].repeat(1) }
    rule(:colon) { str(':') }
    rule(:quote) { match['\'\"'] }

    # open-close elements
    rule(:open_quote) { quote.capture(:quoting) }
    rule(:close_quote) { dynamic { |_src, ctx| str(ctx.captures[:quoting]) } }
  end
end
