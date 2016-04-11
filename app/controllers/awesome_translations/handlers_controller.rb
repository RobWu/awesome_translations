class AwesomeTranslations::HandlersController < AwesomeTranslations::ApplicationController
  before_action :set_handler, only: [:show, :update_groups_cache]

  def index
    @handlers = AwesomeTranslations::CacheDatabaseGenerator::Handler.order(:name)
  end

  def update_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers

    redirect_to :back
  end

  def update_groups_cache
    generator = AwesomeTranslations::CacheDatabaseGenerator.current
    generator.update_handlers do |handler_model|
      next unless handler_model.identifier == @handler.identifier
      generator.update_groups_for_handler(handler_model)
    end

    redirect_to :back
  end

  def show
    if params[:q]
      @ransack_values = params[:q]
    else
      @ransack_values = {
        with_translations: "only_with"
      }
    end

    @ransack = @handler
      .groups
      .ransack(@ransack_values)

    @groups = @ransack
      .result
      .includes(handler_translations: :translation_key)
      .order(:name)

    case @ransack_values[:with_translations]
    when "only_with"
      @groups = @groups.select { |group| group.handler_translations.any? }
    when "only_without"
      @groups = @groups.select { |group| group.handler_translations.empty? }
    end
  end

private

  def set_handler
    @handler = AwesomeTranslations::CacheDatabaseGenerator::Handler.find_by(identifier: params[:id])
    raise "No such handler: #{params[:id]}" unless @handler
  end
end
