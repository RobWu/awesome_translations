require "spec_helper"

describe AwesomeTranslations::TranslatedValue do
  let(:test_file_path){ "#{Dir.tmpdir}/da.yml" }

  let(:translated_value){
    described_class.new(
      file: test_file_path,
      key: "activerecord.attributes.test_model.test",
      locale: :da,
      value: "test"
    )
  }

  before do
    test_translations = {
      "da" => {
        "activerecord" => {
          "attributes" => {
            "test_model" => {
              "test" => "test",
              "other_translation" => "En anden"
            }
          }
        }
      }
    }

    File.open(test_file_path, "w") do |fp|
      fp.write(YAML.dump(test_translations))
    end
  end

  it "#save!" do
    translated_value.value = "new test"
    translated_value.save!

    translations = YAML.load(File.read(test_file_path))

    translations["da"]["activerecord"]["attributes"]["test_model"]["test"].should eq "new test"
    translations["da"]["activerecord"]["attributes"]["test_model"]["other_translation"].should eq "En anden"
  end
end
