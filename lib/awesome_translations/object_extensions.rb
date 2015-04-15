module AwesomeTranslations::ObjectExtensions
  def t(key, *args, &blk)
    if key.is_a?(String) && key.start_with?(".")
      # Removed any helpful appended input to filepath from stacktrace.
      if match = caller[0].match(/\A(.+):(\d+):/)
        previous_file = match[1]
      else
        raise "Could not get previous file name from: #{caller[0]}"
      end

      # Remove any Rails root.
      removed_root = false
      AwesomeTranslations::ModelInspector.engines.each do |engine|
        root = engine.root.to_s

        if previous_file.starts_with?(root)
          previous_file = previous_file.gsub(/\A#{Regexp.escape(root)}\//, "")
          removed_root = true
          break
        end
      end

      dir = File.dirname(previous_file)
      file = File.basename(previous_file, File.extname(previous_file))

      translation_key = dir
      translation_key = translation_key.gsub(/\Aapp\//, "")
      translation_key << "/#{file}"
      translation_key.gsub!("/", ".")
      translation_key << key

      # Change key to full path.
      key = translation_key
    end

    I18n.t(key, *args, &blk)
  end
end
