module Liquid

  # Capture stores the result of a block into a variable without rendering it inplace.
  #
  #   {% capture heading %}
  #     Monkeys!
  #   {% endcapture %}
  #   ...
  #   <h1>{{ heading }}</h1>
  #
  # Capture is useful for saving content for use later in your template, such as
  # in a sidebar or footer.
  #
  class Capture < Block
    Syntax = /(\w+)/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @to = $1
      else
        raise SyntaxError.new(options[:locale].t("errors.syntax.capture"))
      end

      super
    end

    def render(context)
      output = super
      context.scopes.last[@to] = output
      context.increment_used_resources(:assign_score_current, output)
      ''
    end

    def blank?
      true
    end
  end

  Template.register_tag('capture', Capture)
end
