# Formtastic input that renders a Trix WYSIWYG editor bound to a regular
# text column. Stores HTML directly in the underlying attribute (no
# Action Text storage required).
#
# Usage in an Active Admin form:
#   f.input :context, as: :trix
class TrixInput < Formtastic::Inputs::StringInput
  def to_html
    input_wrapping do
      label_html <<
        builder.hidden_field(method, id: hidden_field_id, value: object.send(method).to_s) <<
        template.content_tag(:"trix-editor", "", input: hidden_field_id, class: "trix-content")
    end
  end

  private

  def hidden_field_id
    "#{object_name}_#{method}_input"
  end
end
