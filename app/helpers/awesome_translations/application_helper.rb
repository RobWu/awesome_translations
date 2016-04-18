module ::AwesomeTranslations::ApplicationHelper
  include BootstrapBuilders::ApplicationHelper
  include SimpleFormRansackHelper

  def helper_t(key, args = {})
    AwesomeTranslations::GlobalTranslator.translate(key, helper: true, caller_number: 1, translation_args: [args])
  end

  def path_without_root(path)
    path.gsub(/\A#{Regexp.escape(Rails.root.to_s)}(\/|)/, "")
  end

  def path_without_root_or_locales(path)
    path_without_root(path).gsub(/\Aconfig\/locales(\/|)/, "")
  end
end
