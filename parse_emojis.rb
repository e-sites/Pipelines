require 'json'
require 'net/http'

module Esites
  class ParseBuildkitEmojis
    attr_accessor :lines

    def run
      @lines = [ "\":mac:\": \"\"" ]

      url = 'https://raw.githubusercontent.com/buildkite/emojis/master/img-apple-64.json'
      uri = URI(url)
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)

      json.each { |element|
        name = element["name"].to_s
        unicode = element["unicode"].to_s
        add(name, unicode)
        element["modifiers"].each { |modifier|
          skintone_name = modifier["name"].to_s
          unicode = modifier["unicode"].to_s
          add("#{name}::#{skintone_name}", unicode)
        }
      }
      write_to_swift
    end

    def add(name, unicode)
      bytes = unicode.split("-").map { |str| str.hex }
      emoji = bytes.pack('U*')
      @lines << "\":#{name}:\": \"#{emoji}\""
    end

    def write_to_swift
      write_lines = []
      write_lines << "//"
      write_lines << "//  Emojis.swift"
      write_lines << "//  Pipelines"
      write_lines << "//"
      write_lines << "//  Created by Bas van Kuijck on 29/09/2017."
      write_lines << "//  Copyright © 2017 E-sites. All rights reserved."
      write_lines << "//"
      write_lines << ""
      write_lines << "import Foundation"
      write_lines << ""
      write_lines << "fileprivate var _emojiMapping: [String: String] = ["
      write_lines << "    " + @lines.join(",\n    ")
      write_lines << "]"
      write_lines << ""
      write_lines << "extension String {"
      write_lines << "    var emojiRendered: String {"
      write_lines << "        var str = self"
      write_lines << "        for key in _emojiMapping.keys {"
      write_lines << "            str = str.replacingOccurrences(of: key, with: _emojiMapping[key]!)"
      write_lines << "        }"
      write_lines << "        return str"
      write_lines << "    }"
      write_lines << "}"

      file = "Pipelines/Classes/Emojis.swift"
      lines = write_lines.join("\n")
      File.open(file, 'w') { |file| file.write(lines) }
      puts "Written to '#{file}'"
    end
  end
end

helper = Esites::ParseBuildkitEmojis.new
helper.run
