module Wallaby
  # Model pagination provider interface
  class ModelPaginationProvider
    def initialize(collection, params, options: {}, model_decorator: nil)
      @collection = collection
      @params = params
      @options = options
      @model_decorator = model_decorator
    end

    def paginatable?
      raise NotImplemented
    end

    def first_page?
      page_number > first_page_number
    end

    def prev_page?
      page_number > first_page_number
    end

    def last_page?
      page_number < last_page_number
    end

    def next_page?
      page_number < last_page_number
    end

    def from
      (page_number - 1) * page_size + 1
    end

    def to
      [page_number * page_size, total].min
    end

    def total
      raise NotImplemented
    end

    def page_size
      raise NotImplemented
    end

    def page_number
      raise NotImplemented
    end

    def first_page_number
      1
    end

    def last_page_number
      number_of_pages
    end

    def prev_page_number
      [page_number - 1, first_page_number].max
    end

    def next_page_number
      [page_number + 1, last_page_number].min
    end

    def number_of_pages
      (total / page_size.to_f).ceil
    end
  end
end
