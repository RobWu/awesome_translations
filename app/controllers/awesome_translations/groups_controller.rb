class AwesomeTranslations::GroupsController < AwesomeTranslations::ApplicationController
  before_filter :set_handler
  before_filter :set_group

  def index
  end

  def show
    @translations = @group.translations
  end

  def update
    @handler.translations.each do |translation|
      next unless params[:t].key?(translation.key)

      values = params[:t][translation.key]
      values.each do |locale, value|
        translated_value = translation.translated_value_for_locale(locale)
        translated_value.value = value
        translated_value.save!
      end
    end

    render nothing: true
  end

private

  def set_handler
    @handler = AwesomeTranslations::Handler.find(params[:handler_id])
  end

  def set_group
    @group = AwesomeTranslations::Group.find_by_handler_and_id(@handler, params[:id])
  end
end
