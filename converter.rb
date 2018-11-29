def convert(changeColor)
	files = Dir["*.xml"]

	files.each { |fileName| 
		content = File.read(fileName)

		newContent = content
			.gsub("vector", "svg")
			.gsub("xmlns:android=\"http://schemas.android.com/apk/res/android\"", "xmlns=\"http://www.w3.org/2000/svg\"")
			.gsub("android:width", "width")
			.gsub("android:height", "height")
			.gsub("dp", "")
			.gsub("android:fillColor", "fill")
			.gsub("android:pathData", "d")
			.gsub("group", "g")
			.gsub("android:fillType", "fill-rule")
			.gsub("android:name", "id")
		
		if 	changeColor == "true"

			newContent = newContent
				.gsub("ffffff", "000000")
				.gsub("fff", "000")
				.gsub("FFFFFF", "000000")
				.gsub("FFF", "000")

			puts changeColor
		end

		firstIndex = newContent.index("android:viewportWidth=")
		lastIndex = newContent.index("\">")
		viewPortString = newContent[firstIndex..lastIndex]
		widthString = viewPortString.gsub("android:viewportWidth=\"", "")
		toIndexWidth = widthString.index("\"")
		width = widthString[0..(toIndexWidth - 1)]

		heigthPortString = widthString[toIndexWidth, viewPortString.length]
		heightString = heigthPortString.gsub("android:viewportHeight=\"", "")
		toIndexHeight = heightString.index("\"")
		height = heightString[0..(toIndexHeight - 1)].gsub("\"", "").strip
		
		removeContent = newContent[firstIndex..lastIndex]

		content = newContent.gsub(removeContent, "").insert(firstIndex, "viewBox=\"0 0 " + width + " " + height + "\"")
		
		newFileName = fileName.gsub(".xml", ".svg")
		File.open(newFileName, "w") { |file|
			file.puts(content)
		}
	}
end

convert(ARGV[0])