# Restoring scroll position

## Scenario
- Form automatically submits when any value changes.
- After submission, it redirects back to the edit view.
- We want to restore the scroll position.

## Model

Add a virtual field for the scroll position.

```rb
class FieldPathMapping < ApplicationRecord
  attr_accessor :scroll
  # ...
```

## Form in the edit view

```slim
= simple_form_for(@field_path_mapping) do |f|
  = f.error_notification

  .form-inputs
    -# ...
    = f.input :scroll, as: :hidden, input_html: { :value => "0" }
    -# ...

  javascript:
    $('form.edit_field_path_mapping select').on('change', function() {
        setCurrentScrollPosition();
        $('form.edit_field_path_mapping').submit();
    });

    function setCurrentScrollPosition() {
        $('.field_path_mapping_scroll input').val($(window).scrollTop());
    }
```


## Controller

Add the scroll field to the whitelist of the strong parameter.

```rb
# Never trust parameters from the scary internet, only allow the white list through.
def field_path_mapping_params
  permit = [
    # ...
    :scroll,
    # ...
  ]
  params.require(:field_path_mapping).permit(*permit)
end
```

Redirect with the scroll position.

```rb
def update
  if @field_path_mapping.update(field_path_mapping_params)
      flash[:success] = 'Field path mapping was successfully updated.'
      redirect_to edit_field_path_mapping_path(scroll: params[:field_path_mapping][:scroll])
  else
    render :edit
  end
end
```

## Edit view

```slim
= render 'form'

javascript:
  // Restore the scroll position before form submission.
  $(document).on('turbolinks:load', function() {

      // Make sure that we apply this effect only for this page.
      if (location.pathname === '/field_path_mappings/1/edit') {
          $('body').scrollTop("#{@scroll}", 0);
      }
  })
```
