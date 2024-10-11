module PlaceholderHelper
  extend ActiveSupport::Concern

  class_methods do
    def human_placeholder(attribute)
      I18n.t("activerecord.placeholders.#{model_name.i18n_key}.#{attribute}")
    end
  end
end
