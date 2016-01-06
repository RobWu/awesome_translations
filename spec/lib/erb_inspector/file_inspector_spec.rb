require "spec_helper"

describe AwesomeTranslations::ErbInspector::FileInspector do
  let(:erb_inspector) do
    AwesomeTranslations::ErbInspector.new(
      dirs: [Rails.root.to_s]
    )
  end

  let(:files) { erb_inspector.files.to_a }
  let(:file_paths) { files.map { |file| file.file_path } }
  let(:user_index_inspector) { files.select { |file_inspector| file_inspector.file_path == "app/views/users/index.html.haml" }.first }
  let(:user_index_translations) { user_index_inspector.translations.to_a }
  let(:hello_world_translation) { user_index_translations.select { |translation| translation.key == ".hello_world" }.first }

  describe "#translations" do
    it "finds the right number of translations" do
      expect(user_index_translations.length).to eq 3
    end
  end
end
