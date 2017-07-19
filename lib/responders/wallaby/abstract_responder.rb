module Wallaby
  # abstract responder for later usage
  class AbstractResponder < ActionController::Responder
    include ::Responders::FlashResponder

    def to_html
      # @see FlashResponder
      set_flash_message! if set_flash_message?

      if post? then create_action
      elsif put? || patch? then update_action
      elsif delete? then destroy_action
      else default_render
      end
    end

    private

    def create_action
      if has_errors?
        render :new
      else
        redirect_to resource_location
      end
    end

    def update_action
      if has_errors?
        render :edit
      else
        redirect_to resource_location
      end
    end

    def destroy_action
      redirect_to resource_location
    end
  end
end
