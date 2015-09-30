# Transfers manual made translations also found in handlers over into the AwesomeTranslations namespace
class AwesomeTranslations::TranslationMigrator
  def initialize(args)
    require "fileutils"

    @handler_translation = args.fetch(:handler_translation)
    @translation_value = args.fetch(:translation_value)
    @translation_key = @handler_translation.translation_key

    @key_parts = @translation_key.key.split(".")

    @locale = @translation_value.locale

    @old_path = @translation_value.file_path
    @new_path = "#{@handler_translation.dir}/#{@translation_value.locale}.yml"
  end

  def execute
    remove_from_old_file
  end

private

  def remove_from_old_file
    translations_hash = YAML.load_file(@old_path)

    new_translations_hash = YAML.load_file(@new_path) if File.exist?(@new_path)
    new_translations_hash ||= {}
    new_translations_hash[@locale] ||= {}

    pointer = translations_hash.fetch(@locale)

    transfer_from_old_hash_to_new(
      new_translations_hash.fetch(@locale),
      @key_parts.clone,
      pointer
    )

    clean_empty_hash(translations_hash)

    FileUtils.mkdir_p(@handler_translation.dir)
    File.open(@new_path, "w") { |fp| fp.write(YAML.dump(new_translations_hash)) }
    File.unlink(@old_path) if translations_hash.empty?

    @translation_value.update_attributes!(file_path: @new_path)
  end

  def transfer_from_old_hash_to_new(new_hash, current_parts, current_pointer)
    new_part = current_parts.shift
    new_pointer = current_pointer.fetch(new_part)

    if current_parts.empty?
      new_hash[new_part] = current_pointer.delete(new_part)
    else
      new_hash[new_part] ||= {}
    end

    if new_pointer.is_a?(Hash)
      transfer_from_old_hash_to_new(
        new_hash.fetch(new_part),
        current_parts,
        new_pointer
      )
    end
  end

  # Cleans out empty keys, if they don't contain translations
  def clean_empty_hash(hash)
    all_empty = true

    hash.delete_if do |key, value|
      next unless value.is_a?(Hash)

      if value.empty?
        true
      else
        clean_empty_hash(value)

        if value.empty?
          true
        else
          all_empty = false
          false
        end
      end
    end
  end
end
