module FormFu

  # A form builder that produces tableless, lined-up forms.
  class FormBuilder < ActionView::Helpers::FormBuilder
    # automatically wrap all the standard formbuilder helpers
     (field_helpers - %w(label radio_button hidden_field text_area)).each do |selector|
      src = <<-END_SRC
        def #{selector}(field, options = {}, &block)
          format_with_label(field, options.merge(:field_type => "#{selector}"), super(field, purge_custom_tags(options)), &block)
        end
      END_SRC
      class_eval src, __FILE__, __LINE__
    end

    def text_area(field, options = {}, &block)
      format_with_label(field, options.merge(:field_type => "text_area", :preserve => true), super(field, purge_custom_tags(options)), &block)
    end

    # wrap the date_select helper
    def date_select(field, options={}, &block)
      format_with_label(field, options.merge(:field_type => "date"), super(field, purge_custom_tags(options)), &block)
    end

    # create a radio group helper that works very similarly to the select helper
    def radio_group(field, choices, options={}, &block)  

      # handle special cases
      if choices == :boolean
        choices = [["True", "true"], ["False", "false"]]
      elsif choices == :yes_no
        choices = [["Yes", "yes"], ["No", "no"]]
      elsif choices.class != Array
        choices = []
      end
      
      # build radio choices html 
      choices_html = ""
      choices.each do |key, value|
        radio_html = radio_button(field, value)+key
        
        # wrap radio html in a label (for easier selection)
        choices_html << content_tag(:label, radio_html, :class => "radio-option")
      end
      
      # wrap the radio-group with a label
      format_with_label(field, options.merge(:field_type => "radio-group"), choices_html, &block)
    end

    # wrap the select helper
    def select(field, choices, options={}, &block)
      html_options = options.delete(:html) || {}
      format_with_label(field, options.merge(:field_type => "select"), super(field, choices, options, html_options), &block)
    end

    # create a submit helper
    def submit(value = "Submit", options = {})
      @template.submit_tag(value, options)
    end

    # create a image_submit helper
    def image_submit(img_path, options = {})
      @template.image_submit_tag(img_path, options)
    end

    # create an error messages helper
    def error_messages(object_name = nil)
      @template.error_messages_for object_name || @object_name
    end

    private

    # format a helper by generating the haml to wrap it in a field_tag and include a label
    def format_with_label(field, options, tag_output, &block)
      # see if we have an error on the field
      errors_on = object.send(:errors).send(:on, field)
      has_error = true unless errors_on.blank?

      # set field options
      options[:field] ||= {}
      options[:field].merge!(:has_error => has_error, :field_type => options[:field_type])

      if options[:preserve]
        tag_output = @template.preserve(tag_output)
      end

      output_html = @template.field_tag(options[:field], [
          @template.label(@object_name, field, options[:label], :separator => options[:separator] || default_separator),
          tag_output,
          @template.validation_tag(@object, field),
          block_given? ? @template.capture(&block) : nil
      ].compact.join("\n"))

      Rails.logger.debug "OUTPUTING LABEL FORMAT:\n\n#{output_html}\n\n"
      
      if block_given?
        # concat to page if block was given
        return concat(output_html, block.binding)
      else
        # otherwise return html directly
       return output_html
      end
    end

    def default_separator
      ": "
    end

    # Removes tags such as :html, :label so they dont get rendered on the final html
    def purge_custom_tags(options)
      options.reject{ |key,value| [:label, :html, :field, :field_type, :separator].include?(key.to_sym) }
    end
  end
end