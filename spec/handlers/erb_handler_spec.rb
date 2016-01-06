require "spec_helper"

describe AwesomeTranslations::Handlers::ErbHandler do
  let(:handler) { AwesomeTranslations::Handlers::ErbHandler.new }
  let(:users_index_group) { handler.groups.find { |group| group.name == "app/views/users/index.html.haml" } }
  let(:users_index_translations) { users_index_group.translations }
  let(:users_partial_test_translations) { handler.groups.find { |group| group.name == "app/views/users/_partial_test.html.haml" }.translations }
  let(:layout_group) { handler.groups.find { |group| group.name == "app/views/layouts/application.html.haml" } }
  let(:layout_translations) { layout_group.translations }

  it "finds translations made with the t method" do
    hello_world_translations = users_index_translations.select { |t| t.key == "users.index.hello_world" }.to_a
    expect(hello_world_translations.length).to eq 1
  end

  it "finds translations in the layout" do
    danish_translations = layout_translations.select { |t| t.key == "layouts.application.danish" }.to_a
    expect(danish_translations.length).to eq 1
  end

  it "doesnt include _ in partial keys" do
    partial_test = users_partial_test_translations.select { |t| t.key == "users.partial_test.partial_test" }.to_a
    expect(partial_test.length).to eq 1
  end

  it "removes special characters when using the custom method" do
    current_language_translation = layout_translations.select { |t| t.key == "layouts.application.the_current_language_is" }.to_a
    expect(current_language_translation.length).to eq 1
  end

  it "has unique translations" do
    expect(layout_translations.select { |t| t.key == "layouts.application.hello_world" }.to_a.length).to eq 1
  end

  it "sets the correct translation path" do
    danish_translation = layout_translations.find { |t| t.key == "layouts.application.danish" }
    expect(danish_translation.dir).to eq "#{Rails.root}/config/locales/awesome_translations/app/views/layouts/application"
  end
end
