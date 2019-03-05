module Wallaby
  # Model pagination provider interface
  class ModelPaginationProvider
    # @param collection [#to_a]
    # @param params [ActionController::Parameters]
    # @param options [Hash] options
    # @param model_decorator [Wallaby::ModelDecorator, nil]
    def initialize(collection, params, options: {}, model_decorator: nil)
      @collection = collection
      @params = params
      @options = options
      @model_decorator = model_decorator
    end

    # If a collection has pagination feature
    # @return [Boolean]
    def paginatable?
      raise NotImplemented
    end

    # Check and see if it's the first page
    # @return [Boolean]
    def first_page?
      page_number > first_page_number
    end

    # Check and see if it's the previous page
    # @return [Boolean]
    def prev_page?
      page_number > first_page_number
    end

    # Check and see if it's the last page
    # @return [Boolean]
    def last_page?
      page_number < last_page_number
    end

    # Check and see if it's the next page
    # @return [Boolean]
    def next_page?
      page_number < last_page_number
    end

    # Find out the offset `from`
    # @return [Integer]
    def from
      total.zero? ? total : (page_number - 1) * page_size + 1
    end

    # Find out the offset `to`
    # @return [Integer]
    def to
      [page_number * page_size, total].min
    end

    # Find out the total count of current query
    # @return [Integer]
    def total
      raise NotImplemented
    end

    # Find out the current page size
    # @return [Integer]
    def page_size
      raise NotImplemented
    end

    # Find out the current page number
    # @return [Integer]
    def page_number
      raise NotImplemented
    end

    # Page number of first page
    # @return [Integer]
    def first_page_number
      1
    end

    # Page number of last page
    # @return [Integer]
    def last_page_number
      number_of_pages
    end

    # Page number of previous page
    # @return [Integer]
    def prev_page_number
      [page_number - 1, first_page_number].max
    end

    # Page number of next page
    # @return [Integer]
    def next_page_number
      [page_number + 1, last_page_number].min
    end

    # Total number of pages
    # @return [Integer]
    def number_of_pages
      (total / page_size.to_f).ceil
    end
  end
end
