# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
  view :complete do
    transform CamelCaseTransformer

    fields :id,
           :email
  end
end
