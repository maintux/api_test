class MultimediaFile::Video < MultimediaFile
  validates_presence_of :provider, :url

  PROVIDERS = ['youtube','vimeo','dailymotion']

  def type
    "video"
  end

  def video_id
    MultimediaFile::Video.regexp(provider).each do |pattern|
      regex = Regexp.new(pattern)
      if matches = regex.match(url)
        return matches[1]
      end
    end
    nil
  end

  def self.regexp provider
    case provider
    when 'youtube'
      return [
        '(?:https?:)?//www\.youtube(?:\-nocookie)?\.com/(?:v|e|embed)/([A-Za-z0-9\-_]+)',
        '(?:https?(?:a|vh?)?://)?(?:www\.)?youtube(?:\-nocookie)?\.com/watch\?.*v=([A-Za-z0-9\-_]+)',
        '(?:https?(?:a|vh?)?://)?youtu\.be/([A-Za-z0-9\-_]+)'
      ]
    when 'dailymotion'
      return [
        '//www\.dailymotion\.com/embed/video/([A-Za-z0-9]+)',
        '(?:https?://)?(?:www\.)?dailymotion\.com/video/([A-Za-z0-9]+)'
      ]
    when 'vimeo'
      return [
        '(?:https?:)?//player\.vimeo\.com/video/([0-9]+)',
        '(?:https?://)?(?:www\.)?vimeo\.com/([0-9]+)',
        '(?:https?://)?(?:www\.)?vimeo\.com/channels/(?:[A-Za-z0-9]+)/([0-9]+)'
      ]
    end
    []
  end

end
